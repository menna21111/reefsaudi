import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext? resolveToastContext([BuildContext? context]) {
  if (context != null && context.mounted) {
    if (Overlay.maybeOf(context, rootOverlay: true) != null) {
      return context;
    }
  }

  final overlayContext = navigatorKey.currentState?.overlay?.context;
  if (overlayContext != null && overlayContext.mounted) {
    return overlayContext;
  }

  final navigatorContext = navigatorKey.currentContext;
  if (navigatorContext != null &&
      navigatorContext.mounted &&
      Overlay.maybeOf(navigatorContext, rootOverlay: true) != null) {
    return navigatorContext;
  }

  return null;
}
