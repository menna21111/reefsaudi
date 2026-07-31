import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../project/data/models/project_api_models.dart';
import '../models/create_project_request_models.dart';
import '../models/project_request_attachment_models.dart';
import '../models/project_request_counts_models.dart';
import '../models/project_request_detail_models.dart';
import '../models/project_request_history_models.dart';
import '../models/project_request_item_models.dart';
import '../models/project_request_list_filter.dart';
import '../models/project_request_summary_models.dart';
import '../models/project_request_task_action_models.dart';

enum ProjectRequestListKind {
  myRequests,
  approvalTasks,
  archive,
}

abstract class QualityRemoteDataSource {
  Future<ProjectRequestSummaryResponse> getSummary({
    String? projectId,
    String? approvalStatus,
  });

  Future<ProjectRequestListResponse> getRequests({
    required ProjectRequestListKind kind,
    int skip = 0,
    int take = 12,
    String? approvalStatus,
    ProjectRequestListFilter filter = const ProjectRequestListFilter(),
  });

  Future<ProjectRequestStatusCounts> getRequestStatusCounts({
    required ProjectRequestListKind kind,
    ProjectRequestListFilter filter = const ProjectRequestListFilter(),
  });

  Future<ProjectRequestDetail> getRequestDetail(String id);

  Future<List<ProjectRequestHistoryItem>> getRequestHistory(String id);

  Future<List<ProjectRequestAttachmentItem>> getRequestAttachments(String id);

  Future<List<int>> downloadAttachment({
    required String requestId,
    required String attachmentId,
    required String attachmentPath,
  });

  Future<List<ProjectDxItemDto>> getProjects();

  Future<ProjectRequestInsertNumbers> getInsertNumbers({
    required String projectId,
    required int requestType,
    required int specialization,
  });

  Future<ProjectRequestItem> createRequest(CreateProjectRequestPayload payload);

  Future<void> submitTaskAction({
    required String taskId,
    required ProjectRequestTaskActionPayload payload,
  });
}

class QualityRemoteDataSourceImpl implements QualityRemoteDataSource {
  static const String _undefined = 'undefined';

  String _endpointFor(ProjectRequestListKind kind) {
    return switch (kind) {
      ProjectRequestListKind.myRequests => PmoEndpoints.projectRequestsMyRequests,
      ProjectRequestListKind.approvalTasks => PmoEndpoints.requestTaskMyTasks,
      ProjectRequestListKind.archive => PmoEndpoints.projectRequestsArchive,
    };
  }

  String _countsEndpointFor(ProjectRequestListKind kind) {
    return switch (kind) {
      ProjectRequestListKind.myRequests =>
        PmoEndpoints.projectRequestsMyRequestsCounts,
      ProjectRequestListKind.approvalTasks =>
        PmoEndpoints.requestTaskMyTasksCounts,
      ProjectRequestListKind.archive =>
        PmoEndpoints.projectRequestsMyRequestsCounts,
    };
  }

  @override
  Future<ProjectRequestSummaryResponse> getSummary({
    String? projectId,
    String? approvalStatus,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRequestsSummary,
      query: {
        'projectId': projectId ?? _undefined,
        'approvalStatus': approvalStatus ?? _undefined,
      },
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project requests summary response');
    }
    return ProjectRequestSummaryResponse.fromJson(body);
  }

  @override
  Future<ProjectRequestListResponse> getRequests({
    required ProjectRequestListKind kind,
    int skip = 0,
    int take = 12,
    String? approvalStatus,
    ProjectRequestListFilter filter = const ProjectRequestListFilter(),
  }) async {
    final query = <String, dynamic>{
      'skip': skip,
      'take': take,
      'requireTotalCount': true,
      'filter': filter.toDevExtremeFilterJson(),
    };

    if (kind == ProjectRequestListKind.approvalTasks) {
      query['isApproved'] = approvalStatus ?? _undefined;
    } else {
      query['approvalStatus'] = approvalStatus ?? 'null';
    }

    final response = await DioHelper.getData(
      url: _endpointFor(kind),
      query: query,
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project requests list response');
    }
    return ProjectRequestListResponse.fromJson(body);
  }

  @override
  Future<ProjectRequestStatusCounts> getRequestStatusCounts({
    required ProjectRequestListKind kind,
    ProjectRequestListFilter filter = const ProjectRequestListFilter(),
  }) async {
    final query = <String, dynamic>{};
    final fromDate = filter.countsFromDateParam();
    final toDate = filter.countsToDateParam();
    if (fromDate != null) query['fromDate'] = fromDate;
    if (toDate != null) query['toDate'] = toDate;

    final response = await DioHelper.getData(
      url: _countsEndpointFor(kind),
      query: query.isEmpty ? null : query,
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project request counts response');
    }
    return ProjectRequestStatusCounts.fromJson(body);
  }

