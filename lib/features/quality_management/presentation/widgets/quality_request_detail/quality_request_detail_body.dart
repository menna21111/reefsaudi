import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/utils/enums.dart';
import '../../../data/models/project_request_detail_models.dart';
import '../../constants/quality_form_options.dart';
import '../../cubit/quality_management_cubit.dart';
import 'quality_request_detail_attachments_section.dart';
import 'quality_request_detail_current_task_section.dart';
import 'quality_request_detail_general_section.dart';
import 'quality_request_detail_history_section.dart';
import 'quality_request_detail_summary_card.dart';
import 'quality_request_detail_task_action_section.dart';
import 'sections/quality_request_type_detail_sections.dart';

class QualityRequestDetailBody extends StatelessWidget {
  const QualityRequestDetailBody({
    super.key,
    required this.requestId,
    required this.detail,
    this.showTaskAction = false,
  });

  final String requestId;
  final ProjectRequestDetail detail;
  final bool showTaskAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final state = context.watch<QualityManagementCubit>().state;

    return RefreshIndicator(
      color: colors.kPrimaryColor,
      onRefresh: () =>
          context.read<QualityManagementCubit>().loadDetail(requestId),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          if (showTaskAction) ...[
            QualityRequestDetailTaskActionSection(detail: detail),
            SizedBox(height: 14.h),
          ],
          QualityRequestDetailSummaryCard(detail: detail),
          SizedBox(height: 14.h),
          QualityRequestDetailGeneralSection(detail: detail),
          ..._typeSpecificSections(detail),
          if (!showTaskAction) ...[
            SizedBox(height: 14.h),
            QualityRequestDetailCurrentTaskSection(detail: detail),
          ],
          SizedBox(height: 14.h),
          _SectionLoader(
            status: state.detailAttachmentsStatus,
            onRetry: () => context
                .read<QualityManagementCubit>()
                .loadDetailAttachments(requestId),
            child: QualityRequestDetailAttachmentsSection(
              requestId: detail.id,
              items: state.detailAttachments,
              isDownloading: state.isDownloadingAttachment,
              downloadingAttachmentId: state.downloadingAttachmentId,
              onRefresh: () => context
                  .read<QualityManagementCubit>()
                  .refreshDetailAttachments(),
            ),
          ),
          SizedBox(height: 14.h),
          _SectionLoader(
            status: state.detailHistoryStatus,
            onRetry: () => context
                .read<QualityManagementCubit>()
                .loadDetailHistory(requestId),
            child: QualityRequestDetailHistorySection(
              items: state.detailHistory,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _typeSpecificSections(ProjectRequestDetail detail) {
    final widgets = <Widget>[];

    if (QualityCreatableRequestTypes.usesReceiveBusinessForm(
          detail.requestType,
        ) &&
        detail.receiveBusiness != null) {
      widgets.addAll([
        SizedBox(height: 14.h),
        QualityRequestDetailReceiveBusinessSection(
          detail: detail.receiveBusiness!,
        ),
      ]);
    }

    if (QualityCreatableRequestTypes.usesAdoptionItemsForm(detail.requestType)) {
      widgets.addAll([
        SizedBox(height: 14.h),
        QualityRequestDetailDocumentsAdoptionSection(
          requestId: detail.id,
          items: detail.documentsAdoption,
          titleKey: QualityCreatableRequestTypes.detailsSectionKey(
            detail.requestType,
          ),
        ),
      ]);
    }

    if (QualityCreatableRequestTypes.usesMaterialsReceiveForm(
          detail.requestType,
        ) &&
        detail.materialsReceiveAndInspect != null) {
      widgets.addAll([
        SizedBox(height: 14.h),
        QualityRequestDetailMaterialsReceiveSection(
          requestId: detail.id,
          detail: detail.materialsReceiveAndInspect!,
        ),
      ]);
    }

    return widgets;
  }
}

class _SectionLoader extends StatelessWidget {
  const _SectionLoader({
    required this.status,
    required this.child,
    required this.onRetry,
  });

  final RequestStatus status;
  final Widget child;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (status == RequestStatus.loading || status == RequestStatus.initial) {
      return Container(
        height: 120.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.kBorderColor.withValues(alpha: 0.3),
          ),
        ),
        child: CircularProgressIndicator(
          color: colors.kPrimaryColor,
          strokeWidth: 2,
        ),
      );
    }

    if (status == RequestStatus.error) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.kBorderColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              AppString.retry.tr(),
              style: TextStyle(
                color: colors.kFontColor,
                fontFamily: 'Almarai',
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 10.h),
            FilledButton(
              onPressed: onRetry,
              child: Text(AppString.retry.tr()),
            ),
          ],
        ),
      );
    }

    return child;
  }
}
