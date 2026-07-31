import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/region.dart';
import '../../domain/repositories/regions_repository.dart';
import '../datasources/regions_remote_data_source.dart';

class RegionsRepositoryImpl implements RegionsRepository {
  RegionsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final RegionsRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, RegionListResult>> getRegions({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getRegions(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createRegion(RegionWriteRequest request) =>
      _guard(() => remoteDataSource.createRegion(request));

  @override
  Future<Either<Failure, void>> updateRegion({
    required String id,
    required RegionWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updateRegion(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deleteRegion(String id) =>
      _guard(() => remoteDataSource.deleteRegion(id));
}
