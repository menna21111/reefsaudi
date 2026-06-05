import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';

import '../blocs/theme_bloc.dart';
import '../network/api_constant.dart';
import '../network/authorization_header.dart';
import '../network/network_info.dart';
import 'auth_interceptor.dart';
import 'storage_service/storage.dart';
import 'storage_service/storage_impl.dart';

import 'storage_service/storage_operations.dart';
import 'pmo_device_service.dart';
import 'token_service/token_secure_storage.dart';
import 'token_service/token_storage.dart';

// Auth Imports
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

// Dashboard Imports
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
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

    // Data sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(sl()),
    );

    // Repositories
    sl.registerLazySingleton(() => PmoDeviceService());
    sl.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
        tokenStorage: sl(),
        deviceService: sl(),
      ),
    );
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );

    // Network Service
    sl.registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          receiveDataWhenStatusError: true,
          headers: AuthorizationHeader.defaultBaseHeaders(),
        ),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            await AuthorizationHeader.applyStandard(options, sl<TokenStorage>());
            return handler.next(options);
          },
        ),
      );
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

