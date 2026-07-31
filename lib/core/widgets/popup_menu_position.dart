import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_theme_context.dart';

/// Shows a popup menu anchored to [anchorKey], matching Flutter's
/// [PopupMenuButton] positioning so the menu sits flush below/above the field.
Future<T?> showAnchoredPopupMenu<T>({
  required BuildContext context,
  required GlobalKey anchorKey,
  required List<PopupMenuEntry<T>> items,
  double maxHeight = 320,
  double gap = 4,
}) async {
  if (items.isEmpty) return null;

  final colors = context.appColorsRead;

  await SchedulerBinding.instance.endOfFrame;
  if (!context.mounted) return null;

  final renderBox = anchorKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null || !renderBox.hasSize) return null;

  // Use the root overlay so menus inside sheets/scroll views aren't clipped
  // or mis-positioned by nested navigators.
  final overlayState = Overlay.of(context, rootOverlay: true);
  final overlayBox = overlayState.context.findRenderObject() as RenderBox?;
  if (overlayBox == null) return null;

  final fieldTopLeft = renderBox.localToGlobal(
    Offset.zero,
    ancestor: overlayBox,
  );
  final fieldBottomRight = renderBox.localToGlobal(
    renderBox.size.bottomRight(Offset.zero),
    ancestor: overlayBox,
  );
  final overlaySize = overlayBox.size;
  final viewInsets = MediaQuery.viewInsetsOf(context);
  final usableBottom = overlaySize.height - viewInsets.bottom;

  // Expand the anchor slightly by [gap] so the menu sits tight to the field.
  final anchorRect = Rect.fromLTRB(
    fieldTopLeft.dx,
    fieldTopLeft.dy - gap,
    fieldBottomRight.dx,
    fieldBottomRight.dy + gap,
  ).intersect(Rect.fromLTWH(0, 0, overlaySize.width, usableBottom));

  final position = RelativeRect.fromRect(
    anchorRect,
    Offset.zero & Size(overlaySize.width, usableBottom),
  );

  final fieldWidth = renderBox.size.width;
  final menuMaxWidth = math.min(
    overlaySize.width - 24.w,
    math.max(fieldWidth, 280.w),
  );

  if (!context.mounted) return null;

  return showMenu<T>(
    context: context,
    useRootNavigator: true,
    color: colors.kInputColor,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.r),
      side: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.4)),
    ),
    position: position,
    constraints: BoxConstraints(
      minWidth: fieldWidth,
      maxWidth: menuMaxWidth,
      maxHeight: maxHeight,
    ),
    items: items,
  );
}
