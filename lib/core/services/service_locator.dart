import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';

import '../blocs/theme_bloc.dart';
import '../network/api_constant.dart';
import '../network/network_info.dart';
import 'auth_interceptor.dart';
import 'storage_service/storage.dart';
import 'storage_service/storage_impl.dart';

import '../network/dio_helper.dart';
import 'storage_service/storage_operations.dart';
import 'token_service/token_secure_storage.dart';
import 'token_service/token_storage.dart';

// Dashboard Imports
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/usecases/get_projects.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

final sl = GetIt.instance;

class ServiceLocator {
  void init() {
    // Blocs
    sl.registerLazySingleton(() => ThemeBloc());
    sl.registerFactory(() => DashboardBloc(getProjectsUseCase: sl()));

    // UseCases
    sl.registerLazySingleton(() => GetProjectsUseCase(sl()));

    // Repositories
    sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl());

    // Network Service
    sl.registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      dio.interceptors.add(AuthInterceptor());
      return dio;
    });
    sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker(),
    );
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

    // Storage Service
    sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
    sl.registerLazySingleton<TokenStorage>(
      () => TokenFlutterSecureStorageService(sl()),
    );
    sl.registerLazySingleton<StorageOperations>(() => StorageServiceImpl(sl()));
    sl.registerLazySingleton<StorageService>(() => StorageService(sl()));
  }
}

