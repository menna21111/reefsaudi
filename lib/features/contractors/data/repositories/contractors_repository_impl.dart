import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/contractor.dart';
import '../../domain/repositories/contractors_repository.dart';
import '../datasources/contractors_remote_data_source.dart';

class ContractorsRepositoryImpl implements ContractorsRepository {
  ContractorsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final ContractorsRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, ContractorListResult>> getContractors({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getContractors(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createContractor(
    ContractorWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.createContractor(request));

  @override
  Future<Either<Failure, void>> updateContractor({
    required String id,
    required ContractorWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updateContractor(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deleteContractor(String id) =>
      _guard(() => remoteDataSource.deleteContractor(id));
}
