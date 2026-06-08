import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_api_models.dart';
import '../cubit/project_statistics_cubit.dart';

const _kStatusOpen = 'open';
const _kStatusInTreatment = 'in_treatment';
const _kStatusClosed = 'closed';

class RisksScreen extends StatefulWidget {
  final String projectId;

  const RisksScreen({super.key, required this.projectId});

  @override
  State<RisksScreen> createState() => _RisksScreenState();
}

class _RisksScreenState extends State<RisksScreen> {
  bool isTableView = true;
  late List<Map<String, dynamic>> _risks;

  List<Map<String, dynamic>> _mapRisks(List<RiskMatrixItemDto> risks) {
    return risks
        .map(
          (risk) => {
            'id': risk.id,
            'title': risk.title,
            'probability': '${risk.probability}',
            'impact': '${risk.impact}',
            'status': risk.score >= 12 ? _kStatusOpen : _kStatusInTreatment,
            'owner': risk.responsePlan,
            'date': '',
            'score': risk.score,
          },
        )
        .toList();
  }

  String _statusLabel(String status) {
    switch (status) {
      case _kStatusOpen:
        return AppString.riskStatusOpen.tr();
      case _kStatusInTreatment:
        return AppString.riskStatusInTreatment.tr();
      case _kStatusClosed:
        return AppString.riskStatusClosed.tr();
      default:
        return status;
    }
  }

  String _probabilityLabel(String value) {
    final level = int.tryParse(value) ?? 0;
    switch (level) {
      case 4:
        return AppString.riskLevelVeryHigh.tr();
      case 3:
        return AppString.riskLevelHigh.tr();
      case 2:
        return AppString.riskLevelMedium.tr();
      case 1:
        return AppString.riskLevelLow.tr();
      default:
        return AppString.riskLevelVeryLow.tr();
    }
  }

  Color _statusColor(BuildContext context, String status) {
    final colors = context.appColorsRead;
    switch (status) {
      case _kStatusOpen:
        return colors.kRedColor;
      case _kStatusInTreatment:
        return colors.kGoldColor;
      case _kStatusClosed:
        return colors.kPrimaryColor;
      default:
        return colors.kGrayColor;
    }
  }

