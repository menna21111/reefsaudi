import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../core/network/api_constant.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/project_request_detail_models.dart';
import '../../cubit/quality_management_cubit.dart';
import '../../constants/request_type_config.dart';
import '../../utils/open_attachment_file.dart';
import '../quality_request_attachments_table.dart';
import 'quality_request_detail_field.dart';
import 'quality_request_detail_fields_grid.dart';
import 'quality_request_detail_section_shell.dart';

class QualityRequestDetailCurrentTaskSection extends StatefulWidget {
  const QualityRequestDetailCurrentTaskSection({
    super.key,
    required this.detail,
  });

  final ProjectRequestDetail detail;

  @override
  State<QualityRequestDetailCurrentTaskSection> createState() =>
      _QualityRequestDetailCurrentTaskSectionState();
}

class _QualityRequestDetailCurrentTaskSectionState
    extends State<QualityRequestDetailCurrentTaskSection> {
  bool _isLoadingAttachment = false;

  Future<void> _openTaskAttachment(ProjectRequestCurrentTask task) async {
    final path = task.attachmentPath?.trim();
    if (path == null || path.isEmpty) return;

    final fileName = task.displayAttachmentName;
    final lower = fileName.toLowerCase();
    final isImage = lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
    final isPdf = lower.endsWith('.pdf');

    // Images: open via media URL (same as attachments table).
    if (isImage) {
      final token = await DioHelper.getAccessToken();
      final url = ApiConstants.resolveAttachmentMediaUrl(path, token: token);
      if (!mounted || url == null || url.isEmpty) return;
      await Navigator.push(
        context,
        QualityRequestImageViewerScreen.route(title: fileName, imageUrl: url),
      );
      return;
    }

    setState(() => _isLoadingAttachment = true);
    final bytes = await context.read<QualityManagementCubit>().downloadAttachmentByPath(
          attachmentId: '',
          attachmentPath: path,
        );
    if (!mounted) return;
    setState(() => _isLoadingAttachment = false);

    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.unKnownError.tr())),
      );
      return;
    }

    final data = Uint8List.fromList(bytes);

    if (isPdf) {
      await Navigator.push(
        context,
        QualityRequestPdfViewerScreen.route(title: fileName, bytes: data),
      );
      return;
    }

    final result = await openAttachmentWithSystemApp(
      bytes: data,
      fileName: fileName.isNotEmpty ? fileName : 'attachment.bin',
    );
    if (!mounted) return;
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.message.isNotEmpty
                ? result.message
                : AppString.unKnownError.tr(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final task = widget.detail.currentTask;

    return QualityRequestDetailSectionShell(
      title: AppString.currentTaskDetails.tr(),
      icon: Icons.verified_user_outlined,
      expanded: true,
      onToggle: () {},
      collapsible: false,
      child: task == null || task.isEmpty
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: colors.kBgColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors.kBorderColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: colors.kGrayColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      AppString.noCurrentTask.tr(),
                      style: TextStyle(
                        color: colors.kFontColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                QualityRequestDetailField(
                  label: AppString.taskName.tr(),
                  value: QualityRequestDetailField.display(task.title),
                ),
                QualityRequestDetailField(
                  label: AppString.statusLabel.tr(),
                  value: task.status == null
                      ? '-'
                      : TaskStatusLabels.forTaskStatus(task.status),
                ),
                QualityRequestDetailField(
                  label: AppString.assignedTo.tr(),
                  value: QualityRequestDetailField.display(
                    task.assignedTo?.trim().isNotEmpty == true
                        ? task.assignedTo
                        : task.firstName,
                  ),
                ),
                QualityRequestDetailField(
                  label: AppString.email.tr(),
                  value: QualityRequestDetailField.display(task.email),
                ),
                if ((task.description?.trim() ?? '').isNotEmpty)
                  QualityRequestDetailField(
                    label: AppString.description.tr(),
                    value: task.description!.trim(),
                  ),
                if (task.hasAttachment)
                  QualityRequestDetailAttachmentLink(
                    label: AppString.attachments.tr(),
                    fileName: task.displayAttachmentName,
                    isLoading: _isLoadingAttachment,
                    onTap: () => _openTaskAttachment(task),
                  ),
              ],
            ),
    );
  }
}
