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
import 'token_service/token_refresh_service.dart';
import 'token_service/token_secure_storage.dart';
import 'token_service/token_storage.dart';

// Auth Imports
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presination/cubit/auth_cubit.dart';

// Dashboard Imports
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/datasources/statistics_remote_data_source.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/statistics_repository.dart';
import '../../features/dashboard/data/repositories/statistics_repository_impl.dart';
import '../../features/dashboard/domain/usecases/get_projects.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/dashboard/presentation/cubit/global_statistics_cubit.dart';
import '../../features/dashboard/presentation/cubit/portfolio_overview_cubit.dart';

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

import '../../features/project/data/datasources/edit_project_remote_data_source.dart';
import '../../features/project/presentation/cubit/edit_project_cubit.dart';

// Financial Requirements Imports
import '../../features/financial_requirements/data/datasources/financial_requirements_remote_data_source.dart';
import '../../features/financial_requirements/data/repositories/financial_requirements_repository_impl.dart';
import '../../features/financial_requirements/domain/repositories/financial_requirements_repository.dart';
import '../../features/financial_requirements/domain/usecases/get_financial_statements.dart';
import '../../features/financial_requirements/presentation/bloc/financial_requirements_bloc.dart';
import '../../features/financial_requirements/presentation/cubit/financial_statement_form_cubit.dart';

import '../../features/quality_management/data/datasources/quality_remote_data_source.dart';
import '../../features/quality_management/data/repositories/quality_repository_impl.dart';
import '../../features/quality_management/domain/repositories/quality_repository.dart';
import '../../features/quality_management/presentation/cubit/quality_management_cubit.dart';

import '../../features/form_building/data/datasources/form_building_remote_data_source.dart';
import '../../features/form_building/data/repositories/form_building_repository_impl.dart';
import '../../features/form_building/domain/models/form_building_module.dart';
import '../../features/form_building/domain/repositories/form_building_repository.dart';
import '../../features/form_building/presentation/cubit/form_building_list_cubit.dart';

import '../../features/sectors/data/datasources/sectors_remote_data_source.dart';
import '../../features/sectors/data/repositories/sectors_repository_impl.dart';
import '../../features/sectors/domain/repositories/sectors_repository.dart';
import '../../features/sectors/presentation/cubit/sectors_cubit.dart';

import '../../features/regions/data/datasources/regions_remote_data_source.dart';
import '../../features/regions/data/repositories/regions_repository_impl.dart';
import '../../features/regions/domain/repositories/regions_repository.dart';
import '../../features/regions/presentation/cubit/regions_cubit.dart';

import '../../features/project_types/data/datasources/project_types_remote_data_source.dart';
import '../../features/project_types/data/repositories/project_types_repository_impl.dart';
import '../../features/project_types/domain/repositories/project_types_repository.dart';
import '../../features/project_types/presentation/cubit/project_types_cubit.dart';

import '../../features/project_templates/data/datasources/project_templates_remote_data_source.dart';
import '../../features/project_templates/data/repositories/project_templates_repository_impl.dart';
import '../../features/project_templates/domain/repositories/project_templates_repository.dart';
import '../../features/project_templates/presentation/cubit/project_templates_cubit.dart';

import '../../features/meetings/data/datasources/meetings_remote_data_source.dart';
import '../../features/meetings/data/repositories/meetings_repository_impl.dart';
import '../../features/meetings/domain/repositories/meetings_repository.dart';
import '../../features/meetings/presentation/cubit/meetings_cubit.dart';

import '../../features/financial_statuses/data/datasources/financial_statuses_remote_data_source.dart';
import '../../features/financial_statuses/data/repositories/financial_statuses_repository_impl.dart';
import '../../features/financial_statuses/domain/repositories/financial_statuses_repository.dart';
import '../../features/financial_statuses/presentation/cubit/financial_statuses_cubit.dart';

import '../../features/pm_statuses/data/datasources/pm_statuses_remote_data_source.dart';
import '../../features/pm_statuses/data/repositories/pm_statuses_repository_impl.dart';
import '../../features/pm_statuses/domain/repositories/pm_statuses_repository.dart';
import '../../features/pm_statuses/presentation/cubit/pm_statuses_cubit.dart';

import '../../features/project_stages/data/datasources/project_stages_remote_data_source.dart';
import '../../features/project_stages/data/repositories/project_stages_repository_impl.dart';
import '../../features/project_stages/domain/repositories/project_stages_repository.dart';
import '../../features/project_stages/presentation/cubit/project_stages_cubit.dart';

