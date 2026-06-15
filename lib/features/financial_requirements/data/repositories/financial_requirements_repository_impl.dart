import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/paginated_financial_requirements.dart';
import '../../domain/repositories/financial_requirements_repository.dart';
import '../datasources/financial_requirements_remote_data_source.dart';
import '../models/create_financial_statement_request.dart';

class FinancialRequirementsRepositoryImpl
    implements FinancialRequirementsRepository {
  final FinancialRequirementsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FinancialRequirementsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedFinancialRequirements>> getFinancialStatements({
    required int pageNumber,
    required int pageSize,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      final response = await remoteDataSource.getFinancialStatements(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(response.toEntity(pageSize: pageSize));
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, FinancialStatementFormLookups>> getFormLookups() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      final projects = await remoteDataSource.getProjectsDx();
      final financialStatuses = await remoteDataSource.getFinancialStatusesDx();
      final pmStatuses = await remoteDataSource.getPmStatusesDx();

      return Right(
        FinancialStatementFormLookups(
          projects: projects,
          financialStatuses: financialStatuses,
          pmStatuses: pmStatuses,
        ),
      );
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createFinancialStatement(
    CreateFinancialStatementRequest request,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      await remoteDataSource.createFinancialStatement(request);
      return const Right(null);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
