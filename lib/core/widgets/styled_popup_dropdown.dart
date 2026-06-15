import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_theme_context.dart';

class StyledPopupDropdown<T> extends StatefulWidget {
  const StyledPopupDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
    required this.value,
    this.isLoading = false,
    this.required = false,
    this.hintText,
    this.prefixIcon,
  });

  final String title;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final bool isLoading;
  final bool required;
  final String? hintText;
  final Widget? prefixIcon;

  static double get fieldMinHeight => 52.h;

  @override
  State<StyledPopupDropdown<T>> createState() => _StyledPopupDropdownState<T>();
}

class _StyledPopupDropdownState<T> extends State<StyledPopupDropdown<T>> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  static const double _menuMaxHeight = 320;

  @override
  void initState() {
    super.initState();
    _hasFocus = _focusNode.hasFocus;
    _focusNode.addListener(() {
      if (_hasFocus != _focusNode.hasFocus) {
        setState(() => _hasFocus = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<T?> _showMenu() async {
    if (widget.items.isEmpty) return null;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - (offset.dy + size.height);
    final isEnoughSpaceBelow = spaceBelow > _menuMaxHeight;
    final colors = context.appColorsRead;

    return showMenu<T>(
      context: context,
      color: colors.kInputColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.4)),
      ),
      position: isEnoughSpaceBelow
          ? RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + size.height + 4,
              offset.dx + size.width,
              offset.dy,
            )
          : RelativeRect.fromLTRB(
              offset.dx,
              offset.dy - _menuMaxHeight,
              offset.dx + size.width,
              offset.dy + size.height,
            ),
      constraints: BoxConstraints(
        minWidth: size.width,
        maxWidth: size.width,
        maxHeight: _menuMaxHeight,
      ),
      items: widget.items
          .map(
            (item) => PopupMenuItem<T>(
              value: item.value,
              height: 48.h,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 15.sp,
                    fontFamily: 'Almarai',
                  ),
                  child: item.child,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return FormField<T>(
      initialValue: widget.value,
      validator: widget.required ? (v) => v == null ? ' ' : null : (_) => null,
      builder: (field) {
        final hasError =
            field.hasError && (field.errorText?.isNotEmpty ?? false);
        final borderColor = hasError
            ? colors.kRedColor
            : _hasFocus
                ? colors.kPrimaryColor
                : colors.kBorderColor.withValues(alpha: 0.45);

        Widget displayWidget;
        if (widget.value == null) {
          displayWidget = Text(
            widget.hintText ?? '',
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 15.sp,
              fontFamily: 'Almarai',
            ),
          );
        } else {
          displayWidget = Align(
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyle(
              style: TextStyle(
                color: colors.kFontColor,
                fontSize: 15.sp,
                fontFamily: 'Almarai',
              ),
              child: widget.items.firstWhere((e) => e.value == widget.value).child,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: colors.kFontColor,
                fontFamily: 'Almarai',
              ),
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: widget.isLoading
                  ? null
                  : () async {
                      _focusNode.requestFocus();
                      final selected = await _showMenu();
                      if (!mounted) return;
                      field.didChange(selected);
                      widget.onChanged(selected);
                    },
              borderRadius: BorderRadius.circular(14.r),
              child: Focus(
                focusNode: _focusNode,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: StyledPopupDropdown.fieldMinHeight,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: colors.kInputColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: borderColor,
                      width: _hasFocus ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefixIcon != null) ...[
                        widget.prefixIcon!,
                        SizedBox(width: 10.w),
                      ],
                      Expanded(child: displayWidget),
                      if (widget.isLoading)
                        SizedBox(
                          height: 22.h,
                          width: 22.w,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.kPrimaryColor,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 26.sp,
                          color: _hasFocus
                              ? colors.kPrimaryColor
                              : colors.kGrayColor,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
