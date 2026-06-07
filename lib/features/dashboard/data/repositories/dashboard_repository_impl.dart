import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/project_search_request.dart';
import '../models/project_search_response_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProjectSearchResult>> searchProjects(
    ProjectSearchRequest request,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final result = await remoteDataSource.searchProjects(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DashboardStats>> fetchDashboardStats(
    ProjectSearchRequest baseRequest,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final stats = await remoteDataSource.fetchDashboardStats(baseRequest);
      return Right(stats);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