import '../../features/departments/data/datasources/departments_remote_data_source.dart';
import '../../features/departments/data/repositories/departments_repository_impl.dart';
import '../../features/departments/domain/repositories/departments_repository.dart';
import '../../features/departments/presentation/cubit/departments_cubit.dart';

import '../../features/positions/data/datasources/positions_remote_data_source.dart';
import '../../features/positions/data/repositories/positions_repository_impl.dart';
import '../../features/positions/domain/repositories/positions_repository.dart';
import '../../features/positions/presentation/cubit/positions_cubit.dart';

import '../../features/contractors/data/datasources/contractors_remote_data_source.dart';
import '../../features/contractors/data/repositories/contractors_repository_impl.dart';
import '../../features/contractors/domain/repositories/contractors_repository.dart';
import '../../features/contractors/presentation/cubit/contractors_cubit.dart';

import '../../features/roles/data/datasources/roles_remote_data_source.dart';
import '../../features/roles/data/repositories/roles_repository_impl.dart';
import '../../features/roles/domain/repositories/roles_repository.dart';
import '../../features/roles/presentation/cubit/roles_cubit.dart';

import '../../features/employees/data/datasources/employees_remote_data_source.dart';
import '../../features/employees/data/repositories/employees_repository_impl.dart';
import '../../features/employees/domain/repositories/employees_repository.dart';
import '../../features/employees/presentation/cubit/employees_cubit.dart';

