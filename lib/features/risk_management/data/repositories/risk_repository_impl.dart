import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/risk_repository.dart';
import '../datasources/risk_remote_data_source.dart';
import '../models/project_risk_models.dart';
import '../../../project/data/models/project_api_models.dart';

class RiskRepositoryImpl implements RiskRepository {
  RiskRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final RiskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectRiskListResponse>> getProjectRisks({
    int skip = 0,
    int take = 10,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getProjectRisks(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, ProjectRiskListResponse>> getProjectRisksByProjectId(
    String projectId, {
    int skip = 0,
    int take = 10,
  }) =>
      _guard(
        () => remoteDataSource.getProjectRisksByProjectId(
          projectId,
          skip: skip,
          take: take,
        ),
      );

  @override
  Future<Either<Failure, void>> createProjectRisk(
    CreateProjectRiskRequest request,
  ) =>
      _guard(() => remoteDataSource.createProjectRisk(request));

  @override
  Future<Either<Failure, void>> createProjectRiskForProject({
    required String projectId,
    required ProjectRiskWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.createProjectRiskForProject(
          projectId: projectId,
          request: request,
        ),
      );

  @override
  Future<Either<Failure, void>> updateProjectRisk(
    ProjectRiskWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.updateProjectRisk(request));

  @override
  Future<Either<Failure, void>> deleteProjectRisk(String riskId) =>
      _guard(() => remoteDataSource.deleteProjectRisk(riskId));

  @override
  Future<Either<Failure, List<ProjectDxItemDto>>> getProjects() =>
      _guard(remoteDataSource.getProjects);

  @override
  Future<Either<Failure, List<AccountDxItemDto>>> getAccounts() =>
      _guard(remoteDataSource.getAccounts);
}
