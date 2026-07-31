import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../../core/utils/app_string.dart';
import '../../../../../../core/utils/app_theme_context.dart';
import '../../../../data/models/project_request_detail_models.dart';
import '../../../cubit/quality_management_cubit.dart';
import '../../../utils/open_attachment_file.dart';
import '../../quality_request_attachments_table.dart';
import '../quality_request_detail_fields_grid.dart';
import '../quality_request_detail_section_shell.dart';

class QualityRequestDetailReceiveBusinessSection extends StatelessWidget {
  const QualityRequestDetailReceiveBusinessSection({
    super.key,
    required this.detail,
  });

  final ReceiveBusinessDetail detail;

  @override
  Widget build(BuildContext context) {
    return QualityRequestDetailSectionShell(
      title: AppString.receiveBusinessDetails.tr(),
      icon: Icons.apartment_outlined,
      expanded: true,
      onToggle: () {},
      collapsible: false,
      child: QualityRequestDetailFieldsGrid(
        fields: [
          (
            label: AppString.building.tr(),
            value: QualityRequestDetailFormatters.display(detail.buildingStatement),
          ),
          (
            label: AppString.buildingComments.tr(),
            value: QualityRequestDetailFormatters.display(detail.buildingComments),
          ),
          (
            label: AppString.floor.tr(),
            value: QualityRequestDetailFormatters.display(detail.floorStatement),
          ),
          (
            label: AppString.floorComments.tr(),
            value: QualityRequestDetailFormatters.display(detail.floorComments),
          ),
          (
            label: AppString.workToBeExamined.tr(),
            value: QualityRequestDetailFormatters.display(
              detail.workToBeExaminedStatement,
            ),
          ),
          (
            label: AppString.workToBeExaminedComments.tr(),
            value: QualityRequestDetailFormatters.display(
              detail.workToBeExaminedComments,
            ),
          ),
          (
            label: AppString.requiredExaminationDate.tr(),
            value: QualityRequestDetailFormatters.date(
              detail.requiredExaminationDateStatement,
            ),
          ),
          (
            label: AppString.requiredExaminationDateComments.tr(),
            value: QualityRequestDetailFormatters.display(
              detail.requiredExaminationDateComments,
            ),
          ),
          (
            label: AppString.approvedPlates.tr(),
            value: QualityRequestDetailFormatters.display(
              detail.approvedPlatesStatement,
            ),
          ),
          (
            label: AppString.approvedPlatesComments.tr(),
            value: QualityRequestDetailFormatters.display(
              detail.approvedPlatesComments,
            ),
          ),
          (
            label: AppString.responsibleEngineer.tr(),
            value: QualityRequestDetailFormatters.display(
              detail.responsibleEngineer,
            ),
          ),
          (
            label: AppString.responsibleDirector.tr(),
            value: QualityRequestDetailFormatters.display(
              detail.responsibleDirector,
            ),
          ),
        ],
      ),
    );
  }
}

class QualityRequestDetailDocumentsAdoptionSection extends StatelessWidget {
  const QualityRequestDetailDocumentsAdoptionSection({
    super.key,
    required this.requestId,
    required this.items,
    this.titleKey = AppString.documentsAdoptionDetails,
  });

  final String requestId;
  final List<DocumentsAdoptionDetailItem> items;
  final String titleKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return QualityRequestDetailSectionShell(
      title: titleKey.tr(),
      icon: Icons.description_outlined,
      expanded: true,
      onToggle: () {},
      collapsible: false,
      child: items.isEmpty
          ? Text(
              AppString.noData.tr(),
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 13.sp,
                fontFamily: 'Almarai',
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) SizedBox(height: 12.h),
                  _DocumentAdoptionCard(
                    index: i + 1,
                    requestId: requestId,
                    item: items[i],
                  ),
                ],
              ],
            ),
    );
  }
}

class _DocumentAdoptionCard extends StatefulWidget {
  const _DocumentAdoptionCard({
    required this.index,
    required this.requestId,
    required this.item,
  });

  final int index;
  final String requestId;
  final DocumentsAdoptionDetailItem item;

  @override
  State<_DocumentAdoptionCard> createState() => _DocumentAdoptionCardState();
}

class _DocumentAdoptionCardState extends State<_DocumentAdoptionCard> {
  bool _loading = false;

  Future<void> _openAttachment() async {
    final path = widget.item.attachmentPath?.trim();
    if (path == null || path.isEmpty) return;

    setState(() => _loading = true);
    final bytes = await context.read<QualityManagementCubit>().downloadAttachmentByPath(
          attachmentId: 'documents-$path',
          attachmentPath: path,
        );
    if (!mounted) return;
    setState(() => _loading = false);

    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.unKnownError.tr())),
      );
      return;
    }

    final name = widget.item.displayAttachmentName;
    final data = Uint8List.fromList(bytes);
    final lower = name.toLowerCase();

    if (lower.endsWith('.pdf')) {
      await Navigator.push(
        context,
        QualityRequestPdfViewerScreen.route(title: name, bytes: data),
      );
      return;
    }

    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp')) {
      await Navigator.push(
        context,
        QualityRequestImageViewerScreen.route(title: name, bytes: data),
      );
      return;
    }

    final result = await openAttachmentWithSystemApp(
      bytes: data,
      fileName: name.isNotEmpty ? name : 'attachment.bin',
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
    final item = widget.item;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.kBgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.kPrimaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '#${widget.index}',
                  style: TextStyle(
                    color: colors.kWhiteColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                AppString.documentItem.tr(),
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Almarai',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          QualityRequestDetailFieldsGrid(
            fields: [
              (
                label: AppString.documentDescription.tr(),
                value: QualityRequestDetailFormatters.display(
                  item.documentDescription,
                ),
              ),
              (
                label: AppString.documentReviewNumber.tr(),
                value: QualityRequestDetailFormatters.display(
                  item.documentReviewNumber,
                ),
              ),
              (
                label: AppString.numberOfCopies.tr(),
                value: QualityRequestDetailFormatters.display(
                  item.numberOfCopies,
                ),
              ),
              (
                label: AppString.recordType.tr(),
                value: QualityRequestDetailFormatters.display(item.recordType),
              ),
            ],
          ),
          if (item.hasAttachment) ...[
            SizedBox(height: 4.h),
            QualityRequestDetailAttachmentLink(
              label: AppString.documentAttachmentFile.tr(),
              fileName: item.displayAttachmentName,
              isLoading: _loading,
              onTap: _openAttachment,
            ),
          ],
        ],
      ),
    );
  }
}

