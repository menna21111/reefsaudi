import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_theme_context.dart';

class MultiSelectOption<T> {
  const MultiSelectOption({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

class MultiSelectPopupDropdown<T> extends StatefulWidget {
  const MultiSelectPopupDropdown({
    super.key,
    required this.title,
    required this.selected,
    required this.onSelectionChanged,
    this.items = const [],
    this.loadItems,
    this.isLoading = false,
    this.hintText,
    this.emptyText,
    this.compact = false,
    this.isActive = false,
  });

  final String title;
  final List<MultiSelectOption<T>> items;
  final Future<List<MultiSelectOption<T>>> Function()? loadItems;
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;
  final bool isLoading;
  final String? hintText;
  final String? emptyText;
  final bool compact;
  final bool isActive;

  static double fieldMinHeight({bool compact = false}) =>
      compact ? 44.h : 52.h;

  @override
  State<MultiSelectPopupDropdown<T>> createState() =>
      _MultiSelectPopupDropdownState<T>();
}

class _MultiSelectPopupDropdownState<T>
    extends State<MultiSelectPopupDropdown<T>> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey();
  bool _hasFocus = false;
  bool _isLoadingItems = false;
  List<MultiSelectOption<T>> _cachedItems = const [];

  static const double _menuMaxHeight = 320;

  @override
  void initState() {
    super.initState();
    _cachedItems = widget.items;
    _hasFocus = _focusNode.hasFocus;
    _focusNode.addListener(() {
      if (_hasFocus != _focusNode.hasFocus) {
        setState(() => _hasFocus = _focusNode.hasFocus);
      }
    });
  }

  @override
  void didUpdateWidget(covariant MultiSelectPopupDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loadItems == null && widget.items != oldWidget.items) {
      _cachedItems = widget.items;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<MultiSelectOption<T>> get _effectiveItems =>
      _cachedItems.isNotEmpty ? _cachedItems : widget.items;

  String _displayText() {
    if (widget.selected.isEmpty) {
      return widget.hintText ?? '';
    }

    final labels = _effectiveItems
        .where((item) => widget.selected.contains(item.value))
        .map((item) => item.label)
        .toList();

    if (labels.isEmpty) {
      return widget.selected.map((e) => e.toString()).join('، ');
    }

    if (labels.length <= 2) {
      return labels.join('، ');
    }

    return '${labels.take(2).join('، ')} (+${labels.length - 2})';
  }

  Future<void> _openMenu() async {
    if (widget.isLoading || _isLoadingItems) return;

    if (widget.loadItems != null) {
      setState(() => _isLoadingItems = true);
      try {
        _cachedItems = await widget.loadItems!();
      } catch (_) {
        _cachedItems = const [];
      }
      if (!mounted) return;
      setState(() => _isLoadingItems = false);
    }

    final items = _effectiveItems;
    if (items.isEmpty) return;

    final overlayState = Overlay.of(context);
    final colors = context.appColorsRead;
    final dialogContext = context;

    await SchedulerBinding.instance.endOfFrame;

    if (!mounted) return;

    final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final overlayBox =
        overlayState.context.findRenderObject() as RenderBox?;
    if (overlayBox == null) return;

    final fieldOffset =
        renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final fieldSize = renderBox.size;
    final overlaySize = overlayBox.size;
    const gap = 4.0;

    final spaceBelow =
        overlaySize.height - fieldOffset.dy - fieldSize.height - gap;
    final showBelow = spaceBelow >= 120;

    final menuTop = showBelow
        ? fieldOffset.dy + fieldSize.height + gap
        : (fieldOffset.dy - _menuMaxHeight - gap).clamp(0.0, overlaySize.height);

    if (!mounted) return;

    final localSelected = Set<T>.from(widget.selected);

    await showGeneralDialog<void>(
      context: dialogContext,
      barrierDismissible: true,
      barrierLabel: 'dismiss',
      barrierColor: Colors.transparent,
      pageBuilder: (dialogContext, _, __) {
        return Stack(
          children: [
            Positioned(
              left: fieldOffset.dx,
              top: menuTop,
              width: fieldSize.width,
              child: Material(
                color: colors.kInputColor,
                elevation: 8,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  constraints: BoxConstraints(maxHeight: _menuMaxHeight),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: colors.kBorderColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setMenuState) {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: colors.kBorderColor.withValues(alpha: 0.25),
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isSelected = localSelected.contains(item.value);

                          return InkWell(
                            onTap: () {
                              setMenuState(() {
                                if (isSelected) {
                                  localSelected.remove(item.value);
                                } else {
                                  localSelected.add(item.value);
                                }
                              });
                              widget.onSelectionChanged(
                                Set<T>.from(localSelected),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              child: Row(
                                textDirection:
                                    FormLayout.directionOf(context),
                                children: [
                                  SizedBox(
                                    width: 28.w,
                                    height: 28.w,
                                    child: Checkbox(
                                      value: isSelected,
                                      activeColor: colors.kPrimaryColor,
                                      side: BorderSide(
                                        color: colors.kBorderColor
                                            .withValues(alpha: 0.6),
                                      ),
                                      onChanged: (_) {
                                        setMenuState(() {
                                          if (isSelected) {
                                            localSelected.remove(item.value);
                                          } else {
                                            localSelected.add(item.value);
                                          }
                                        });
                                        widget.onSelectionChanged(
                                          Set<T>.from(localSelected),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      textAlign: FormLayout.alignOf(context),
                                      textDirection:
                                          FormLayout.directionOf(context),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colors.kFontColor,
                                        fontSize: 15.sp,
                                        fontFamily: 'Almarai',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasSelection = widget.selected.isNotEmpty;
    final isActive = widget.isActive || hasSelection;
    final borderColor = _hasFocus
        ? colors.kPrimaryColor
        : isActive
            ? colors.kPrimaryColor
            : colors.kBorderColor.withValues(alpha: 0.45);
    final fieldColor = isActive
        ? colors.kPrimaryColor.withValues(alpha: 0.12)
        : colors.kInputColor;
    final showLoading = widget.isLoading || _isLoadingItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: widget.compact ? 13.sp : 15.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? colors.kPrimaryColor : colors.kFontColor,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: widget.compact ? 6.h : 10.h),
        InkWell(
          onTap: showLoading ? null : _openMenu,
          borderRadius: BorderRadius.circular(14.r),
          child: Focus(
            focusNode: _focusNode,
            child: Container(
              key: _fieldKey,
              constraints: BoxConstraints(
                minHeight: MultiSelectPopupDropdown.fieldMinHeight(
                  compact: widget.compact,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? 10.w : 14.w,
                vertical: widget.compact ? 10.h : 14.h,
              ),
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: borderColor,
                  width: _hasFocus || isActive ? 1.5 : 1,
                ),
              ),
              child: Row(
                textDirection: FormLayout.directionOf(context),
                children: [
                  Expanded(
                    child: Text(
                      hasSelection
                          ? _displayText()
                          : (widget.hintText ?? widget.emptyText ?? ''),
                      textAlign: FormLayout.alignOf(context),
                      textDirection: FormLayout.directionOf(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isActive
                            ? colors.kPrimaryColor
                            : colors.kGrayColor,
                        fontSize: widget.compact ? 13.sp : 15.sp,
                        fontFamily: 'Almarai',
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (showLoading)
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
                      color: _hasFocus || isActive
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
}
