import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/position.dart';
import '../../domain/repositories/positions_repository.dart';
import '../datasources/positions_remote_data_source.dart';

class PositionsRepositoryImpl implements PositionsRepository {
  PositionsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final PositionsRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, PositionListResult>> getPositions({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getPositions(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createPosition(PositionWriteRequest request) =>
      _guard(() => remoteDataSource.createPosition(request));

  @override
  Future<Either<Failure, void>> updatePosition({
    required String id,
    required PositionWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updatePosition(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deletePosition(String id) =>
      _guard(() => remoteDataSource.deletePosition(id));
}
