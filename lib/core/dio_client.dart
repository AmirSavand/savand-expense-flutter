import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expense/core/service_locator.dart';
import 'package:expense/core/storage_service.dart';
import 'package:expense/shared/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// Base URL for all API requests.
String baseUrl() {
  if (kDebugMode) {
    return 'http://monolithic.local:8000/';
  }
  return 'https://monolithic-django.savandbros.com/';
}

/// Triggers when JWT expires.
final onJwtExpire = PublishSubject<void>();

/// Creates and configures a [Dio] HTTP client with base options and auth
/// interceptor.
Dio createDioClient() {
  // Storage service injection
  final storageService = getIt<StorageService>();

  // Logger instance
  final logger = Logger('Dio');

  // Setup dio
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl(),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
      responseType: ResponseType.json,
    ),
  );

  // Add logging
  if (kDebugMode) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          logger.log([
            response.requestOptions.method,
            response.statusCode.toString(),
            response.requestOptions.uri.path,
            response.requestOptions.uri.query,
          ]);
          handler.next(response);
        },
        onError: (error, handler) {
          logger.log([
            error.requestOptions.method,
            error.response?.statusCode.toString(),
            error.requestOptions.uri.path,
            error.requestOptions.uri.query,
          ]);
          handler.next(error);
        },
      ),
    );
  }

  // Add fake delay in debug mode
  if (kDebugMode) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          await Future.delayed(const Duration(milliseconds: 500));
          handler.next(response);
        },
        onError: (error, handler) async {
          await Future.delayed(const Duration(milliseconds: 500));
          handler.next(error);
        },
      ),
    );
  }

  // Add authorization
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storageService.access.read();
        if (token != null) {
          options.headers['Authorization'] = 'JWT $token';
        }
        handler.next(options);
      },
    ),
  );

  // Add un-authorization
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == HttpStatus.forbidden) {
          logger.log(['Authentication expired']);
          onJwtExpire.add(null);
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}
