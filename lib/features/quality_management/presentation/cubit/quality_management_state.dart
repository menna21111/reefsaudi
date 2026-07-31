part of 'quality_management_cubit.dart';

class QualityManagementState extends Equatable {
  const QualityManagementState({
    this.statisticsStatus = RequestStatus.initial,
    this.statisticsItems = const [],
    this.statisticsProcessedTotal = 0,
    this.statisticsApprovalStatus,
    this.statisticsError = '',
    this.requestsStatus = RequestStatus.initial,
    this.requestsKind,
    this.requestsItems = const [],
    this.requestsTotalCount = 0,
    this.requestsApprovalStatus,
    this.requestsListFilter = const ProjectRequestListFilter(),
    this.requestsStatusCounts,
    this.requestsCountsStatus = RequestStatus.initial,
    this.requestsLoadingMore = false,
    this.requestsRefreshing = false,
    this.requestsFilterLoading = false,
    this.requestsError = '',
    this.detailStatus = RequestStatus.initial,
    this.detailHistoryStatus = RequestStatus.initial,
    this.detailAttachmentsStatus = RequestStatus.initial,
    this.detailRequestId,
    this.detail,
    this.detailHistory = const [],
    this.detailAttachments = const [],
    this.isDownloadingAttachment = false,
    this.downloadingAttachmentId,
    this.detailError = '',
    this.taskActionStatus = RequestStatus.initial,
    this.taskActionError = '',
    this.createNumbersStatus = RequestStatus.initial,
    this.createSubmitStatus = RequestStatus.initial,
    this.serialNumber,
    this.reviewNumber,
    this.createError = '',
  });

  final RequestStatus statisticsStatus;
  final List<ProjectRequestSummaryItem> statisticsItems;
  final int statisticsProcessedTotal;
  final String? statisticsApprovalStatus;
  final String statisticsError;

  final RequestStatus requestsStatus;
  final ProjectRequestListKind? requestsKind;
  final List<ProjectRequestItem> requestsItems;
  final int requestsTotalCount;
  final String? requestsApprovalStatus;
  final ProjectRequestListFilter requestsListFilter;
  final ProjectRequestStatusCounts? requestsStatusCounts;
  final RequestStatus requestsCountsStatus;
  final bool requestsLoadingMore;
  final bool requestsRefreshing;
  final bool requestsFilterLoading;
  final String requestsError;

  final RequestStatus detailStatus;
  final RequestStatus detailHistoryStatus;
  final RequestStatus detailAttachmentsStatus;
  final String? detailRequestId;
  final ProjectRequestDetail? detail;
  final List<ProjectRequestHistoryItem> detailHistory;
  final List<ProjectRequestAttachmentItem> detailAttachments;
  final bool isDownloadingAttachment;
  final String? downloadingAttachmentId;
  final String detailError;
  final RequestStatus taskActionStatus;
  final String taskActionError;

  final RequestStatus createNumbersStatus;
  final RequestStatus createSubmitStatus;
  final int? serialNumber;
  final int? reviewNumber;
  final String createError;

  bool get requestsHasMore => requestsItems.length < requestsTotalCount;

