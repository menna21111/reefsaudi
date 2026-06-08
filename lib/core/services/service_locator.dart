import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';

import '../blocs/theme_bloc.dart';
import '../network/api_constant.dart';
import '../network/authorization_header.dart';
import '../network/network_info.dart';
import '../permissions/permission_cubit.dart';
import '../permissions/profile_storage.dart';
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
import '../../features/dashboard/data/datasources/statistics_remote_data_source.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/statistics_repository.dart';
import '../../features/dashboard/data/repositories/statistics_repository_impl.dart';
import '../../features/dashboard/domain/usecases/get_projects.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/cubit/global_statistics_cubit.dart';

// Project Imports
import '../../features/project/data/datasources/project_remote_data_source.dart';
import '../../features/project/data/repositories/project_repository_impl.dart';
import '../../features/project/domain/repositories/project_repository.dart';
import '../../features/project/presentation/cubit/project_statistics_cubit.dart';

// Risk Management Imports
import '../../features/risk_management/data/datasources/risk_remote_data_source.dart';
import '../../features/risk_management/data/repositories/risk_repository_impl.dart';
import '../../features/risk_management/domain/repositories/risk_repository.dart';
import '../../features/risk_management/presentation/cubit/risk_management_cubit.dart';

// Financial Requirements Imports
import '../../features/financial_requirements/data/datasources/financial_requirements_remote_data_source.dart';
import '../../features/financial_requirements/data/repositories/financial_requirements_repository_impl.dart';
import '../../features/financial_requirements/domain/repositories/financial_requirements_repository.dart';
import '../../features/financial_requirements/domain/usecases/get_financial_statements.dart';
import '../../features/financial_requirements/presentation/bloc/financial_requirements_bloc.dart';

final sl = GetIt.instance;

class ServiceLocator {
  void init() {
    if (sl.isRegistered<ThemeBloc>()) {
      sl.reset(dispose: true);
    }

    // Network & storage first (repositories depend on these)
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
    sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
    sl.registerLazySingleton<TokenStorage>(
      () => TokenFlutterSecureStorageService(sl()),
    );
    sl.registerLazySingleton<StorageOperations>(() => StorageServiceImpl(sl()));
    sl.registerLazySingleton<StorageService>(() => StorageService(sl()));

    // Blocs / Cubits
    sl.registerLazySingleton(() => ThemeBloc());
    sl.registerLazySingleton(() => PermissionCubit(sl()));
    sl.registerFactory(
      () => DashboardBloc(
        getProjectsUseCase: sl(),
        getDashboardStatsUseCase: sl(),
      ),
    );

    // UseCases
    sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
    sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));

    // Data sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<StatisticsRemoteDataSource>(
      () => StatisticsRemoteDataSourceImpl(),
    );

    // Repositories
    sl.registerLazySingleton(() => PmoDeviceService());
    sl.registerLazySingleton(() => ProfileStorage());
    sl.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
        tokenStorage: sl(),
        deviceService: sl(),
        permissionCubit: sl(),
      ),
    );
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerLazySingleton<StatisticsRepository>(
      () => StatisticsRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerFactory(() => GlobalStatisticsCubit(repository: sl()));

    sl.registerLazySingleton<ProjectRemoteDataSource>(
      () => ProjectRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ProjectRepository>(
      () => ProjectRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerFactory(() => ProjectStatisticsCubit(repository: sl()));
    sl.registerFactory(() => ProjectDetailsCubit(repository: sl()));
    sl.registerFactory(() => ProjectRisksCubit(repository: sl()));
    sl.registerFactory(() => ProjectBlueprintCubit(repository: sl()));

    sl.registerLazySingleton<RiskRemoteDataSource>(
      () => RiskRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<RiskRepository>(
      () => RiskRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerFactory(() => RiskManagementCubit(repository: sl()));

    sl.registerLazySingleton<FinancialRequirementsRemoteDataSource>(
      () => FinancialRequirementsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<FinancialRequirementsRepository>(
      () => FinancialRequirementsRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerLazySingleton(() => GetFinancialStatementsUseCase(sl()));
    sl.registerFactory(
      () => FinancialRequirementsBloc(
        getFinancialStatementsUseCase: sl(),
      ),
    );
  }
}
