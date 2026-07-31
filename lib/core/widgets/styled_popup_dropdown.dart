import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_theme_context.dart';
import 'popup_menu_position.dart';

class StyledPopupDropdown<T> extends StatefulWidget {
  const StyledPopupDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
    required this.value,
    this.isLoading = false,
    this.required = false,
    this.showValidationError = false,
    this.hintText,
    this.prefixIcon,
  });

  final String title;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final bool isLoading;
  final bool required;
  final bool showValidationError;
  final String? hintText;
  final Widget? prefixIcon;

  static double get fieldMinHeight => 52.h;

  @override
  State<StyledPopupDropdown<T>> createState() => _StyledPopupDropdownState<T>();
}

class _StyledPopupDropdownState<T> extends State<StyledPopupDropdown<T>> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey();
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

    final colors = context.appColorsRead;

    return showAnchoredPopupMenu<T>(
      context: context,
      anchorKey: _fieldKey,
      maxHeight: _menuMaxHeight,
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
      autovalidateMode: widget.showValidationError
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      validator: widget.required ? (v) => v == null ? ' ' : null : (_) => null,
      builder: (field) {
        final externalError =
            widget.showValidationError && widget.required && widget.value == null;
        final hasError = externalError ||
            (field.hasError && (field.errorText?.isNotEmpty ?? false));
        final borderColor = hasError
            ? colors.kRedColor
            : _hasFocus
                ? colors.kPrimaryColor
                : colors.kBorderColor.withValues(alpha: 0.45);

        Widget displayWidget;
        if (widget.value == null) {
          displayWidget = Text(
            widget.hintText ?? '',
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 15.sp,
              fontFamily: 'Almarai',
            ),
          );
        } else {
          final matched = widget.items.where(
            (e) =>
                e.value == widget.value ||
                e.value.toString().toLowerCase() ==
                    widget.value.toString().toLowerCase(),
          );
          final selectedChild = matched.isNotEmpty
              ? matched.first.child
              : Text(
                  widget.value.toString(),
                  textAlign: FormLayout.alignOf(context),
                  textDirection: FormLayout.directionOf(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 15.sp,
                    fontFamily: 'Almarai',
                  ),
                );
          displayWidget = Directionality(
            textDirection: FormLayout.directionOf(context),
            child: DefaultTextStyle(
              style: TextStyle(
                color: colors.kFontColor,
                fontSize: 15.sp,
                fontFamily: 'Almarai',
              ),
              textAlign: FormLayout.alignOf(context),
              child: selectedChild,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              // textAlign: FormLayout.alignOf(context),
              // textDirection: FormLayout.directionOf(context),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: hasError ? colors.kRedColor : colors.kFontColor,
                fontFamily: 'Almarai',
              ),
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: widget.isLoading
                  ? null
                  : () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final selected = await _showMenu();
                      if (!mounted) return;
                      field.didChange(selected);
                      widget.onChanged(selected);
                    },
              borderRadius: BorderRadius.circular(14.r),
              child: Focus(
                focusNode: _focusNode,
                child: Container(
                  key: _fieldKey,
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
                    textDirection: FormLayout.directionOf(context),
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
