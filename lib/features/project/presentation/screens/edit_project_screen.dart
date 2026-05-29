import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/widgets/button_custom.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_date_picker.dart';

class EditProjectScreen extends StatefulWidget {
  const EditProjectScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.kSurfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.kWhiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'تعديل المشروع',
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColor.kBorderColor.withOpacity(0.4)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section 1: بيانات المشروع ──
            _buildSectionTitle('بيانات المشروع', Icons.data_usage_outlined),
            SizedBox(height: 16.h),
            _buildCard(
              children: [
                CustomTextField(
                  label: 'اسم المشروع',
                  hintText: 'أدخل اسم المشروع',
                  controller: _projectNameController,
                ),
                SizedBox(height: 16.h),
                CustomDropdown(
                  label: 'مسؤول عن المشروع',
                  hintText: 'اختر المسؤول',
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
                  label: 'الاستشاري العام',
                  hintText: 'اختر الاستشاري',
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
                        label: 'تاريخ البدء',
                        dateText: _startDate,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2023, 12, 1),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(primary: AppColor.kPrimaryColor),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              _startDate =
                                  '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomDatePicker(
                        label: 'تاريخ الانتهاء',
                        dateText: _endDate,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2025, 12, 1),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                            builder: (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(primary: AppColor.kPrimaryColor),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              _endDate =
                                  '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'ميزانية المشروع',
                  hintText: '5,000,000',
                  controller: _budgetController,
                  isNumber: true,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Text(
                      'ر.س',
                      style: TextStyle(
                        color: AppColor.kPrimaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // ── Section 2: إدارة الإشراف ──
            _buildSectionTitle('إدارة الإشراف', Icons.engineering_outlined),
            SizedBox(height: 16.h),
            _buildCard(
              children: [
                CustomDropdown(
                  label: 'مهندس استشاري',
                  hintText: 'اختر المكتب الاستشاري',
                  initialValue: _selectedConsultingOffice,
                  items: const [
                    'مكتب الاستشارات الهندسية',
                    'مكتب النخبة',
                    'مكتب الرائد',
                    'مكتب التميز',
                  ],
                  onChanged: (val) => setState(() => _selectedConsultingOffice = val),
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'مهندس مدني',
                  hintText: 'أدخل اسم المهندس',
                  controller: _civilEngController,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'مهندس معماري',
                  hintText: 'أدخل اسم المهندس',
                  controller: _archEngController,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'مهندس كهربائي',
                  hintText: 'أدخل اسم المهندس',
                  controller: _elecEngController,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'مهندس ميكانيكا',
                  hintText: 'أدخل اسم المهندس',
                  controller: _mechEngController,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // ── Section 3: إدارة المشاريع ──
            _buildSectionTitle('إدارة المشاريع', Icons.business_center_outlined),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColor.kSurfaceColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isProjectActive
                      ? AppColor.kPrimaryColor.withOpacity(0.4)
                      : AppColor.kBorderColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'حالة المشروع',
                        style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isProjectActive ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          color: isProjectActive ? AppColor.kPrimaryColor : AppColor.kRedColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isProjectActive,
                    onChanged: (val) => setState(() => isProjectActive = val),
                    activeColor: AppColor.kPrimaryColor,
                    inactiveThumbColor: AppColor.kGrayTextColor,
                    inactiveTrackColor: AppColor.kBorderColor,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // ── Buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColor.kInputBorderColor),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(color: AppColor.kWhiteColor, fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ButtonCustom(
                    text: 'حفظ التغييرات',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم حفظ التغييرات بنجاح',
                            style: TextStyle(color: AppColor.kWhiteColor),
                          ),
                          backgroundColor: AppColor.kPrimaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppColor.kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColor.kPrimaryColor, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(children: children),
    );
  }
}
