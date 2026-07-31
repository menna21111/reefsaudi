import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../data/models/project_request_detail_models.dart';
import 'quality_request_detail_field.dart';
import 'quality_request_detail_section_shell.dart';

class QualityRequestDetailGeneralSection extends StatefulWidget {
  const QualityRequestDetailGeneralSection({
    super.key,
    required this.detail,
  });

  final ProjectRequestDetail detail;

  @override
  State<QualityRequestDetailGeneralSection> createState() =>
      _QualityRequestDetailGeneralSectionState();
}

class _QualityRequestDetailGeneralSectionState
    extends State<QualityRequestDetailGeneralSection> {
  bool _expanded = true;

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;

    return QualityRequestDetailSectionShell(
      title: AppString.generalData.tr(),
      icon: Icons.info_outline_rounded,
      expanded: _expanded,
      onToggle: () => setState(() => _expanded = !_expanded),
      child: Column(
        children: [
          QualityRequestDetailField(
            label: AppString.projectName.tr(),
            value: detail.projectName,
          ),
          QualityRequestDetailField(
            label: AppString.requestDate.tr(),
            value: _formatDate(detail.requestDate),
          ),
          QualityRequestDetailField(
            label: AppString.revisionNumber.tr(),
            value: detail.reviewNumber,
          ),
          QualityRequestDetailField(
            label: AppString.serialNumber.tr(),
            value: detail.serialNumber,
          ),
          QualityRequestDetailField(
            label: AppString.specialization.tr(),
            value: SpecializationLabels.labelKeyFor(detail.specialization).tr(),
          ),
          QualityRequestDetailField(
            label: AppString.contractor.tr(),
            value: QualityRequestDetailField.display(detail.contractorName),
          ),
          QualityRequestDetailField(
            label: AppString.supervisingConsultantNotes.tr(),
            value: QualityRequestDetailField.display(
              detail.supervisionConsultantNotes,
            ),
          ),
          QualityRequestDetailField(
            label: AppString.ownerNotes.tr(),
            value: QualityRequestDetailField.display(detail.ownerNotes),
          ),
          if (detail.primaryDescription != null)
            QualityRequestDetailField(
              label: AppString.requestNote.tr(),
              value: detail.primaryDescription!,
            ),
        ],
      ),
    );
  }
}