  QualityManagementState copyWith({
    RequestStatus? statisticsStatus,
    List<ProjectRequestSummaryItem>? statisticsItems,
    int? statisticsProcessedTotal,
    String? statisticsApprovalStatus,
    String? statisticsError,
    RequestStatus? requestsStatus,
    ProjectRequestListKind? requestsKind,
    List<ProjectRequestItem>? requestsItems,
    int? requestsTotalCount,
    String? requestsApprovalStatus,
    ProjectRequestListFilter? requestsListFilter,
    ProjectRequestStatusCounts? requestsStatusCounts,
    bool clearRequestsStatusCounts = false,
    RequestStatus? requestsCountsStatus,
    bool? requestsLoadingMore,
    bool? requestsRefreshing,
    bool? requestsFilterLoading,
    String? requestsError,
    RequestStatus? detailStatus,
    RequestStatus? detailHistoryStatus,
    RequestStatus? detailAttachmentsStatus,
    String? detailRequestId,
    ProjectRequestDetail? detail,
    List<ProjectRequestHistoryItem>? detailHistory,
    List<ProjectRequestAttachmentItem>? detailAttachments,
    bool? isDownloadingAttachment,
    String? downloadingAttachmentId,
    bool clearDownloadingAttachmentId = false,
    String? detailError,
    RequestStatus? taskActionStatus,
    String? taskActionError,
    bool clearTaskActionError = false,
    RequestStatus? createNumbersStatus,
    RequestStatus? createSubmitStatus,
    int? serialNumber,
    int? reviewNumber,
    String? createError,
    bool clearSerialNumber = false,
    bool clearReviewNumber = false,
    bool clearCreateError = false,
  }) {
    return QualityManagementState(
      statisticsStatus: statisticsStatus ?? this.statisticsStatus,
      statisticsItems: statisticsItems ?? this.statisticsItems,
      statisticsProcessedTotal:
          statisticsProcessedTotal ?? this.statisticsProcessedTotal,
      statisticsApprovalStatus:
          statisticsApprovalStatus ?? this.statisticsApprovalStatus,
      statisticsError: statisticsError ?? this.statisticsError,
      requestsStatus: requestsStatus ?? this.requestsStatus,
      requestsKind: requestsKind ?? this.requestsKind,
      requestsItems: requestsItems ?? this.requestsItems,
      requestsTotalCount: requestsTotalCount ?? this.requestsTotalCount,
      requestsApprovalStatus:
          requestsApprovalStatus ?? this.requestsApprovalStatus,
      requestsListFilter: requestsListFilter ?? this.requestsListFilter,
      requestsStatusCounts: clearRequestsStatusCounts
          ? null
          : requestsStatusCounts ?? this.requestsStatusCounts,
      requestsCountsStatus: requestsCountsStatus ?? this.requestsCountsStatus,
      requestsLoadingMore: requestsLoadingMore ?? this.requestsLoadingMore,
      requestsRefreshing: requestsRefreshing ?? this.requestsRefreshing,
      requestsFilterLoading:
          requestsFilterLoading ?? this.requestsFilterLoading,
      requestsError: requestsError ?? this.requestsError,
      detailStatus: detailStatus ?? this.detailStatus,
      detailHistoryStatus: detailHistoryStatus ?? this.detailHistoryStatus,
      detailAttachmentsStatus:
          detailAttachmentsStatus ?? this.detailAttachmentsStatus,
      detailRequestId: detailRequestId ?? this.detailRequestId,
      detail: detail ?? this.detail,
      detailHistory: detailHistory ?? this.detailHistory,
      detailAttachments: detailAttachments ?? this.detailAttachments,
      isDownloadingAttachment:
          isDownloadingAttachment ?? this.isDownloadingAttachment,
      downloadingAttachmentId: clearDownloadingAttachmentId
          ? null
          : downloadingAttachmentId ?? this.downloadingAttachmentId,
      detailError: detailError ?? this.detailError,
      taskActionStatus: taskActionStatus ?? this.taskActionStatus,
      taskActionError:
          clearTaskActionError ? '' : taskActionError ?? this.taskActionError,
      createNumbersStatus: createNumbersStatus ?? this.createNumbersStatus,
      createSubmitStatus: createSubmitStatus ?? this.createSubmitStatus,
      serialNumber:
          clearSerialNumber ? null : serialNumber ?? this.serialNumber,
      reviewNumber: clearReviewNumber ? null : reviewNumber ?? this.reviewNumber,
      createError: clearCreateError ? '' : createError ?? this.createError,
    );
  }

  @override
  List<Object?> get props => [
        statisticsStatus,
        statisticsItems,
        statisticsProcessedTotal,
        statisticsApprovalStatus,
        statisticsError,
        requestsStatus,
        requestsKind,
        requestsItems,
        requestsTotalCount,
        requestsApprovalStatus,
        requestsListFilter,
        requestsStatusCounts,
        requestsCountsStatus,
        requestsLoadingMore,
        requestsRefreshing,
        requestsFilterLoading,
        requestsError,
        detailStatus,
        detailHistoryStatus,
        detailAttachmentsStatus,
        detailRequestId,
        detail,
        detailHistory,
        detailAttachments,
        isDownloadingAttachment,
        downloadingAttachmentId,
        detailError,
        taskActionStatus,
        taskActionError,
        createNumbersStatus,
        createSubmitStatus,
        serialNumber,
        reviewNumber,
        createError,
      ];
}
