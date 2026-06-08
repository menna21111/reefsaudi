import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../domain/entities/financial_requirement.dart';
import '../widgets/edit_text_field.dart';

class FinancialRequirementEditScreen extends StatefulWidget {
  final FinancialRequirement? item;
  const FinancialRequirementEditScreen({super.key, this.item});

  @override
  State<FinancialRequirementEditScreen> createState() =>
      _FinancialRequirementEditScreenState();
}

class _FinancialRequirementEditScreenState
    extends State<FinancialRequirementEditScreen> {
  late TextEditingController _projectNameController;
  late TextEditingController _sectorController;
  late TextEditingController _extractNumberController;
  late TextEditingController _extractValueController;
  late TextEditingController _extractStatusController;
  late TextEditingController _projectManagementStatusController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _projectNameController =
        TextEditingController(text: widget.item?.projectName ?? '');
    _sectorController = TextEditingController(text: widget.item?.sector ?? '');
    _extractNumberController =
        TextEditingController(text: widget.item?.extractNumber ?? '');
    _extractValueController =
        TextEditingController(text: widget.item?.extractValue ?? '');
    _extractStatusController =
        TextEditingController(text: widget.item?.extractStatus ?? '');
    _projectManagementStatusController = TextEditingController(
      text: widget.item?.projectManagementStatus ?? '',
    );
    _startDateController =
        TextEditingController(text: widget.item?.startDate ?? '');
    _endDateController = TextEditingController(text: widget.item?.endDate ?? '');
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _sectorController.dispose();
    _extractNumberController.dispose();
    _extractValueController.dispose();
    _extractStatusController.dispose();
    _projectManagementStatusController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColor.kPrimaryColor,
            surface: AppColor.kSurfaceColor,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      controller.text = '${date.year}/${date.month}/${date.day}';
    }
  }

  void _saveChanges() {
    final message = widget.item == null
        ? 'تم إضافة المشروع بنجاح'
        : 'تم حفظ التعديلات بنجاح';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RobotoText(
          text: message,
          fontSize: 14.sp,
          color: AppColor.kWhiteColor,
        ),
        backgroundColor: AppColor.kPrimaryColor,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.kSurfaceColor,
        elevation: 0,
        centerTitle: true,
        title: RobotoText(
          text: widget.item == null
              ? 'إضافة مشروع جديد'
              : 'تعديل المتطلب المالي',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.kWhiteColor,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColor.kWhiteColor,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EditTextField(
              controller: _projectNameController,
              label: 'اسم المشروع',
              icon: Icons.business_outlined,
            ),
            SizedBox(height: 16.h),
            EditTextField(
              controller: _sectorController,
              label: 'القطاع',
              icon: Icons.location_on_outlined,
            ),
            SizedBox(height: 16.h),
            EditTextField(
              controller: _extractNumberController,
              label: 'رقم المستخلص',
              icon: Icons.numbers_outlined,
            ),
            SizedBox(height: 16.h),
            EditTextField(
              controller: _extractValueController,
              label: 'قيمة المستخلص',
              icon: Icons.attach_money_outlined,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),
            EditTextField(
              controller: _extractStatusController,
              label: 'حالة المستخلص',
              icon: Icons.flag_outlined,
            ),
            SizedBox(height: 16.h),
            EditTextField(
              controller: _projectManagementStatusController,
              label: 'الحالة من إدارة المشاريع',
              icon: Icons.assignment_outlined,
            ),
            SizedBox(height: 16.h),
            EditTextField(
              controller: _startDateController,
              label: 'تاريخ البداية',
              icon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: () => _pickDate(_startDateController),
            ),
            SizedBox(height: 16.h),
            EditTextField(
              controller: _endDateController,
              label: 'تاريخ النهاية',
              icon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: () => _pickDate(_endDateController),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.kPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: RobotoText(
                text: widget.item == null
                    ? 'إضافة المشروع'
                    : 'حفظ التعديلات',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.kWhiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
