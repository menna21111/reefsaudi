import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/project_request_attachment_models.dart';
import '../quality_request_attachments_table.dart';
import 'quality_request_detail_section_shell.dart';

class QualityRequestDetailAttachmentsSection extends StatelessWidget {
  const QualityRequestDetailAttachmentsSection({
    super.key,
    required this.requestId,
    required this.items,
    required this.onRefresh,
    this.isDownloading = false,
    this.downloadingAttachmentId,
  });

  final String requestId;
  final List<ProjectRequestAttachmentItem> items;
  final VoidCallback onRefresh;
  final bool isDownloading;
  final String? downloadingAttachmentId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return QualityRequestDetailSectionShell(
      title: AppString.attachments.tr(),
      icon: Icons.attach_file_rounded,
      expanded: true,
      onToggle: () {},
      collapsible: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_view_rounded, color: colors.kGrayColor, size: 20.sp),
          SizedBox(width: 8.w),
          InkWell(
            onTap: onRefresh,
            child: Icon(
              Icons.refresh_rounded,
              color: colors.kGrayColor,
              size: 20.sp,
            ),
          ),
        ],
      ),
      child: QualityRequestAttachmentsTable(
        requestId: requestId,
        items: items,
        isDownloading: isDownloading,
        downloadingAttachmentId: downloadingAttachmentId,
      ),
    );
  }
}