// Fahim chat (WebSocket AI agent)
import '../../features/chat/core/services/audio_player_service.dart';
import '../../features/chat/core/services/audio_recorder_service.dart';
import '../../features/chat/core/services/connectivity_service.dart';
import '../../features/chat/core/services/websocket_service.dart';
import '../../features/chat/data/repos/websocket_chat_repository.dart';
import '../../features/chat/domain/repos/i_chat_repository.dart';
import '../../features/chat/presentation/logic/chat_cubit.dart';
import '../../features/user_chat/core/notifications_hub_service.dart';
import '../../features/user_chat/data/datasources/user_chat_remote_data_source.dart';
import '../../features/user_chat/data/repositories/user_chat_repository_impl.dart';

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
            await AuthorizationHeader.applyStandard(
              options,
              sl<TokenStorage>(),
            );
            return handler.next(options);
          },
        ),
      );
      dio.interceptors.add(AuthInterceptor(dio));
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
    sl.registerLazySingleton<TokenRefreshService>(
      () => TokenRefreshService(tokenStorage: sl(), deviceService: sl()),
    );
    sl.registerLazySingleton<StorageOperations>(() => StorageServiceImpl(sl()));
    sl.registerLazySingleton<StorageService>(() => StorageService(sl()));

    // Blocs / Cubits
    sl.registerLazySingleton(() => ThemeBloc());
    sl.registerLazySingleton(() => PermissionCubit(sl()));
    sl.registerLazySingleton(
      () => DashboardCubit(
        getProjectsUseCase: sl(),
        getDashboardStatsUseCase: sl(),
        filterDataSource: sl(),
      ),
    );
    sl.registerLazySingleton(() => PortfolioOverviewCubit(repository: sl()));

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
        tokenRefreshService: sl(),
        deviceService: sl(),
        permissionCubit: sl(),
      ),
    );
    sl.registerFactory(() => AuthCubit(repository: sl()));
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerLazySingleton<StatisticsRepository>(
      () => StatisticsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => GlobalStatisticsCubit(repository: sl()));

    sl.registerLazySingleton<ProjectRemoteDataSource>(
      () => ProjectRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ProjectRepository>(
      () => ProjectRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => ProjectStatisticsCubit(repository: sl()));
    sl.registerFactory(
      () => ProjectDetailsCubit(repository: sl(), editDataSource: sl()),
    );
    sl.registerFactory(
      () => ProjectRisksCubit(repository: sl<RiskRepository>()),
    );
    sl.registerFactory(() => ProjectBlueprintCubit(repository: sl()));
    sl.registerFactory(() => ProjectCharterCubit(repository: sl()));

    sl.registerLazySingleton<EditProjectRemoteDataSource>(
      () => EditProjectRemoteDataSourceImpl(),
    );
    sl.registerFactory(
      () => EditProjectCubit(dataSource: sl(), repository: sl()),
    );

    sl.registerLazySingleton<RiskRemoteDataSource>(
      () => RiskRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<RiskRepository>(
      () => RiskRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
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
        repository: sl(),
      ),
    );
    sl.registerFactory(() => FinancialStatementFormCubit(repository: sl()));

    sl.registerLazySingleton<QualityRemoteDataSource>(
      () => QualityRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<QualityRepository>(
      () => QualityRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => QualityManagementCubit(repository: sl()));

    sl.registerLazySingleton<FormBuildingRemoteDataSource>(
      () => FormBuildingRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<FormBuildingRepository>(
      () =>
          FormBuildingRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactoryParam<FormBuildingListCubit, FormBuildingModule, void>(
      (module, _) => FormBuildingListCubit(repository: sl(), module: module),
    );

    sl.registerLazySingleton<SectorsRemoteDataSource>(
      () => SectorsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<SectorsRepository>(
      () => SectorsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => SectorsCubit(repository: sl()));

    sl.registerLazySingleton<RegionsRemoteDataSource>(
      () => RegionsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<RegionsRepository>(
      () => RegionsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => RegionsCubit(repository: sl()));

    sl.registerLazySingleton<ProjectTypesRemoteDataSource>(
      () => ProjectTypesRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ProjectTypesRepository>(
      () =>
          ProjectTypesRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => ProjectTypesCubit(repository: sl()));

    sl.registerLazySingleton<FinancialStatusesRemoteDataSource>(
      () => FinancialStatusesRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<FinancialStatusesRepository>(
      () => FinancialStatusesRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerFactory(() => FinancialStatusesCubit(repository: sl()));

    sl.registerLazySingleton<PmStatusesRemoteDataSource>(
      () => PmStatusesRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<PmStatusesRepository>(
      () => PmStatusesRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => PmStatusesCubit(repository: sl()));

    sl.registerLazySingleton<ProjectStagesRemoteDataSource>(
      () => ProjectStagesRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ProjectStagesRepository>(
      () => ProjectStagesRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerFactory(() => ProjectStagesCubit(repository: sl()));

    sl.registerLazySingleton<DepartmentsRemoteDataSource>(
      () => DepartmentsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<DepartmentsRepository>(
      () =>
          DepartmentsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => DepartmentsCubit(repository: sl()));

    sl.registerLazySingleton<PositionsRemoteDataSource>(
      () => PositionsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<PositionsRepository>(
      () => PositionsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => PositionsCubit(repository: sl()));

    sl.registerLazySingleton<ContractorsRemoteDataSource>(
      () => ContractorsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ContractorsRepository>(
      () =>
          ContractorsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => ContractorsCubit(repository: sl()));

    sl.registerLazySingleton<RolesRemoteDataSource>(
      () => RolesRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<RolesRepository>(
      () => RolesRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => RolesCubit(repository: sl()));

    sl.registerLazySingleton<EmployeesRemoteDataSource>(
      () => EmployeesRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<EmployeesRepository>(
      () => EmployeesRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => EmployeesCubit(repository: sl()));

    sl.registerLazySingleton<ProjectTemplatesRemoteDataSource>(
      () => ProjectTemplatesRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<ProjectTemplatesRepository>(
      () => ProjectTemplatesRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerFactory(() => ProjectTemplatesCubit(repository: sl()));

    sl.registerLazySingleton<MeetingsRemoteDataSource>(
      () => MeetingsRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<MeetingsRepository>(
      () => MeetingsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerFactory(() => MeetingsCubit(repository: sl()));

    // Fahim AI agent (chat / voice)
    sl.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService(sl<InternetConnectionChecker>()),
    );
    sl.registerLazySingleton<WebSocketService>(
      () => WebSocketService(sl<ConnectivityService>()),
    );
    sl.registerLazySingleton<AudioRecorderService>(AudioRecorderService.new);
    sl.registerLazySingleton<AudioPlayerService>(AudioPlayerService.new);
    sl.registerLazySingleton<IChatRepository>(
      () => WebSocketChatRepository(sl()),
    );
    sl.registerFactory<ChatCubit>(
      () => ChatCubit(sl(), sl(), sl<ConnectivityService>()),
    );

    // User-to-user chat (SignalR notifications hub)
    sl.registerLazySingleton<UserChatRemoteDataSource>(
      () => UserChatRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<UserChatRepository>(
      () => UserChatRepositoryImpl(sl()),
    );
    sl.registerLazySingleton<NotificationsHubService>(
      () => NotificationsHubService(sl()),
    );
  }
}
