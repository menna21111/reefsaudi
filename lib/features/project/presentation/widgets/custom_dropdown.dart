import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: _selectedValue,
          onChanged: (val) {
            setState(() {
              _selectedValue = val;
            });
            widget.onChanged?.call(val);
          },
          isExpanded: true,
          items: widget.items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(color: colors.kFontColor, fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          dropdownColor: colors.kInputColor,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.kGrayColor),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: colors.kGrayColor, fontSize: 14.sp),
            filled: true,
            fillColor: colors.kInputColor,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.kBorderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.kBorderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.kPrimaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
