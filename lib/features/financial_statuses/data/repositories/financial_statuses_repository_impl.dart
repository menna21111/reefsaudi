import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/financial_status.dart';
import '../../domain/repositories/financial_statuses_repository.dart';
import '../datasources/financial_statuses_remote_data_source.dart';

class FinancialStatusesRepositoryImpl implements FinancialStatusesRepository {
  FinancialStatusesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final FinancialStatusesRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, FinancialStatusListResult>> getFinancialStatuses({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getFinancialStatuses(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createFinancialStatus(
    FinancialStatusWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.createFinancialStatus(request));

  @override
  Future<Either<Failure, void>> updateFinancialStatus({
    required String id,
    required FinancialStatusWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updateFinancialStatus(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deleteFinancialStatus(String id) =>
      _guard(() => remoteDataSource.deleteFinancialStatus(id));
}
