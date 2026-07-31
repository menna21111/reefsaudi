import 'dart:async';

import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class VoiceRecordingWaves extends StatefulWidget {
  const VoiceRecordingWaves({
    required this.amplitudeStream,
    required this.isListening,
    required this.isThinking,
    super.key,
  });

  final Stream<double> amplitudeStream;
  final bool isListening;
  final bool isThinking;

  @override
  State<VoiceRecordingWaves> createState() => _VoiceRecordingWavesState();
}

class _VoiceRecordingWavesState extends State<VoiceRecordingWaves>
    with SingleTickerProviderStateMixin {
  final List<double> _heights = [];
  static const int _maxBars = 80;
  static const double _barWidth = 4;
  static const double _minHeight = 8;
  static const double _maxHeight = 24;

  StreamSubscription<double>? _amplitudeSub;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _listenToAmplitude();
  }

  @override
  void didUpdateWidget(VoiceRecordingWaves oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _heights.clear();
    }
    if (widget.amplitudeStream != oldWidget.amplitudeStream) {
      _amplitudeSub?.cancel();
      _listenToAmplitude();
    }
    if (widget.isThinking && !oldWidget.isThinking) {
      _shimmerController.repeat();
    } else if (!widget.isThinking) {
      _shimmerController
        ..stop()
        ..reset();
    }
  }

  void _listenToAmplitude() {
    _amplitudeSub?.cancel();
    _amplitudeSub = widget.amplitudeStream.listen((normalized) {
      if (!mounted) {
        return;
      }

      setState(() {
        final height =
            _minHeight + (_maxHeight - _minHeight) * normalized.clamp(0.0, 1.0);
        _heights.add(height);
        if (_heights.length > _maxBars) {
          _heights.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _amplitudeSub?.cancel();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final showShimmer = widget.isThinking;
    if (showShimmer && _shimmerController.status != AnimationStatus.forward) {
      _shimmerController.repeat();
    }

    if (_heights.isEmpty) {
      return SizedBox(
        height: _maxHeight,
        child: showShimmer
            ? _buildShimmerOverlay(colors: colors, child: _buildPlaceholderBars(colors))
            : _buildPlaceholderBars(colors),
      );
    }

    return SizedBox(
      height: _maxHeight,
      child: showShimmer
          ? _buildShimmerOverlay(colors: colors, child: _buildBarList(colors))
          : _buildBarList(colors),
    );
  }

  Widget _buildPlaceholderBars(AppColors colors) {
    const barCount = 5;
    const h = 12.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        barCount,
        (i) => Container(
          width: _barWidth,
          height: h,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: colors.electricTeal.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildBarList(AppColors colors) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _heights.isEmpty ? 1 : _heights.length,
      itemBuilder: (context, index) {
        final h = _heights.isEmpty ? _minHeight : _heights[index];
        return Container(
          width: _barWidth,
          height: h,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.center,
          child: Container(
            width: _barWidth,
            height: h,
            decoration: BoxDecoration(
              color: colors.electricTeal,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerOverlay({
    required AppColors colors,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              stops: [
                0.0,
                (_shimmerController.value - 0.2).clamp(0.0, 1.0),
                _shimmerController.value,
                (_shimmerController.value + 0.2).clamp(0.0, 1.0),
                1.0,
              ],
              colors: [
                Colors.transparent,
                Colors.transparent,
                colors.offWhite.withValues(alpha: 0.6),
                Colors.transparent,
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}
