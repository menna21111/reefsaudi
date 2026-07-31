import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../domain/entities/financial_statement_summary.dart';
import '../../domain/entities/paginated_financial_requirements.dart';
import '../../domain/repositories/financial_requirements_repository.dart';
import '../datasources/financial_requirements_remote_data_source.dart';
import '../models/create_financial_statement_request.dart';
import '../models/dx_title_item_dto.dart';

class FinancialRequirementsRepositoryImpl
    implements FinancialRequirementsRepository {
  final FinancialRequirementsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FinancialRequirementsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedFinancialRequirements>>
  getFinancialStatements({
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
  Future<Either<Failure, FinancialStatementSummary>> getStatementCount() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      return Right(await remoteDataSource.getStatementCount());
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, FinancialStatementSummary>> getStatementSum() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      return Right(await remoteDataSource.getStatementSum());
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, FinancialStatementFormLookups>>
  getFormLookups() async {
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

  @override
  Future<Either<Failure, List<ProjectDxItemDto>>> getProjectsDx() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      return Right(await remoteDataSource.getProjectsDx());
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DxTitleItemDto>>> getFinancialStatusesDx() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      return Right(await remoteDataSource.getFinancialStatusesDx());
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DxTitleItemDto>>> getPmStatusesDx() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      return Right(await remoteDataSource.getPmStatusesDx());
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFinancialStatement(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      await remoteDataSource.deleteFinancialStatement(id);
      return const Right(null);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
