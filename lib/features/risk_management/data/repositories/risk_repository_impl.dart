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

  @override
  Future<Either<Failure, ProjectRiskListResponse>> getProjectRisks({
    int skip = 0,
    int take = 10,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final response = await remoteDataSource.getProjectRisks(
        skip: skip,
        take: take,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createProjectRisk(
    CreateProjectRiskRequest request,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      await remoteDataSource.createProjectRisk(request);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectDxItemDto>>> getProjects() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final projects = await remoteDataSource.getProjects();
      return Right(projects);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AccountDxItemDto>>> getAccounts() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final accounts = await remoteDataSource.getAccounts();
      return Right(accounts);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
