import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';

class EditProjectScreen extends StatefulWidget {
  const EditProjectScreen({super.key});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  bool isProjectActive = true;

  final _projectNameController = TextEditingController(
    text: 'أعمال الإنشائية في محطة طاقات الجيل وبناء',
  );
  final _budgetController = TextEditingController(text: '5,000,000');
  final _civilEngController = TextEditingController(text: 'م. محمد لطفى');
  final _archEngController = TextEditingController(text: 'أحمد عصام');
  final _elecEngController = TextEditingController(text: 'م. إسلام خالد');
  final _mechEngController = TextEditingController(text: 'م. وائل شافعي');

  String? _selectedManager = 'مكتب إدارة المشاريع';
  String? _selectedConsultant = 'المشاريع الشامل';
  String? _selectedConsultingOffice = 'مكتب الاستشارات الهندسية';
  String _startDate = '2023/12/01';
  String _endDate = '2025/12/01';

  @override
  void dispose() {
    _projectNameController.dispose();
    _budgetController.dispose();
    _civilEngController.dispose();
    _archEngController.dispose();
    _elecEngController.dispose();
    _mechEngController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required DateTime lastDate,
    required void Function(String formatted) onPicked,
  }) async {
    final colors = context.appColorsRead;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: lastDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: colors.kPrimaryColor,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      onPicked(
        '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kInputColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.kFontColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppString.editProject.tr(),
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: colors.kBorderColor.withValues(alpha: 0.4),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              context,
              AppString.projectDataSection.tr(),
              Icons.data_usage_outlined,
            ),
            SizedBox(height: 16.h),
            _buildCard(
              context,
              children: [
                CustomTextField(
                  label: AppString.projectName.tr(),
                  hintText: AppString.enterProjectName.tr(),
                  controller: _projectNameController,
                ),
                SizedBox(height: 16.h),
                CustomDropdown(
                  label: AppString.projectResponsible.tr(),
                  hintText: AppString.selectOption.tr(),
                  initialValue: _selectedManager,
                  items: const [
                    'مكتب إدارة المشاريع',
                    'المدير التنفيذي',
                    'مسؤول المنطقة',
                    'مدير المشروع',
                  ],
                  onChanged: (val) => setState(() => _selectedManager = val),
                ),
                SizedBox(height: 16.h),
                CustomDropdown(
                  label: AppString.generalConsultant.tr(),
                  hintText: AppString.selectOption.tr(),
                  initialValue: _selectedConsultant,
                  items: const [
                    'المشاريع الشامل',
                    'استشاري الريف',
                    'مكتب النهضة',
                    'شركة الإتقان',
                  ],
                  onChanged: (val) => setState(() => _selectedConsultant = val),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomDatePicker(
                        label: AppString.startDate.tr(),
                        dateText: _startDate,
                        onTap: () => _pickDate(
                          initialDate: DateTime(2023, 12, 1),
                          lastDate: DateTime(2030),
                          onPicked: (formatted) =>
                              setState(() => _startDate = formatted),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomDatePicker(
                        label: AppString.endDate.tr(),
                        dateText: _endDate,
                        onTap: () => _pickDate(
                          initialDate: DateTime(2025, 12, 1),
                          lastDate: DateTime(2035),
                          onPicked: (formatted) =>
                              setState(() => _endDate = formatted),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: AppString.projectBudgetLabel.tr(),
                  hintText: '5,000,000',
                  controller: _budgetController,
                  isNumber: true,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Text(
                      AppString.sar.tr(),
                      style: TextStyle(
                        color: colors.kPrimaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSectionTitle(
              context,
              AppString.supervisionManagementSection.tr(),
              Icons.engineering_outlined,
            ),
            SizedBox(height: 16.h),
            _buildCard(
              context,
              children: [
                CustomDropdown(
                  label: AppString.consultingOffice.tr(),
                  hintText: AppString.consultingEngineer.tr(),
                  initialValue: _selectedConsultingOffice,
                  items: const [
                    'مكتب الاستشارات الهندسية',
                    'مكتب النخبة',
                    'مكتب الرائد',
                    'مكتب التميز',
                  ],
                  onChanged: (val) =>
                      setState(() => _selectedConsultingOffice = val),
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: AppString.civilEngineer.tr(),
                  hintText: AppString.enterEngineerName.tr(),
                  controller: _civilEngController,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: AppString.architecturalEngineer.tr(),
                  hintText: AppString.enterEngineerName.tr(),
                  controller: _archEngController,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: AppString.electricalEngineer.tr(),
                  hintText: AppString.enterEngineerName.tr(),
                  controller: _elecEngController,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: AppString.mechanicalEngineer.tr(),
                  hintText: AppString.enterEngineerName.tr(),
                  controller: _mechEngController,
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSectionTitle(
              context,
              AppString.projectManagementSection.tr(),
              Icons.business_center_outlined,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: colors.kInputColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isProjectActive
                      ? colors.kPrimaryColor.withValues(alpha: 0.4)
                      : colors.kBorderColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.projectStatus.tr(),
                        style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isProjectActive
                            ? AppString.projectActive.tr()
                            : AppString.projectInactive.tr(),
                        style: TextStyle(
                          color: isProjectActive
                              ? colors.kPrimaryColor
                              : colors.kRedColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isProjectActive,
                    onChanged: (val) => setState(() => isProjectActive = val),
                    activeColor: colors.kPrimaryColor,
                    inactiveThumbColor: colors.kGrayColor,
                    inactiveTrackColor: colors.kBorderColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.kBorderColor),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      AppString.cancel.tr(),
                      style: TextStyle(color: colors.kFontColor, fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ButtonCustom(
                    text: AppString.saveChanges.tr(),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppString.changesSavedSuccessfully.tr(),
                            style: TextStyle(color: colors.kFontColor),
                          ),
                          backgroundColor: colors.kPrimaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final colors = context.appColors;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: colors.kPrimaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: colors.kPrimaryColor, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(children: children),
    );
  }
}