  Color _probabilityColor(BuildContext context, String value) {
    final colors = context.appColorsRead;
    final level = int.tryParse(value) ?? 0;
    if (level >= 4) return colors.kRedColor;
    if (level >= 3) return colors.kGoldColor;
    return colors.kPrimaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<ProjectRisksCubit, ProjectRisksState>(
      builder: (context, state) {
        if (state is ProjectRisksLoading || state is ProjectRisksInitial) {
          return Scaffold(
            backgroundColor: colors.kBgColor,
            body: Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            ),
          );
        }
        if (state is ProjectRisksError) {
          return Scaffold(
            backgroundColor: colors.kBgColor,
            body: Center(
              child: Text(
                state.message.tr(),
                style: TextStyle(color: colors.kRedColor),
              ),
            ),
          );
        }

        final risks = state is ProjectRisksLoaded
            ? _mapRisks(state.risks)
            : <Map<String, dynamic>>[];

        return _buildContent(context, risks);
      },
    );
  }

  Widget _buildContent(BuildContext context, List<Map<String, dynamic>> risks) {
    final colors = context.appColors;
    _risks = risks;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: colors.kFontColor),
        title: RobotoText(
          text: AppString.riskManagement.tr(),
          color: colors.kFontColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => setState(() => isTableView = !isTableView),
            child: Container(
              margin: EdgeInsets.only(left: 16.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: colors.kInputColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: colors.kBorderColor.withValues(alpha: 0.5),
                ),
              ),
              child: Icon(
                isTableView ? Icons.grid_view_rounded : Icons.list_rounded,
                color: colors.kPrimaryColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRiskDialog(context),
        backgroundColor: colors.kRedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Icon(Icons.add, color: colors.kFontColor, size: 28.sp),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                _buildSummaryChip(
                  context,
                  AppString.all.tr(),
                  '${_risks.length}',
                  colors.kGrayColor,
                ),
                SizedBox(width: 8.w),
                _buildSummaryChip(
                  context,
                  AppString.riskStatusOpen.tr(),
                  '${_risks.where((r) => r['status'] == _kStatusOpen).length}',
                  colors.kRedColor,
                ),
                SizedBox(width: 8.w),
                _buildSummaryChip(
                  context,
                  AppString.riskStatusInTreatment.tr(),
                  '${_risks.where((r) => r['status'] == _kStatusInTreatment).length}',
                  colors.kGoldColor,
                ),
                SizedBox(width: 8.w),
                _buildSummaryChip(
                  context,
                  AppString.riskStatusClosed.tr(),
                  '${_risks.where((r) => r['status'] == _kStatusClosed).length}',
                  colors.kPrimaryColor,
                ),
              ],
            ),
          ),
          Expanded(child: isTableView ? _buildTableView(context) : _buildGridView(context)),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(
    BuildContext context,
    String label,
    String count,
    Color color,
  ) {
    final colors = context.appColors;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            RobotoText(
              text: count,
              color: color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 2.h),
            RobotoText(
              text: label,
              color: colors.kGrayColor,
              fontSize: 10.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableView(BuildContext context) {
    final colors = context.appColors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colors.kBorderColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _headerCell(context, AppString.riskNumber.tr(), 70.w),
                  _headerCell(context, AppString.riskTitle.tr(), 160.w),
                  _headerCell(context, AppString.riskProbability.tr(), 100.w),
                  _headerCell(context, AppString.riskImpact.tr(), 90.w),
                  _headerCell(context, AppString.riskStatusLabel.tr(), 110.w),
                  _headerCell(context, AppString.owner.tr(), 100.w),
                  _headerCell(context, AppString.date.tr(), 110.w),
                  _headerCell(
                    context,
                    AppString.actions.tr(),
                    80.w,
                    center: true,
                  ),
                ],
              ),
            ),
            ...List.generate(_risks.length, (i) {
              final risk = _risks[i];
              final isLast = i == _risks.length - 1;
              final statusKey = risk['status'] as String;
              final statusColor = _statusColor(context, statusKey);
              final probColor =
                  _probabilityColor(context, risk['probability'] as String);
              final probabilityLabel =
                  _probabilityLabel(risk['probability'] as String);

              return Container(
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(
                            color: colors.kBorderColor.withValues(alpha: 0.3),
                          ),
                        ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      _dataCell(
                        context,
                        '${risk['id']}',
                        70.w,
                        color: colors.kGrayColor,
                      ),
                      SizedBox(
                        width: 160.w,
                        child: Row(
                          children: [
                            Container(
                              width: 3.w,
                              height: 30.h,
                              margin: EdgeInsets.only(left: 6.w),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                risk['title'] as String,
                                style: TextStyle(
                                  color: colors.kFontColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: probColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            probabilityLabel,
                            style: TextStyle(
                              color: probColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      _dataCell(context, '${risk['impact']}', 90.w),
                      SizedBox(
                        width: 110.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            _statusLabel(statusKey),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      _dataCell(context, '${risk['owner']}', 100.w),
                      _dataCell(
                        context,
                        '${risk['date']}',
                        110.w,
                        color: colors.kGrayColor,
                      ),
                      SizedBox(
                        width: 80.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.edit_outlined,
                                color: colors.kGrayColor,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.delete_outline,
                                color: colors.kRedColor,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(
    BuildContext context,
    String text,
    double width, {
    bool center = false,
  }) {
    final colors = context.appColors;

    return SizedBox(
      width: width,
      child: RobotoText(
        text: text,
        color: colors.kGrayColor,
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        textAlign: center ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  Widget _dataCell(
    BuildContext context,
    String text,
    double width, {
    Color? color,
  }) {
    final colors = context.appColors;

    return SizedBox(
      width: width,
      child: RobotoText(
        text: text,
        color: color ?? colors.kFontColor,
        fontSize: 11.sp,
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    final colors = context.appColors;

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.1,
      ),
      itemCount: _risks.length,
      itemBuilder: (context, index) {
        final risk = _risks[index];
        final statusKey = risk['status'] as String;
        final statusColor = _statusColor(context, statusKey);
        final probColor =
            _probabilityColor(context, risk['probability'] as String);
        final probabilityLabel =
            _probabilityLabel(risk['probability'] as String);

        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: colors.kInputColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: RobotoText(
                      text: _statusLabel(statusKey),
                      color: statusColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.warning_amber_rounded,
                    color: statusColor,
                    size: 18.sp,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              RobotoText(
                text: '${risk['id']}',
                color: colors.kGrayColor,
                fontSize: 11.sp,
              ),
              SizedBox(height: 4.h),
              RobotoText(
                text: risk['title'] as String,
                color: colors.kFontColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                maxLines: 2,
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: probColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: RobotoText(
                      text: probabilityLabel,
                      color: probColor,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: RobotoText(
                      text: '${risk['owner']}',
                      color: colors.kGrayColor,
                      fontSize: 10.sp,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddRiskDialog(BuildContext context) {
    final colors = context.appColorsRead;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.kInputColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          top: 24.h,
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.kBorderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            RobotoText(
              text: AppString.addRisk.tr(),
              color: colors.kFontColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 16.h),
            TextField(
              style: TextStyle(color: colors.kFontColor, fontSize: 14.sp),
              decoration: InputDecoration(
                labelText: AppString.riskTitle.tr(),
                labelStyle: TextStyle(color: colors.kGrayColor),
                filled: true,
                fillColor: colors.kBgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.kRedColor,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: RobotoText(
                text: AppString.addRisk.tr(),
                color: colors.kFontColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
