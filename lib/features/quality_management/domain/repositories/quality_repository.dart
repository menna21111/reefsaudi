import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/quality_remote_data_source.dart';
import '../../data/models/create_project_request_models.dart';
import '../../data/models/project_request_attachment_models.dart';
import '../../data/models/project_request_counts_models.dart';
import '../../data/models/project_request_detail_models.dart';
import '../../data/models/project_request_history_models.dart';
import '../../data/models/project_request_item_models.dart';
import '../../data/models/project_request_list_filter.dart';
import '../../data/models/project_request_summary_models.dart';
import '../../data/models/project_request_task_action_models.dart';
import '../../../project/data/models/project_api_models.dart';

abstract class QualityRepository {
  Future<Either<Failure, ProjectRequestSummaryResponse>> getSummary({
    String? projectId,
    String? approvalStatus,
  });

  Future<Either<Failure, ProjectRequestListResponse>> getRequests({
    required ProjectRequestListKind kind,
    int skip = 0,
    int take = 12,
    String? approvalStatus,
    ProjectRequestListFilter filter = const ProjectRequestListFilter(),
  });

  Future<Either<Failure, ProjectRequestStatusCounts>> getRequestStatusCounts({
    required ProjectRequestListKind kind,
    ProjectRequestListFilter filter = const ProjectRequestListFilter(),
  });

  Future<Either<Failure, ProjectRequestDetail>> getRequestDetail(String id);

  Future<Either<Failure, List<ProjectRequestHistoryItem>>> getRequestHistory(
    String id,
  );

  Future<Either<Failure, List<ProjectRequestAttachmentItem>>>
      getRequestAttachments(String id);

  Future<Either<Failure, List<int>>> downloadAttachment({
    required String requestId,
    required String attachmentId,
    required String attachmentPath,
  });

  Future<Either<Failure, List<ProjectDxItemDto>>> getProjects();

  Future<Either<Failure, ProjectRequestInsertNumbers>> getInsertNumbers({
    required String projectId,
    required int requestType,
    required int specialization,
  });

  Future<Either<Failure, ProjectRequestItem>> createRequest(
    CreateProjectRequestPayload payload,
  );

  Future<Either<Failure, void>> submitTaskAction({
    required String taskId,
    required ProjectRequestTaskActionPayload payload,
  });
}
