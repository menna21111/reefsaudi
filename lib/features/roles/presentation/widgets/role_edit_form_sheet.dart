import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../domain/models/role.dart';

class RoleEditFormResult {
  const RoleEditFormResult({
    required this.name,
    required this.selectedPermissions,
  });

  final String name;
  final List<String> selectedPermissions;
}

class RoleEditFormSheet extends StatefulWidget {
  const RoleEditFormSheet({
    super.key,
    required this.details,
  });

  final RoleDetails details;

  static Future<RoleEditFormResult?> show(
    BuildContext context, {
    required RoleDetails details,
  }) {
    return showModalBottomSheet<RoleEditFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RoleEditFormSheet(details: details),
    );
  }

  @override
  State<RoleEditFormSheet> createState() => _RoleEditFormSheetState();
}

class _RoleEditFormSheetState extends State<RoleEditFormSheet> {
  late final TextEditingController _nameController;
  late List<RolePermissionGroup> _groups;
  final _formKey = GlobalKey<FormState>();
  final Set<String> _expandedGroups = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.details.name);
    _groups = widget.details.permissionGroups
        .map(
          (group) => RolePermissionGroup(
            groupName: group.groupName,
            permissions: group.permissions
                .map(
                  (permission) => RolePermission(
                    name: permission.name,
                    displayName: permission.displayName,
                    value: permission.value,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
    if (_groups.isNotEmpty) {
      _expandedGroups.add(_groups.first.groupName);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _togglePermission(int groupIndex, int permissionIndex, bool value) {
    setState(() {
      final group = _groups[groupIndex];
      final updatedPermissions = [...group.permissions];
      updatedPermissions[permissionIndex] =
          updatedPermissions[permissionIndex].copyWith(value: value);
      _groups[groupIndex] = group.copyWith(permissions: updatedPermissions);
    });
  }

  void _toggleGroup(int groupIndex, bool value) {
    setState(() {
      final group = _groups[groupIndex];
      _groups[groupIndex] = group.copyWith(
        permissions: group.permissions
            .map((permission) => permission.copyWith(value: value))
            .toList(),
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final selected = _groups
        .expand((group) => group.permissions)
        .where((permission) => permission.value)
        .map((permission) => permission.name)
        .toList();

    Navigator.pop(
      context,
      RoleEditFormResult(
        name: _nameController.text.trim(),
        selectedPermissions: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RobotoText(
                text: AppString.editRole.tr(),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colors.kFontColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppString.fillRequiredFields.tr();
                  }
                  return null;
                },
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 14.sp,
                  fontFamily: 'Almarai',
                ),
                decoration: InputDecoration(
                  labelText: AppString.roleName.tr(),
                  labelStyle: TextStyle(color: colors.kGrayColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              RobotoText(
                text: AppString.rolePermissions.tr(),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: colors.kFontColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (context, groupIndex) {
                    final group = _groups[groupIndex];
                    final expanded = _expandedGroups.contains(group.groupName);
                    final selectedCount =
                        group.permissions.where((p) => p.value).length;
                    final allSelected =
                        selectedCount == group.permissions.length &&
                            group.permissions.isNotEmpty;

                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: colors.kBgColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: colors.kBorderColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              group.groupName,
                              style: TextStyle(
                                color: colors.kFontColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Almarai',
                              ),
                            ),
                            subtitle: Text(
                              '$selectedCount / ${group.permissions.length}',
                              style: TextStyle(
                                color: colors.kGrayColor,
                                fontSize: 11.sp,
                                fontFamily: 'Almarai',
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: allSelected,
                                  onChanged: (value) => _toggleGroup(
                                    groupIndex,
                                    value ?? false,
                                  ),
                                  activeColor: colors.kPrimaryColor,
                                ),
                                Icon(
                                  expanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: colors.kGrayColor,
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                if (expanded) {
                                  _expandedGroups.remove(group.groupName);
                                } else {
                                  _expandedGroups.add(group.groupName);
                                }
                              });
                            },
                          ),
                          if (expanded)
                            ...group.permissions.asMap().entries.map((entry) {
                              final permission = entry.value;
                              return CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsetsDirectional.only(
                                  start: 16.w,
                                  end: 8.w,
                                ),
                                title: Text(
                                  permission.displayName,
                                  style: TextStyle(
                                    color: colors.kFontColor,
                                    fontSize: 12.sp,
                                    fontFamily: 'Almarai',
                                  ),
                                ),
                                value: permission.value,
                                activeColor: colors.kPrimaryColor,
                                onChanged: (value) => _togglePermission(
                                  groupIndex,
                                  entry.key,
                                  value ?? false,
                                ),
                              );
                            }),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
              ButtonCustom(
                text: AppString.save.tr(),
                buttoncolor: colors.kPrimaryColor,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
