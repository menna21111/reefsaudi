import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/enums.dart';
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
import '../../domain/models/task_approval_decision.dart';
import '../../domain/repositories/quality_repository.dart';
import '../constants/quality_form_options.dart';
import '../constants/request_type_config.dart';

part 'quality_management_state.dart';

class QualityManagementCubit extends Cubit<QualityManagementState> {
  QualityManagementCubit({required QualityRepository repository})
      : _repository = repository,
        super(const QualityManagementState());

  final QualityRepository _repository;
  static const int _pageSize = 12;

  // ── Statistics ────────────────────────────────────────────────────────────

  Future<void> loadStatistics({String? approvalStatus}) async {
    emit(state.copyWith(
      statisticsStatus: RequestStatus.loading,
      statisticsApprovalStatus: approvalStatus,
      statisticsError: '',
    ));

    final result = await _repository.getSummary(approvalStatus: approvalStatus);
    result.fold(
      (failure) => emit(state.copyWith(
        statisticsStatus: RequestStatus.error,
        statisticsError: failure.errMessage,
      )),
      (response) => emit(state.copyWith(
        statisticsStatus: RequestStatus.success,
        statisticsItems: response.data,
        statisticsProcessedTotal: response.processedTotal,
      )),
    );
  }

  // ── Requests list ─────────────────────────────────────────────────────────

  void initRequests(ProjectRequestListKind kind) {
    final defaultFilter = QualityListFilterConfig.defaultValueFor(kind);
    emit(state.copyWith(
      requestsKind: kind,
      requestsStatus: RequestStatus.initial,
      requestsItems: const [],
      requestsTotalCount: 0,
      requestsApprovalStatus: defaultFilter,
      requestsListFilter: const ProjectRequestListFilter(),
      clearRequestsStatusCounts: true,
      requestsCountsStatus: RequestStatus.initial,
      requestsError: '',
    ));
  }

