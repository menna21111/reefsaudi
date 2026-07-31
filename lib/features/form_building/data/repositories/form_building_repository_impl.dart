import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/form_building_item.dart';
import '../../domain/models/form_building_module.dart';
import '../../domain/repositories/form_building_repository.dart';
import '../datasources/form_building_remote_data_source.dart';

class FormBuildingRepositoryImpl implements FormBuildingRepository {
  FormBuildingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final FormBuildingRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, FormBuildingListResult>> getItems({
    required FormBuildingModule module,
    int skip = 0,
    int take = 100,
  }) => _guard(
    () => remoteDataSource.getItems(module: module, skip: skip, take: take),
  );
}
