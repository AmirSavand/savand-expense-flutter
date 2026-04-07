import 'package:dio/dio.dart';
import 'package:expense/core/dio_client.dart';
import 'package:expense/core/storage_service.dart';
import 'package:expense/features/auth/data/auth_repository_impl.dart';
import 'package:expense/features/auth/domain/auth_repository.dart';
import 'package:expense/features/category/data/category_repository_impl.dart';
import 'package:expense/features/category/domain/category_repository.dart';
import 'package:expense/features/profile/data/profile_repository_impl.dart';
import 'package:expense/features/profile/domain/profile_repository.dart';
import 'package:expense/features/transaction/data/transaction_repository_impl.dart';
import 'package:expense/features/transaction/domain/transaction_repository.dart';
import 'package:expense/features/update/data/update_repository_impl.dart';
import 'package:expense/features/update/domain/update_repository.dart';
import 'package:expense/features/wallet/data/wallet_repository_impl.dart';
import 'package:expense/features/wallet/domain/wallet_repository.dart';
import 'package:get_it/get_it.dart';

/// Global service locator instance used throughout the app to resolve
/// dependencies.
GetIt getIt = GetIt.instance;

/// Registers all app-wide dependencies into the service locator.
/// Call this once in [main] before [runApp].
void setupServiceLocator() {
  getIt.registerLazySingleton<Dio>(() => createDioClient());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  getIt.registerLazySingleton<UpdateRepository>(
    () => UpdateRepositoryImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl());
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(),
  );
}