class QualityRequestDetailMaterialsReceiveSection extends StatefulWidget {
  const QualityRequestDetailMaterialsReceiveSection({
    super.key,
    required this.requestId,
    required this.detail,
  });

  final String requestId;
  final MaterialsReceiveAndInspectDetail detail;

  @override
  State<QualityRequestDetailMaterialsReceiveSection> createState() =>
      _QualityRequestDetailMaterialsReceiveSectionState();
}

class _QualityRequestDetailMaterialsReceiveSectionState
    extends State<QualityRequestDetailMaterialsReceiveSection> {
  String? _loadingKey;

  Future<void> _openAttachment({
    required String key,
    required String? path,
    required String? name,
  }) async {
    final attachmentPath = path?.trim();
    if (attachmentPath == null || attachmentPath.isEmpty) return;

    setState(() => _loadingKey = key);
    final bytes = await context.read<QualityManagementCubit>().downloadAttachmentByPath(
          attachmentId: key,
          attachmentPath: attachmentPath,
        );
    if (!mounted) return;
    setState(() => _loadingKey = null);

    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.unKnownError.tr())),
      );
      return;
    }

    final fileName = (name?.trim().isNotEmpty == true)
        ? name!.trim()
        : attachmentPath.split(RegExp(r'[\\/]')).last;
    final data = Uint8List.fromList(bytes);
    final lower = fileName.toLowerCase();

    if (lower.endsWith('.pdf')) {
      await Navigator.push(
        context,
        QualityRequestPdfViewerScreen.route(title: fileName, bytes: data),
      );
      return;
    }

    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp')) {
      await Navigator.push(
        context,
        QualityRequestImageViewerScreen.route(title: fileName, bytes: data),
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
    final detail = widget.detail;

    return QualityRequestDetailSectionShell(
      title: AppString.materialsReceiveDetails.tr(),
      icon: Icons.inventory_2_outlined,
      expanded: true,
      onToggle: () {},
      collapsible: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QualityRequestDetailFieldsGrid(
            fields: [
              (
                label: AppString.approvalApplicationNumber.tr(),
                value: QualityRequestDetailFormatters.display(
                  detail.approvalApplicationNumber,
                ),
              ),
              (
                label: AppString.accreditationDate.tr(),
                value: QualityRequestDetailFormatters.longDate(
                  detail.accreditationDate,
                ),
              ),
              (
                label: AppString.factoryName.tr(),
                value: QualityRequestDetailFormatters.display(detail.factoryName),
              ),
              (
                label: AppString.requiredExaminationDate.tr(),
                value: QualityRequestDetailFormatters.date(
                  detail.requiredExaminationDate,
                ),
              ),
              (
                label: AppString.materialDescription.tr(),
                value: QualityRequestDetailFormatters.display(
                  detail.materialDescription,
                ),
              ),
              (
                label: AppString.attachmentsStatement.tr(),
                value: QualityRequestDetailFormatters.display(
                  detail.attachmentsStatement,
                ),
              ),
              (
                label: AppString.responsibleEngineerName.tr(),
                value: QualityRequestDetailFormatters.display(
                  detail.responsibleEngineerName,
                ),
              ),
              (
                label: AppString.responsibleDirectorName.tr(),
                value: QualityRequestDetailFormatters.display(
                  detail.responsibleDirectorName,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          QualityRequestDetailAttachmentLink(
            label: AppString.approvalApplicationNumberFile.tr(),
            fileName: detail.approvalApplicationNumberAttachmentName ??
                detail.approvalApplicationNumberAttachmentPath,
            isLoading: _loadingKey == 'approval',
            onTap: () => _openAttachment(
              key: 'approval',
              path: detail.approvalApplicationNumberAttachmentPath,
              name: detail.approvalApplicationNumberAttachmentName,
            ),
          ),
          SizedBox(height: 10.h),
          QualityRequestDetailAttachmentLink(
            label: AppString.factoryNameFile.tr(),
            fileName: detail.factoryNameAttachmentName ??
                detail.factoryNameAttachmentPath,
            isLoading: _loadingKey == 'factory',
            onTap: () => _openAttachment(
              key: 'factory',
              path: detail.factoryNameAttachmentPath,
              name: detail.factoryNameAttachmentName,
            ),
          ),
          SizedBox(height: 10.h),
          QualityRequestDetailAttachmentLink(
            label: AppString.attachmentsStatementFile.tr(),
            fileName: detail.attachmentsStatementAttachmentName ??
                detail.attachmentsStatementAttachmentPath,
            isLoading: _loadingKey == 'statement',
            onTap: () => _openAttachment(
              key: 'statement',
              path: detail.attachmentsStatementAttachmentPath,
              name: detail.attachmentsStatementAttachmentName,
            ),
          ),
        ],
      ),
    );
  }
}
