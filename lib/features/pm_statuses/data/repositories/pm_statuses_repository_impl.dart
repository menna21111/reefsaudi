import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/pm_status.dart';
import '../../domain/repositories/pm_statuses_repository.dart';
import '../datasources/pm_statuses_remote_data_source.dart';

class PmStatusesRepositoryImpl implements PmStatusesRepository {
  PmStatusesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final PmStatusesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }
    try {
      return Right(await call());
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, PmStatusListResult>> getPmStatuses({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getPmStatuses(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createPmStatus(PmStatusWriteRequest request) =>
      _guard(() => remoteDataSource.createPmStatus(request));

  @override
  Future<Either<Failure, void>> updatePmStatus({
    required String id,
    required PmStatusWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updatePmStatus(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deletePmStatus(String id) =>
      _guard(() => remoteDataSource.deletePmStatus(id));
}
