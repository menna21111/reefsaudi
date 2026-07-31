import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/funcation.dart';

import '../utils/app_color.dart';
import '../utils/app_string.dart';
import '../utils/app_theme_context.dart';
import 'popup_menu_position.dart';

class LazyStyledPopupDropdown extends StatefulWidget {
  const LazyStyledPopupDropdown({
    super.key,
    required this.title,
    required this.valueId,
    required this.valueLabel,
    required this.loadItems,
    required this.onSelected,
    this.hintText,
    this.emptyMessage,
    this.required = false,
    this.showValidationError = false,
  });

  final String title;
  final String? valueId;
  final String? valueLabel;
  final Future<List<DropdownMenuItem<String>>> Function() loadItems;
  final void Function(String id, String label) onSelected;
  final String? hintText;
  final String? emptyMessage;
  final bool required;
  final bool showValidationError;

  static const double menuMaxHeight = 320;

  @override
  State<LazyStyledPopupDropdown> createState() =>
      _LazyStyledPopupDropdownState();
}

class _LazyStyledPopupDropdownState extends State<LazyStyledPopupDropdown> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey();
  bool _hasFocus = false;
  bool _isLoading = false;
  List<DropdownMenuItem<String>> _cachedItems = const [];

  @override
  void initState() {
    super.initState();
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

  Future<void> _openMenu({ValueChanged<String?>? onFieldChanged}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isLoading = true);
    try {
      _cachedItems = await widget.loadItems();
    } catch (_) {
      _cachedItems = const [];
    }
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Wait a frame so keyboard dismiss / layout settle before measuring.
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    if (_cachedItems.isEmpty) {
      AppFunctions.showsToast(
        widget.emptyMessage ?? AppString.noData.tr(),
        AppColor.kRedColor,
        context,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       widget.emptyMessage ?? AppString.noData.tr(),
      //     ),
      //   ),
      // );
      return;
    }

    final colors = context.appColorsRead;

    final selected = await showAnchoredPopupMenu<String>(
      context: context,
      anchorKey: _fieldKey,
      maxHeight: LazyStyledPopupDropdown.menuMaxHeight,
      items: _cachedItems
          .map(
            (item) => PopupMenuItem<String>(
              value: item.value,
              height: 48.h,
              child: Align(
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

    if (!mounted || selected == null) return;

    final match = _cachedItems.firstWhere(
      (item) => item.value == selected,
      orElse: () => DropdownMenuItem(value: selected, child: Text(selected)),
    );
    final label = _labelFromItem(match);
    onFieldChanged?.call(selected);
    widget.onSelected(selected, label);
  }

  String _labelFromItem(DropdownMenuItem<String> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? item.value ?? '';
    }
    return item.value ?? '';
  }

  String? get _displayLabel {
    if (widget.valueLabel != null && widget.valueLabel!.trim().isNotEmpty) {
      return widget.valueLabel;
    }
    if (widget.valueId == null) return null;
    final match = _cachedItems.where((e) => e.value == widget.valueId);
    if (match.isEmpty) return null;
    return _labelFromItem(match.first);
  }

  bool get _isEmpty => widget.valueId == null || widget.valueId!.trim().isEmpty;

  Widget _buildField({
    required bool hasError,
    ValueChanged<String?>? onFieldChanged,
  }) {
    final colors = context.appColors;
    final display = _displayLabel;
    final borderColor = hasError
        ? colors.kRedColor
        : _hasFocus
        ? colors.kPrimaryColor
        : colors.kBorderColor.withValues(alpha: 0.45);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,

          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: hasError ? colors.kRedColor : colors.kFontColor,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: _isLoading
              ? null
              : () => _openMenu(onFieldChanged: onFieldChanged),
          borderRadius: BorderRadius.circular(14.r),
          child: Focus(
            focusNode: _focusNode,
            child: Container(
              key: _fieldKey,
              constraints: BoxConstraints(minHeight: 52.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: colors.kInputColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: borderColor,
                  width: _hasFocus || hasError ? 1.5 : 1,
                ),
              ),
              child: Row(
                textDirection: FormLayout.directionOf(context),
                children: [
                  Expanded(
                    child: Text(
                      display ?? widget.hintText ?? '',
                      textAlign: FormLayout.alignOf(context),
                      textDirection: FormLayout.directionOf(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: display == null
                            ? colors.kGrayColor
                            : colors.kFontColor,
                        fontSize: 15.sp,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  if (_isLoading)
                    SizedBox(
                      height: 22.h,
                      width: 22.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.kPrimaryColor,
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
  }

  @override
  Widget build(BuildContext context) {
    final externalError = widget.showValidationError && _isEmpty;

    if (!widget.required) {
      return _buildField(hasError: externalError);
    }

    return FormField<String>(
      initialValue: widget.valueId,
      autovalidateMode: widget.showValidationError
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      validator: (_) {
        final value = widget.valueId;
        return value == null || value.trim().isEmpty ? ' ' : null;
      },
      builder: (field) {
        final hasError =
            externalError ||
            (field.hasError && (field.errorText?.isNotEmpty ?? false));
        return _buildField(hasError: hasError, onFieldChanged: field.didChange);
      },
    );
  }
}
