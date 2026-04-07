import 'package:dio/dio.dart';
import 'package:expense/features/update/domain/models/update_info.dart';
import 'package:expense/features/update/domain/update_repository.dart';
import 'package:expense/shared/exceptions/app_exception.dart';

const _baseUrl =
    'https://s3.eu-central-1.wasabisys.com'
    '/savandbros-dist/expense/';
const _latestYmlUrl = '${_baseUrl}latest-android.yml';

class UpdateRepositoryImpl implements UpdateRepository {
  final Dio _dio;

  UpdateRepositoryImpl(this._dio);

  @override
  Future<UpdateInfo> fetchLatestVersion() async {
    final cacheBust = DateTime.now().millisecondsSinceEpoch;
    final response = await _dio.get<String>(
      _latestYmlUrl,
      queryParameters: {'v': cacheBust},
      options: Options(responseType: ResponseType.plain),
    );
    final body = response.data ?? '';
    String? version;
    String? path;
    for (final line in body.split('\n')) {
      if (line.startsWith('version:')) {
        version = line.replaceFirst('version:', '').trim();
      }
      if (line.startsWith('path:')) {
        path = line.replaceFirst('path:', '').trim();
      }
    }
    if (version == null || path == null) {
      throw AppException('Could not parse version from update manifest.');
    }
    return UpdateInfo(version: version, url: '$_baseUrl$path');
  }
}