  Future<void> loadRequests({
    ProjectRequestListKind? kind,
    String? approvalStatus,
    ProjectRequestListFilter? listFilter,
    bool reloadCounts = true,
  }) async {
    final activeKind = kind ?? state.requestsKind;
    if (activeKind == null) return;

    final activeFilter = approvalStatus ?? state.requestsApprovalStatus;
    final activeListFilter = listFilter ?? state.requestsListFilter;

    emit(state.copyWith(
      requestsKind: activeKind,
      requestsApprovalStatus: activeFilter,
      requestsListFilter: activeListFilter,
      requestsItems: const [],
      requestsTotalCount: 0,
      requestsFilterLoading: true,
      requestsRefreshing: false,
      requestsLoadingMore: false,
      requestsError: '',
    ));

    if (reloadCounts) {
      unawaited(_loadStatusCounts(kind: activeKind, filter: activeListFilter));
    }

    final result = await _repository.getRequests(
      kind: activeKind,
      skip: 0,
      take: _pageSize,
      approvalStatus: activeFilter,
      filter: activeListFilter,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        requestsStatus: RequestStatus.error,
        requestsFilterLoading: false,
        requestsError: failure.errMessage,
      )),
      (response) => emit(state.copyWith(
        requestsStatus: RequestStatus.success,
        requestsFilterLoading: false,
        requestsItems: response.data,
        requestsTotalCount: response.totalCount,
      )),
    );
  }

  Future<void> refreshRequests() async {
    final kind = state.requestsKind;
    if (kind == null) return;

    emit(state.copyWith(requestsRefreshing: true, requestsError: ''));
    unawaited(
      _loadStatusCounts(kind: kind, filter: state.requestsListFilter),
    );

    final result = await _repository.getRequests(
      kind: kind,
      skip: 0,
      take: _pageSize,
      approvalStatus: state.requestsApprovalStatus,
      filter: state.requestsListFilter,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        requestsRefreshing: false,
        requestsError: failure.errMessage,
      )),
      (response) => emit(state.copyWith(
        requestsItems: response.data,
        requestsTotalCount: response.totalCount,
        requestsRefreshing: false,
      )),
    );
  }

  Future<void> loadMoreRequests() async {
    final kind = state.requestsKind;
    if (kind == null ||
        state.requestsLoadingMore ||
        !state.requestsHasMore ||
        state.requestsStatus != RequestStatus.success) {
      return;
    }

    emit(state.copyWith(requestsLoadingMore: true));

    final result = await _repository.getRequests(
      kind: kind,
      skip: state.requestsItems.length,
      take: _pageSize,
      approvalStatus: state.requestsApprovalStatus,
      filter: state.requestsListFilter,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        requestsLoadingMore: false,
        requestsError: failure.errMessage,
      )),
      (response) => emit(state.copyWith(
        requestsItems: [...state.requestsItems, ...response.data],
        requestsTotalCount: response.totalCount,
        requestsLoadingMore: false,
      )),
    );
  }

  void prependRequestItem(ProjectRequestItem item) {
    if (state.requestsKind != ProjectRequestListKind.myRequests) return;
    emit(state.copyWith(
      requestsItems: [item, ...state.requestsItems],
      requestsTotalCount: state.requestsTotalCount + 1,
    ));
  }

  Future<void> changeRequestsFilter(String approvalStatus) async {
    if (approvalStatus == state.requestsApprovalStatus &&
        state.requestsStatus == RequestStatus.success) {
      return;
    }

    await loadRequests(approvalStatus: approvalStatus, reloadCounts: false);
  }

  Future<void> changeRequestTypeFilter(int? requestType) async {
    final next = state.requestsListFilter.copyWith(
      requestType: requestType,
      clearRequestType: requestType == null,
    );
    if (next.requestType == state.requestsListFilter.requestType &&
        state.requestsStatus == RequestStatus.success) {
      return;
    }
    await loadRequests(listFilter: next, reloadCounts: false);
  }

  Future<void> changeDateRangeFilter({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final next = state.requestsListFilter.copyWith(
      fromDate: fromDate,
      toDate: toDate,
      clearDates: fromDate == null || toDate == null,
    );
    await loadRequests(listFilter: next);
  }

  Future<void> clearListFilters() async {
    if (!state.requestsListFilter.hasListFilter &&
        state.requestsStatus == RequestStatus.success) {
      return;
    }
    await loadRequests(listFilter: const ProjectRequestListFilter());
  }

  Future<void> _loadStatusCounts({
    required ProjectRequestListKind kind,
    required ProjectRequestListFilter filter,
  }) async {
    if (kind == ProjectRequestListKind.archive) return;

    emit(state.copyWith(requestsCountsStatus: RequestStatus.loading));

    final countsFilter = filter.hasDateRange
        ? filter
        : filter.copyWith(
            fromDate: DateTime.now().subtract(const Duration(days: 30)),
            toDate: DateTime.now(),
          );

    final result = await _repository.getRequestStatusCounts(
      kind: kind,
      filter: countsFilter,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        requestsCountsStatus: RequestStatus.error,
        clearRequestsStatusCounts: true,
      )),
      (counts) => emit(state.copyWith(
        requestsCountsStatus: RequestStatus.success,
        requestsStatusCounts: counts,
      )),
    );
  }

  // ── Detail ────────────────────────────────────────────────────────────────

  Future<void> loadDetail(String requestId) async {
    emit(state.copyWith(
      detailStatus: RequestStatus.loading,
      detailRequestId: requestId,
      detail: null,
      detailHistory: const [],
      detailAttachments: const [],
      detailHistoryStatus: RequestStatus.initial,
      detailAttachmentsStatus: RequestStatus.initial,
      detailError: '',
      clearTaskActionError: true,
      taskActionStatus: RequestStatus.initial,
    ));

    final detailResult = await _repository.getRequestDetail(requestId);
    detailResult.fold(
      (failure) => emit(state.copyWith(
        detailStatus: RequestStatus.error,
        detailError: failure.errMessage,
      )),
      (detail) {
        emit(state.copyWith(
          detail: detail,
          detailStatus: RequestStatus.success,
        ));
        unawaited(loadDetailHistory(requestId));
        unawaited(loadDetailAttachments(requestId));
      },
    );
  }

  Future<void> loadDetailHistory([String? requestId]) async {
    final id = requestId ?? state.detailRequestId;
    if (id == null) return;

    emit(state.copyWith(detailHistoryStatus: RequestStatus.loading));

    final result = await _repository.getRequestHistory(id);
    result.fold(
      (failure) => emit(state.copyWith(
        detailHistoryStatus: RequestStatus.error,
      )),
      (history) => emit(state.copyWith(
        detailHistory: history,
        detailHistoryStatus: RequestStatus.success,
      )),
    );
  }

  Future<void> loadDetailAttachments([String? requestId]) async {
    final id = requestId ?? state.detailRequestId;
    if (id == null) return;

    emit(state.copyWith(detailAttachmentsStatus: RequestStatus.loading));

    final result = await _repository.getRequestAttachments(id);
    result.fold(
      (failure) => emit(state.copyWith(
        detailAttachmentsStatus: RequestStatus.error,
      )),
      (attachments) => emit(state.copyWith(
        detailAttachments: attachments,
        detailAttachmentsStatus: RequestStatus.success,
      )),
    );
  }

  Future<void> refreshDetailAttachments() => loadDetailAttachments();

  Future<bool> submitTaskAction({
    TaskApprovalDecision? decision,
    int? approvalId,
    String comment = '',
    String? attachmentPath,
  }) async {
    final taskId = state.detail?.currentTask?.id?.trim();
    final requestId = state.detailRequestId;
    if (taskId == null || taskId.isEmpty || requestId == null) {
      emit(state.copyWith(
        taskActionStatus: RequestStatus.error,
        taskActionError: AppString.noCurrentTask,
      ));
      return false;
    }

    emit(state.copyWith(
      taskActionStatus: RequestStatus.loading,
      clearTaskActionError: true,
    ));

    final result = await _repository.submitTaskAction(
      taskId: taskId,
      payload: ProjectRequestTaskActionPayload(
        decision: decision,
        approvalId: approvalId,
        comment: comment,
        attachmentPath: attachmentPath,
      ),
    );

    final failureMessage = result.fold(
      (failure) => failure.errMessage,
      (_) => null,
    );
    if (failureMessage != null) {
      emit(state.copyWith(
        taskActionStatus: RequestStatus.error,
        taskActionError: failureMessage,
      ));
      return false;
    }

    emit(state.copyWith(taskActionStatus: RequestStatus.success));
    await loadDetail(requestId);
    return true;
  }

  Future<List<int>?> downloadAttachment(
    ProjectRequestAttachmentItem item,
  ) async {
    return downloadAttachmentByPath(
      attachmentId: item.id,
      attachmentPath: item.attachmentPath,
    );
  }

  Future<List<int>?> downloadAttachmentQuiet(
    ProjectRequestAttachmentItem item,
  ) async {
    final requestId = state.detailRequestId;
    if (requestId == null) return null;

    final result = await _repository.downloadAttachment(
      requestId: requestId,
      attachmentId: item.id,
      attachmentPath: item.attachmentPath,
    );

    return result.fold((_) => null, (bytes) => bytes);
  }

  Future<List<int>?> downloadAttachmentByPath({
    required String attachmentId,
    required String attachmentPath,
  }) async {
    final requestId = state.detailRequestId;
    if (requestId == null) return null;

    emit(state.copyWith(
      isDownloadingAttachment: true,
      downloadingAttachmentId: attachmentId,
    ));

    final result = await _repository.downloadAttachment(
      requestId: requestId,
      attachmentId: attachmentId,
      attachmentPath: attachmentPath,
    );
    emit(state.copyWith(
      isDownloadingAttachment: false,
      clearDownloadingAttachmentId: true,
    ));

    return result.fold((_) => null, (bytes) => bytes);
  }

  // ── Create request ────────────────────────────────────────────────────────

  Future<void> loadInsertNumbers({
    required String projectId,
    required int requestType,
    required int specialization,
  }) async {
    emit(state.copyWith(
      createNumbersStatus: RequestStatus.loading,
      clearSerialNumber: true,
      clearReviewNumber: true,
      clearCreateError: true,
    ));

    final result = await _repository.getInsertNumbers(
      projectId: projectId,
      requestType: requestType,
      specialization: specialization,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        createNumbersStatus: RequestStatus.error,
        createError: failure.errMessage,
      )),
      (numbers) => emit(state.copyWith(
        createNumbersStatus: RequestStatus.success,
        serialNumber: numbers.serialNumber,
        reviewNumber: numbers.reviewNumber,
      )),
    );
  }

  Future<ProjectRequestItem?> submitCreateRequest(
    CreateProjectRequestPayload payload, {
    required String projectName,
  }) async {
    emit(state.copyWith(
      createSubmitStatus: RequestStatus.loading,
      clearCreateError: true,
    ));

    final result = await _repository.createRequest(payload);

    return result.fold(
      (failure) {
        emit(state.copyWith(
          createSubmitStatus: RequestStatus.error,
          createError: failure.errMessage,
        ));
        return null;
      },
      (item) {
        emit(state.copyWith(createSubmitStatus: RequestStatus.success));
        return ProjectRequestItem(
          id: item.id,
          serialNumber: item.serialNumber.isNotEmpty
              ? item.serialNumber
              : '${payload.serialNumber}',
          reviewNumber: item.reviewNumber.isNotEmpty
              ? item.reviewNumber
              : '${payload.reviewNumber}',
          requestDate: item.requestDate ?? payload.requestDate,
          projectId:
              item.projectId.isNotEmpty ? item.projectId : payload.projectId,
          projectName:
              item.projectName.isNotEmpty ? item.projectName : projectName,
          statusId: item.statusId == 0 ? 1 : item.statusId,
          requestType: item.requestType == 0
              ? payload.requestType
              : item.requestType,
          requestTypeName: item.requestTypeName.isNotEmpty
              ? item.requestTypeName
              : QualityCreatableRequestTypes.apiNameFor(payload.requestType),
          specialization: item.specialization == 0
              ? payload.specialization
              : item.specialization,
          currentTask: item.currentTask,
          responsible: item.responsible,
          contractor: item.contractor,
          requestNote: item.requestNote ?? payload.description,
        );
      },
    );
  }

  void resetCreateState() {
    emit(state.copyWith(
      createNumbersStatus: RequestStatus.initial,
      createSubmitStatus: RequestStatus.initial,
      clearSerialNumber: true,
      clearReviewNumber: true,
      clearCreateError: true,
    ));
  }
}
