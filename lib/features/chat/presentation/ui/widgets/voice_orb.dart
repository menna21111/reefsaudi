import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoiceOrb extends StatefulWidget {
  const VoiceOrb({
    required this.isListening,
    required this.onPressEnd,
    this.onPressStart,
    this.onPressCancel,
    this.compact = false,
    super.key,
  });
  final bool isListening;
  final VoidCallback? onPressStart;
  final VoidCallback onPressEnd;
  final VoidCallback? onPressCancel;
  final bool compact;

  @override
  State<VoiceOrb> createState() => _VoiceOrbState();
}

class _VoiceOrbState extends State<VoiceOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  Offset? _longPressStart;
  bool _slideCancelTriggered = false;
  bool _isHovered = false;

  static const double _slideCancelThreshold = 100;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // ✅ OPTIMIZED: Only animate when listening, not constantly

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 4,
      end: 20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Check initial state (in case we start in listening mode)
    if (widget.isListening) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VoiceOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ✅ SMART ANIMATION: Only run when needed
    if (widget.isListening && !oldWidget.isListening) {
      _controller.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _controller
        ..stop()
        ..reset(); // Go back to size 1.0
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      // Long press to start, release to stop & send; slide to cancel
      onLongPressStart: widget.onPressStart == null
          ? null
          : (details) {
              HapticFeedback.mediumImpact();
              _longPressStart = details.localPosition;
              _slideCancelTriggered = false;
              widget.onPressStart!();
            },
      onLongPressMoveUpdate: (details) {
        if (_slideCancelTriggered ||
            _longPressStart == null ||
            widget.onPressCancel == null) {
          return;
        }
        final delta = details.localPosition - _longPressStart!;
        final distance = delta.distance;
        if (distance > _slideCancelThreshold) {
          _slideCancelTriggered = true;
          HapticFeedback.lightImpact();
          widget.onPressCancel!();
        }
      },
      onLongPressEnd: (_) {
        final wasSlideCancelled = _slideCancelTriggered;
        _longPressStart = null;
        _slideCancelTriggered = false;
        // Release = stop and send, unless user already cancelled via slide
        if (!wasSlideCancelled && widget.isListening) {
          HapticFeedback.lightImpact();
          widget.onPressEnd();
        }
      },
      onTap: () {
        if (widget.isListening) {
          HapticFeedback.lightImpact();
          widget.onPressEnd();
        }
      },
      onLongPressCancel: () {
        final wasInActiveHold = _longPressStart != null;
        _longPressStart = null;
        _slideCancelTriggered = false;
        // Only cancel when we were in active hold (slide out). Tap-to-stop
        // makes LongPress lose and fires this — skip, let onTap call
        // onPressEnd.

        if (wasInActiveHold) {
          HapticFeedback.lightImpact();
          (widget.onPressCancel ?? widget.onPressEnd)();
        }
      },

      // Fixed size to match send button and text field row
      // (56 = kInputSlotSize)
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final size = widget.compact ? 48.0 : 70.0;
                final iconSize = widget.compact ? 24.0 : 32.0;
                final hoverScale = _isHovered && !widget.isListening
                    ? 1.08
                    : 1.0;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: AnimatedScale(
                    scale: hoverScale,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: widget.isListening
                            ? colors.orbGradient
                            : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _isHovered
                                    ? [
                                        colors.slateGrey,
                                        colors.electricTeal.withValues(
                                          alpha: 0.4,
                                        ),
                                      ]
                                    : [
                                        colors.secondaryNavy,
                                        colors.slateGrey,
                                      ],
                              ),
                        boxShadow: widget.isListening
                            ? [
                                BoxShadow(
                                  color: colors.electricTeal.withValues(
                                    alpha: 0.6,
                                  ),
                                  blurRadius: _glowAnimation.value,
                                  spreadRadius: _glowAnimation.value / 2,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: _isHovered
                                      ? colors.electricTeal.withValues(
                                          alpha: 0.25,
                                        )
                                      : colors.offWhite.withValues(alpha: 0.12),
                                  blurRadius: _isHovered ? 8 : 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Transform.scale(
                        scale: widget.isListening ? _scaleAnimation.value : 1.0,
                        child: Icon(
                          widget.isListening ? Icons.mic : Icons.mic_none,
                          color: widget.isListening
                              ? colors.primaryNavy
                              : colors.offWhite,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
