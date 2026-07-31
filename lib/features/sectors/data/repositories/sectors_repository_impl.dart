import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/sector.dart';
import '../../domain/repositories/sectors_repository.dart';
import '../datasources/sectors_remote_data_source.dart';

class SectorsRepositoryImpl implements SectorsRepository {
  SectorsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final SectorsRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, SectorListResult>> getSectors({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getSectors(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createSector(SectorWriteRequest request) =>
      _guard(() => remoteDataSource.createSector(request));

  @override
  Future<Either<Failure, void>> updateSector({
    required String id,
    required SectorWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updateSector(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deleteSector(String id) =>
      _guard(() => remoteDataSource.deleteSector(id));
}
