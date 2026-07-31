import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/quality_repository.dart';
import '../datasources/quality_remote_data_source.dart';
import '../models/create_project_request_models.dart';
import '../../../project/data/models/project_api_models.dart';
import '../models/project_request_attachment_models.dart';
import '../models/project_request_counts_models.dart';
import '../models/project_request_detail_models.dart';
import '../models/project_request_history_models.dart';
import '../models/project_request_item_models.dart';
import '../models/project_request_list_filter.dart';
import '../models/project_request_summary_models.dart';
import '../models/project_request_task_action_models.dart';

class QualityRepositoryImpl implements QualityRepository {
  QualityRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final QualityRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, ProjectRequestSummaryResponse>> getSummary({
    String? projectId,
    String? approvalStatus,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final response = await remoteDataSource.getSummary(
        projectId: projectId,
        approvalStatus: approvalStatus,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectRequestListResponse>> getRequests({
    required ProjectRequestListKind kind,
    int skip = 0,
    int take = 12,
    String? approvalStatus,
    ProjectRequestListFilter filter = const ProjectRequestListFilter(),
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final response = await remoteDataSource.getRequests(
        kind: kind,
        skip: skip,
        take: take,
        approvalStatus: approvalStatus,
        filter: filter,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectRequestStatusCounts>> getRequestStatusCounts({
    required ProjectRequestListKind kind,
    ProjectRequestListFilter filter = const ProjectRequestListFilter(),
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final response = await remoteDataSource.getRequestStatusCounts(
        kind: kind,
        filter: filter,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectRequestDetail>> getRequestDetail(
    String id,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final detail = await remoteDataSource.getRequestDetail(id);
      return Right(detail);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectRequestHistoryItem>>> getRequestHistory(
    String id,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final history = await remoteDataSource.getRequestHistory(id);
      return Right(history);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectRequestAttachmentItem>>>
      getRequestAttachments(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final attachments = await remoteDataSource.getRequestAttachments(id);
      return Right(attachments);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<int>>> downloadAttachment({
    required String requestId,
    required String attachmentId,
    required String attachmentPath,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final bytes = await remoteDataSource.downloadAttachment(
        requestId: requestId,
        attachmentId: attachmentId,
        attachmentPath: attachmentPath,
      );
      return Right(bytes);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectDxItemDto>>> getProjects() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      return Right(await remoteDataSource.getProjects());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectRequestInsertNumbers>> getInsertNumbers({
    required String projectId,
    required int requestType,
    required int specialization,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final numbers = await remoteDataSource.getInsertNumbers(
        projectId: projectId,
        requestType: requestType,
        specialization: specialization,
      );
      return Right(numbers);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectRequestItem>> createRequest(
    CreateProjectRequestPayload payload,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final item = await remoteDataSource.createRequest(payload);
      return Right(item);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitTaskAction({
    required String taskId,
    required ProjectRequestTaskActionPayload payload,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      await remoteDataSource.submitTaskAction(
        taskId: taskId,
        payload: payload,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
