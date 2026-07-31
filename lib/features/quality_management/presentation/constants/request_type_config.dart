import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/network/task_status_enum.dart';
import '../../data/datasources/quality_remote_data_source.dart';
import '../../data/models/project_request_counts_models.dart';

class RequestTypeConfig {
  const RequestTypeConfig({
    required this.labelKey,
    required this.color,
    required this.sortOrder,
  });

  final String labelKey;
  final Color color;
  final int sortOrder;

  String get label => labelKey.tr();
}

abstract final class RequestTypeRegistry {
  static const Map<String, RequestTypeConfig> _byName = {
    'ReceiveBusiness': RequestTypeConfig(
      labelKey: AppString.formWorkHandover,
      color: Color(0xFF6B8F71),
      sortOrder: 2,
    ),
    'MaterialsAdoption': RequestTypeConfig(
      labelKey: AppString.formMaterialApproval,
      color: Color(0xFFC9A227),
      sortOrder: 3,
    ),
    'InformationRequest': RequestTypeConfig(
      labelKey: AppString.formRequestForInformation,
      color: Color(0xFF5B9BD5),
      sortOrder: 0,
    ),
    'SiteWorkInstructions': RequestTypeConfig(
      labelKey: AppString.formSiteWorkInstructions,
      color: Color(0xFF8E7CC3),
      sortOrder: 5,
    ),
    'DocumentsAdoption': RequestTypeConfig(
      labelKey: AppString.formDocumentApproval,
      color: Color(0xFF4472C4),
      sortOrder: 4,
    ),
    'SubcontractorAdoption': RequestTypeConfig(
      labelKey: AppString.formSubcontractorApproval,
      color: Color(0xFF7F7F7F),
      sortOrder: 6,
    ),
    'MaterialsReceiveAndInspect': RequestTypeConfig(
      labelKey: AppString.formMaterialReceiving,
      color: Color(0xFF70AD47),
      sortOrder: 7,
    ),
    'ExecutiveBoardsAdoption': RequestTypeConfig(
      labelKey: AppString.formShopDrawingsApproval,
      color: Color(0xFFED7D31),
      sortOrder: 8,
    ),
    'NonConformanceReport': RequestTypeConfig(
      labelKey: AppString.formNonConformance,
      color: Color(0xFFC55A11),
      sortOrder: 1,
    ),
    'SiteObservationReport': RequestTypeConfig(
      labelKey: AppString.formSiteObservations,
      color: Color(0xFF9E7B5C),
      sortOrder: 9,
    ),
    'PaymentCertificateAdoption': RequestTypeConfig(
      labelKey: AppString.formPaymentCertificate,
      color: Color(0xFF2E75B6),
      sortOrder: 8,
    ),
  };

  static RequestTypeConfig configFor(String requestTypeName) {
    return _byName[requestTypeName] ??
        const RequestTypeConfig(
          labelKey: AppString.category,
          color: Color(0xFF607D8B),
          sortOrder: 99,
        );
  }

  static String labelFor(String requestTypeName) =>
      configFor(requestTypeName).label;
}

/// إحصائيات الجودة — `ProjectRequests/summary`
abstract final class StatisticsStatusFilter {
  static const String all = 'undefined';
  static const String inProgress = 'InProgress';
  static const String accepted = 'Accepted';
  static const String rejected = 'Rejected';
  static const String reRequest = 'ReRequest';
  static const String haveNote = 'HaveNote';

  static const List<QualityStatusFilterOption> options = [
    (value: all, labelKey: AppString.filterAll),
    (value: inProgress, labelKey: AppString.qcStatusInProgress),
    (value: accepted, labelKey: AppString.qcStatusAccepted),
    (value: rejected, labelKey: AppString.qcStatusRejected),
    (value: reRequest, labelKey: AppString.qcStatusReRequest),
    (value: haveNote, labelKey: AppString.qcStatusHaveNote),
  ];
}

typedef QualityStatusFilterOption = ({String value, String labelKey});

abstract final class ApprovalStatusFilter {
  static const String all = 'undefined';