  @override
  Future<ProjectRequestDetail> getRequestDetail(String id) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRequestById(id),
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project request detail response');
    }
    return ProjectRequestDetail.fromJson(body);
  }

  @override
  Future<List<ProjectRequestHistoryItem>> getRequestHistory(String id) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRequestHistory(id),
    );
    return parseProjectRequestHistory(response.data);
  }

  @override
  Future<List<ProjectRequestAttachmentItem>> getRequestAttachments(
    String id,
  ) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRequestAttachmentsHierarchy(id),
      query: const {'isFlatView': true},
    );
    return parseProjectRequestAttachments(response.data);
  }

  @override
  Future<List<int>> downloadAttachment({
    required String requestId,
    required String attachmentId,
    required String attachmentPath,
  }) async {
    final resolvedId = _resolveAttachmentId(attachmentId, attachmentPath);

    // 1) Primary: GET /ProjectRequests/attachments/{attachmentId}
    if (resolvedId != null) {
      try {
        final byId = await DioHelper.getData(
          url: PmoEndpoints.projectRequestAttachmentById(resolvedId),
          responseType: ResponseType.bytes,
        );
        return _asAttachmentBytes(byId.data);
      } catch (_) {
        // Fall through to media URL / legacy download.
      }
    }

    // 2) Media CDN: /api/media/{attachmentPath}?token=...
    final token = await DioHelper.getAccessToken();
    final mediaUrl = ApiConstants.resolveAttachmentMediaUrl(
      attachmentPath,
      token: token,
    );
    if (mediaUrl != null && mediaUrl.isNotEmpty) {
      try {
        final media = await DioHelper.getData(
          url: mediaUrl,
          responseType: ResponseType.bytes,
        );
        return _asAttachmentBytes(media.data);
      } catch (_) {
        // Fall through to legacy query download.
      }
    }

    // 3) Legacy (often 404 — not in swagger)
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRequestAttachmentDownload,
      query: {
        'requestId': requestId,
        'attachmentPath': attachmentPath,
      },
      responseType: ResponseType.bytes,
    );
    return _asAttachmentBytes(response.data);
  }

  /// Prefer a real UUID; otherwise take the last segment of attachmentPath.
  String? _resolveAttachmentId(String attachmentId, String attachmentPath) {
    final id = attachmentId.trim();
    if (_isUuid(id)) return id;

    final segments = attachmentPath
        .trim()
        .replaceAll('\\', '/')
        .split('/')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    if (segments.isEmpty) return null;
    final last = segments.last.trim();
    return _isUuid(last) ? last : null;
  }

  bool _isUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  List<int> _asAttachmentBytes(dynamic data) {
    if (data is Uint8List) return data;
    if (data is List<int>) return data;
    if (data is List) return data.cast<int>();
    throw const FormatException('Unexpected attachment download response');
  }

  @override
  Future<List<ProjectDxItemDto>> getProjects() async {
    final response = await DioHelper.getData(url: PmoEndpoints.projectDxList);
    final body = response.data as Map<String, dynamic>;
    return parseProjectDxItems(body['data']);
  }

  @override
  Future<ProjectRequestInsertNumbers> getInsertNumbers({
    required String projectId,
    required int requestType,
    required int specialization,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRequestsInsertNumbers,
      query: {
        'projectId': projectId,
        'requestType': requestType,
        'specialization': specialization,
      },
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected insert numbers response');
    }
    return ProjectRequestInsertNumbers.fromJson(body);
  }

  @override
  Future<ProjectRequestItem> createRequest(
    CreateProjectRequestPayload payload,
  ) async {
    final response = await DioHelper.postData(
      url: PmoEndpoints.projectRequestsCreate,
      data: await payload.toFormData(),
    );

    final body = response.data;
    return ProjectRequestItem.fromCreateResponse(
      body,
      serialNumber: payload.serialNumber,
      reviewNumber: payload.reviewNumber,
      requestDate: payload.requestDate,
      projectId: payload.projectId,
      requestType: payload.requestType,
      specialization: payload.specialization,
      description: payload.description,
    );
  }

  @override
  Future<void> submitTaskAction({
    required String taskId,
    required ProjectRequestTaskActionPayload payload,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.projectRequestTaskAction(taskId),
      data: await payload.toFormData(),
      legacyAuthQuery: false,
    );
  }
}
