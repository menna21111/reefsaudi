import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/permissions/permission_cubit.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/utils/enums.dart';
import '../../../data/models/project_request_detail_models.dart';
import '../../../domain/models/task_approval_decision.dart';
import '../../cubit/quality_management_cubit.dart';
import '../create_request/quality_file_picker_field.dart';
import 'quality_request_detail_field.dart';
import 'quality_request_detail_section_shell.dart';

class QualityRequestDetailTaskActionSection extends StatefulWidget {
  const QualityRequestDetailTaskActionSection({
    super.key,
    required this.detail,
  });

  final ProjectRequestDetail detail;

  @override
  State<QualityRequestDetailTaskActionSection> createState() =>
      _QualityRequestDetailTaskActionSectionState();
}

class _QualityRequestDetailTaskActionSectionState
    extends State<QualityRequestDetailTaskActionSection> {
  static const _approvalIdOptions = <(String, int)>[
    ('A', 0),
    ('B', 1),
    ('C', 2),
    ('D', 3),
  ];

  TaskApprovalDecision? _decision;
  int? _approvalId;
  String? _attachmentPath;
  final _commentController = TextEditingController();
  String? _localError;

  bool _isContractorUser(BuildContext context) =>
      context.read<PermissionCubit>().isContractorAccount;

  bool get _usesApprovalRating =>
      widget.detail.currentTask?.usesApprovalRating == true;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _decision = null;
    _approvalId = null;
    _attachmentPath = null;
    _commentController.clear();
    _localError = null;
  }

  Future<void> _submit(BuildContext context) async {
    final isContractor = _isContractorUser(context);

    if (isContractor) {
      setState(() => _localError = null);
      final ok = await context.read<QualityManagementCubit>().submitTaskAction(
            decision: TaskApprovalDecision.approved,
            comment: _commentController.text,
            attachmentPath: _attachmentPath,
          );
      if (!mounted || !ok) return;
      setState(_resetForm);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.taskActionSubmitted.tr())),
      );
      return;
    }

    if (_usesApprovalRating) {
      if (_approvalId == null) {
        setState(() => _localError = AppString.selectApprovalId.tr());
        return;
      }
    } else if (_decision == null) {
      setState(() => _localError = AppString.selectTaskApprovalAction.tr());
      return;
    }

    setState(() => _localError = null);

    final ok = await context.read<QualityManagementCubit>().submitTaskAction(
          decision: _usesApprovalRating ? null : _decision,
          approvalId: _usesApprovalRating ? _approvalId : null,
          comment: _commentController.text,
          attachmentPath: _attachmentPath,
        );

    if (!mounted || !ok) return;

    setState(_resetForm);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppString.taskActionSubmitted.tr())),
    );
  }

  Widget _buildDecisionChoices({required bool isLoading}) {
    if (_usesApprovalRating) {
      return Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: _approvalIdOptions.map((option) {
          final (label, id) = option;
          return SizedBox(
            width: (MediaQuery.sizeOf(context).width - 72.w) / 2,
            child: _DecisionChip(
              label: label,
              selected: _approvalId == id,
              enabled: !isLoading,
              expand: false,
              onTap: () => setState(() => _approvalId = id),
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            _DecisionChip(
              label: AppString.qcStatusAccepted.tr(),
              selected: _decision == TaskApprovalDecision.approved,
              enabled: !isLoading,
              onTap: () =>
                  setState(() => _decision = TaskApprovalDecision.approved),
            ),
            SizedBox(width: 10.w),
            _DecisionChip(
              label: AppString.qcStatusRejected.tr(),
              selected: _decision == TaskApprovalDecision.rejected,
              enabled: !isLoading,
              onTap: () =>
                  setState(() => _decision = TaskApprovalDecision.rejected),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        _DecisionChip(
          label: AppString.qcStatusReRequest.tr(),
          selected: _decision == TaskApprovalDecision.reRequest,
          enabled: !isLoading,
          expand: false,
          onTap: () =>
              setState(() => _decision = TaskApprovalDecision.reRequest),
        ),
      ],
    );
  }

  Widget _buildCommentField({required bool isLoading}) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppString.addComment.tr(),
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 11.sp,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _commentController,
          enabled: !isLoading,
          maxLines: 4,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 13.sp,
            fontFamily: 'Almarai',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.kBgColor,
            hintText: AppString.addComment.tr(),
            hintStyle: TextStyle(
              color: colors.kGrayColor,
              fontFamily: 'Almarai',
              fontSize: 13.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: colors.kBorderColor.withValues(alpha: 0.35),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: colors.kBorderColor.withValues(alpha: 0.35),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.kPrimaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentField() {
    return QualityFilePickerField(
      label: AppString.attachments.tr(),
      filePath: _attachmentPath,
      onPicked: (path) => setState(() => _attachmentPath = path),
      onClear: _attachmentPath == null
          ? null
          : () => setState(() => _attachmentPath = null),
    );
  }

  Widget _buildSubmitButton({
    required bool isLoading,
    String? labelKey,
  }) {
    final colors = context.appColors;

    return SizedBox(
      height: 48.h,
      child: FilledButton(
        onPressed: isLoading ? null : () => _submit(context),
        style: FilledButton.styleFrom(
          backgroundColor: colors.kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.kWhiteColor,
                ),
              )
            : Text(
                (labelKey ?? AppString.send).tr(),
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
      ),
    );
  }

  Widget _buildContractorSection({required bool isLoading}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAttachmentField(),
        SizedBox(height: 14.h),
        _buildCommentField(isLoading: isLoading),
        SizedBox(height: 16.h),
        _buildSubmitButton(
          isLoading: isLoading,
          labelKey: AppString.approveRequest,
        ),
      ],
    );
  }

  Widget _buildStaffSection({required bool isLoading}) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _usesApprovalRating
              ? AppString.selectApprovalId.tr()
              : AppString.approvalDecision.tr(),
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 11.sp,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 8.h),
        _buildDecisionChoices(isLoading: isLoading),
        SizedBox(height: 14.h),
        _buildAttachmentField(),
        SizedBox(height: 14.h),
        _buildCommentField(isLoading: isLoading),
        SizedBox(height: 16.h),
        _buildSubmitButton(isLoading: isLoading),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final task = widget.detail.currentTask;
    final hasTask = task != null && (task.id?.trim().isNotEmpty ?? false);
    final isContractor = _isContractorUser(context);

    return QualityRequestDetailSectionShell(
      title: AppString.currentTaskDetails.tr(),
      icon: Icons.playlist_add_check_rounded,
      expanded: true,
      onToggle: () {},
      collapsible: false,
      child: !hasTask
          ? Text(
              AppString.noCurrentTask.tr(),
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 13.sp,
                fontFamily: 'Almarai',
              ),
            )
          : BlocBuilder<QualityManagementCubit, QualityManagementState>(
              buildWhen: (prev, next) =>
                  prev.taskActionStatus != next.taskActionStatus ||
                  prev.taskActionError != next.taskActionError,
              builder: (context, state) {
                final isLoading =
                    state.taskActionStatus == RequestStatus.loading;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    QualityRequestDetailField(
                      label: AppString.taskTitle.tr(),
                      value: QualityRequestDetailField.display(task.title),
                    ),
                    QualityRequestDetailField(
                      label: AppString.assignee.tr(),
                      value: QualityRequestDetailField.display(
                        task.assignedTo?.trim().isNotEmpty == true
                            ? task.assignedTo
                            : task.firstName,
                      ),
                    ),
                    if (isContractor)
                      _buildContractorSection(isLoading: isLoading)
                    else
                      _buildStaffSection(isLoading: isLoading),
                    if (_localError != null ||
                        state.taskActionError.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      Text(
                        (_localError ?? state.taskActionError).tr(),
                        style: TextStyle(
                          color: colors.kRedColor,
                          fontSize: 12.sp,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
    );
  }
}

class _DecisionChip extends StatelessWidget {
  const _DecisionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
    this.expand = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final chip = InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(24.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: expand ? null : double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: selected ? colors.kPrimaryColor : colors.kBgColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: selected
                ? colors.kPrimaryColor
                : colors.kBorderColor.withValues(alpha: 0.4),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18.sp,
              color: selected ? colors.kWhiteColor : colors.kGrayColor,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: selected ? colors.kWhiteColor : colors.kFontColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!expand) return chip;
    return Expanded(child: chip);
  }
}
