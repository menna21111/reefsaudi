import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/models/employee.dart';

class EmployeeCard extends StatefulWidget {
  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onResetPassword,
    required this.onDelete,
  });

  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onResetPassword;
  final VoidCallback onDelete;

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  String? _imageUrl;
  bool _imageReady = false;

  @override
  void initState() {
    super.initState();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant EmployeeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.employee.profilePicture != widget.employee.profilePicture) {
      _resolveImage();
    }
  }

  Future<void> _resolveImage() async {
    final path = widget.employee.profilePicture;
    if (path == null || path.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        _imageUrl = null;
        _imageReady = true;
      });
      return;
    }

    final token = await DioHelper.getAccessToken();
    final url = ApiConstants.resolveProfilePictureUrl(path, token: token);
    if (!mounted) return;
    setState(() {
      _imageUrl = url;
      _imageReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final employee = widget.employee;

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 12.h),
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40.r,
                        backgroundColor: colors.kBorderColor.withValues(
                          alpha: 0.25,
                        ),
                        backgroundImage: (_imageReady && _imageUrl != null)
                            ? CachedNetworkImageProvider(_imageUrl!)
                            : null,
                        child: (!_imageReady || _imageUrl == null)
                            ? Icon(
                                Icons.image_outlined,
                                color: colors.kGrayColor,
                                size: 28.sp,
                              )
                            : null,
                      ),
                    ),
                    PositionedDirectional(
                      top: 0,
                      end: 0,
                      child: PopupMenuButton<_EmployeeAction>(
                        padding: EdgeInsets.zero,
                        tooltip: '',
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: colors.kGrayColor,
                          size: 20.sp,
                        ),
                        onSelected: (action) {
                          switch (action) {
                            case _EmployeeAction.edit:
                              widget.onEdit();
                            case _EmployeeAction.resetPassword:
                              widget.onResetPassword();
                            case _EmployeeAction.delete:
                              widget.onDelete();
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: _EmployeeAction.edit,
                            child: Text(AppString.editAction.tr()),
                          ),
                          PopupMenuItem(
                            value: _EmployeeAction.resetPassword,
                            child: Text(AppString.changePassword.tr()),
                          ),
                          PopupMenuItem(
                            value: _EmployeeAction.delete,
                            child: Text(
                              AppString.delete.tr(),
                              style: TextStyle(color: colors.kRedColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  employee.fullName.isEmpty ? '—' : employee.fullName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  employee.department.isEmpty ? '—' : employee.department,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.kGrayColor,
                    fontSize: 12.sp,
                    fontFamily: 'Almarai',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  employee.designation.isEmpty ? '—' : employee.designation,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.kGrayColor,
                    fontSize: 11.sp,
                    fontFamily: 'Almarai',
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colors.kBorderColor.withValues(alpha: 0.35),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: _StatCell(
                    icon: Icons.view_in_ar_outlined,
                    iconColor: const Color(0xFF4A90E2),
                    count: employee.readyTasksCount,
                    label: AppString.readyTasks.tr(),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: colors.kBorderColor.withValues(alpha: 0.35),
                ),
                Expanded(
                  child: _StatCell(
                    icon: Icons.layers_outlined,
                    iconColor: const Color(0xFFF5A623),
                    count: employee.inProgressTasksCount,
                    label: AppString.inProgressTasks.tr(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _EmployeeAction { edit, resetPassword, delete }

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Icon(icon, color: iconColor, size: 22.sp),
        SizedBox(height: 6.h),
        Text(
          '$count $label',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 11.sp,
            fontFamily: 'Almarai',
          ),
        ),
      ],
    );
  }
}
