import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TypewriterMarkdown extends StatefulWidget {
  const TypewriterMarkdown({
    required this.text,
    super.key,
    this.duration = const Duration(milliseconds: 30),
    this.onFinished,
    this.onChanged,
    this.styleSheet,
  });
  final String text;
  final Duration duration;
  final VoidCallback? onFinished;
  final VoidCallback? onChanged; // Callback for size changes
  final MarkdownStyleSheet? styleSheet;

  @override
  State<TypewriterMarkdown> createState() => _TypewriterMarkdownState();
}

class _TypewriterMarkdownState extends State<TypewriterMarkdown>
    with AutomaticKeepAliveClientMixin<TypewriterMarkdown> {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didUpdateWidget(TypewriterMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      // The text is streaming in (growing). DO NOT reset to 0!
      // Just ensure the timer is running so it can catch up to the new length.
      if (!(_timer?.isActive ?? false)) {
        _startAnimation();
      }
    }
  }

  void _startAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.duration, (timer) {
      if (_currentIndex < widget.text.characters.length) {
        setState(() {
          _currentIndex++;
          _displayedText = widget.text.characters
              .take(_currentIndex)
              .toString();
        });
        widget.onChanged?.call(); // Notify parent of change
      } else {
        _timer?.cancel();
        widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // important for AutomaticKeepAliveClientMixin
    return RepaintBoundary(
      child: MarkdownBody(
        data: _displayedText,
        styleSheet: widget.styleSheet,
        softLineBreak: true,
      ),
    );
  }
}
