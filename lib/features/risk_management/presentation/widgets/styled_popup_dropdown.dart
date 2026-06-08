import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

/// A dropdown that matches the UX of the provided `dropdown_level.dart`:
/// - focus-driven border color
/// - popup menu (not native DropdownButton)
/// - loading support + RTL friendly
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

  @override
  State<StyledPopupDropdown<T>> createState() =>
      _StyledPopupDropdownState<T>();
}

class _StyledPopupDropdownState<T> extends State<StyledPopupDropdown<T>> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  static const double _menuMaxHeight = 250.0;

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

    return showMenu<T>(
      context: context,
      color: context.appColorsRead.kBgColor,
      position: isEnoughSpaceBelow
          ? RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + size.height,
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
              child: item.child,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final label = widget.title;

    return FormField<T>(
      initialValue: widget.value,
      validator: widget.required
          ? (v) => v == null ? ' ' : null
          : (_) => null,
      builder: (field) {
        final hasError = field.hasError && (field.errorText?.isNotEmpty ?? false);
        final borderColor = hasError
            ? colors.kRedColor
            : _hasFocus
                ? colors.kPrimaryColor
                : colors.kBorderColor.withValues(alpha: 0.4);

        Widget displayWidget;
        if (widget.value == null) {
          displayWidget = Text(
            widget.hintText ?? '',
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 14.sp,
            ),
          );
        } else {
          // For safety: popup items come from provided DropdownMenuItem child widgets.
          displayWidget = widget.items
              .firstWhere((e) => e.value == widget.value)
              .child;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.kPrimaryColor,
              ),
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () async {
                _focusNode.requestFocus();
                final selected = await _showMenu();
                if (!mounted) return;
                field.didChange(selected);
                widget.onChanged(selected);
              },
              borderRadius: BorderRadius.circular(10.r),
              child: Focus(
                focusNode: _focusNode,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefixIcon != null) ...[
                        widget.prefixIcon!,
                        SizedBox(width: 12.w),
                      ],
                      Expanded(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: widget.value == null
                                ? colors.kGrayColor
                                : colors.kPrimaryColor,
                            fontSize: 14.sp,
                          ),
                          child: displayWidget,
                        ),
                      ),
                      if (widget.isLoading)
                        SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      else
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24.sp,
                          color: _hasFocus ? colors.kPrimaryColor : colors.kGrayColor,
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