  static const List<QualityStatusFilterOption> options =
      StatisticsStatusFilter.options;
}

/// طلباتي + أرشيف الطلبات — `approvalStatus` + `filter=[]`
abstract final class MyRequestsStatusFilter {
  static const String underAction = 'null';
  static const String accepted = '0';
  static const String acceptedWithNotes = '1';
  static const String reRequest = '2';
  static const String rejected = '3';

  static const List<QualityStatusFilterOption> options = [
    (value: underAction, labelKey: AppString.qcStatusInProgress),
    (value: accepted, labelKey: AppString.qcStatusAccepted),
    (value: acceptedWithNotes, labelKey: AppString.qcStatusHaveNote),
    (value: reRequest, labelKey: AppString.qcStatusReRequest),
    (value: rejected, labelKey: AppString.qcStatusRejected),
  ];

  static String get defaultValue => underAction;
}

/// مهام الاعتماد — `isApproved` + `filter=[]`
abstract final class ApprovalTaskStatusFilter {
  static const String underAction = 'undefined';
  static const String accepted = 'true';
  static const String rejected = 'false';

  static const List<QualityStatusFilterOption> options = [
    (value: underAction, labelKey: AppString.qcStatusInProgress),
    (value: accepted, labelKey: AppString.qcStatusAccepted),
    (value: rejected, labelKey: AppString.qcStatusRejected),
  ];

  static String get defaultValue => underAction;
}

abstract final class QualityListFilterConfig {
  static List<QualityStatusFilterOption> optionsFor(ProjectRequestListKind kind) {
    return switch (kind) {
      ProjectRequestListKind.approvalTasks => ApprovalTaskStatusFilter.options,
      ProjectRequestListKind.myRequests ||
      ProjectRequestListKind.archive =>
        MyRequestsStatusFilter.options,
    };
  }

  static String defaultValueFor(ProjectRequestListKind kind) {
    return switch (kind) {
      ProjectRequestListKind.approvalTasks =>
        ApprovalTaskStatusFilter.defaultValue,
      ProjectRequestListKind.myRequests ||
      ProjectRequestListKind.archive =>
        MyRequestsStatusFilter.defaultValue,
    };
  }

  static int? countForStatus({
    required ProjectRequestListKind kind,
    required String statusValue,
    required ProjectRequestStatusCounts counts,
  }) {
    if (kind == ProjectRequestListKind.approvalTasks) {
      return switch (statusValue) {
        ApprovalTaskStatusFilter.underAction => counts.inprogressCount,
        ApprovalTaskStatusFilter.accepted => counts.approvedCount,
        ApprovalTaskStatusFilter.rejected => counts.rejectedCount,
        _ => null,
      };
    }

    return switch (statusValue) {
      MyRequestsStatusFilter.underAction => counts.inprogressCount,
      MyRequestsStatusFilter.accepted => counts.approvedCount,
      MyRequestsStatusFilter.acceptedWithNotes =>
        counts.approvedWithCommentCount,
      MyRequestsStatusFilter.reRequest => counts.resubmittedCount,
      MyRequestsStatusFilter.rejected => counts.rejectedCount,
      _ => null,
    };
  }
}

abstract final class RequestStatusLabels {
  static String forStatusId(int statusId) {
    return switch (statusId) {
      1 => AppString.qcStatusInProgress.tr(),
      2 => AppString.qcStatusDraft.tr(),
      4 => AppString.qcStatusRejected.tr(),
      5 => AppString.qcStatusAccepted.tr(),
      20 => AppString.qcStatusInProgress.tr(),
      _ => AppString.statusLabel.tr(),
    };
  }
}

abstract final class TaskStatusLabels {
  static String forTaskStatus(int? status) {
    return switch (status) {
      TaskStatusEnum.reassigned => AppString.taskStatusReassigned.tr(),
      TaskStatusEnum.done => AppString.taskStatusDone.tr(),
      TaskStatusEnum.rejected => AppString.taskStatusRejected.tr(),
      _ => AppString.notAvailable.tr(),
    };
  }
}
