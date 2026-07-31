import 'package:reefsaudia/features/chat/core/services/excel_export_service.dart';
import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/copy_button.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/dynamic_thinking_block.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/feedback_row_widget.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/message_bubble_container.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/message_content.dart';
import 'package:flutter/material.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    required this.text,
    required this.isUser,
    required this.isLastMessage,
    required this.onTextChanged,
    required this.messageId,
    this.isComplete = true,
    this.isVoice = false,
    this.rating,
    this.thinkingSteps = const [],
    this.isGenerating = false,
    this.isThinkingExpanded = false,
    super.key,
  });

  final String text;
  final bool isUser;
  final bool isLastMessage;
  final VoidCallback onTextChanged;

  /// Unique ID of this message (for feedback routing).
  final String messageId;

  /// False while the AI is still streaming this message.
  /// Feedback buttons are hidden until the response is complete.
  final bool isComplete;

  /// True if this message was spoken (voice input/output).
  final bool isVoice;

  /// 'thumbs_up' | 'thumbs_down' | null (unrated)
  final String? rating;

  /// AI thinking/status steps for the DynamicThinkingBlock.
  final List<String> thinkingSteps;

  /// Whether the AI is actively generating this message.
  final bool isGenerating;

  /// Whether the thinking accordion is expanded.
  final bool isThinkingExpanded;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble>
    with AutomaticKeepAliveClientMixin {
  // We assume it's typing if it's the last AI message
  late bool _isTyping;

  /// Once the typewriter animation finishes, this flag locks so the
  /// animation never replays even if `isLastMessage` toggles back to true
  /// (e.g. when a pending voice bubble is added then removed).
  bool _hasAnimated = false;

  @override
  bool get wantKeepAlive => !widget.isUser;

  @override
  void initState() {
    super.initState();
    _isTyping = !widget.isUser && widget.isLastMessage;
  }

  @override
  void didUpdateWidget(covariant ChatMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If it's no longer the last message, it's definitely done typing
    if (!widget.isLastMessage && _isTyping) {
      _isTyping = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = AppColors.of(context);
    // Action row only shows when backend is done AND typewriter animation finishes
    final showActionRow = !widget.isUser && widget.isComplete && !_isTyping;
    // Matches variations like |---|, | --- |, |:---:|, etc.
    final hasTable = RegExp(r'\|[\s\-:]+\|').hasMatch(widget.text);
    // Strip out the hidden AI file tag so the user never sees it in the UI
    final cleanText =
        widget.text.replaceAll(RegExp(r'\[File:\s*.*?\]'), '').trim();

    return Align(
      // User bubble Right (centerStart RTL), AI bubble Left (centerEnd RTL)
      alignment: widget.isUser
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Column(
          // Force children to align Right (start in RTL); Thinking aligns with
          // Arabic text.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. THINKING BLOCK (ABOVE THE BUBBLE)
            if (!widget.isUser &&
                (widget.thinkingSteps.isNotEmpty || widget.isGenerating))
              Padding(
                // Match MessageBubbleContainer padding so ✨ aligns with text.
                padding: const EdgeInsets.only(bottom: 6, right: 16, left: 16),
                child: DynamicThinkingBlock(
                  messageId: widget.messageId,
                  thinkingSteps: widget.thinkingSteps,
                  isGenerating: widget.isGenerating,
                  isThinkingExpanded: widget.isThinkingExpanded,
                ),
              ),

            // 2. THE BUBBLE ITSELF
            if (cleanText.isNotEmpty)
              MessageBubbleContainer(
                isUser: widget.isUser,
                child: MessageContent(
                  text: cleanText,
                  isUser: widget.isUser,
                  isLastMessage: widget.isLastMessage && !_hasAnimated,
                  onTextChanged: widget.onTextChanged,
                  onFinishedTyping: () {
                    if (mounted && _isTyping) {
                      setState(() {
                        _isTyping = false;
                        _hasAnimated = true;
                      });
                    }
                  },
                ),
              ),

            // 3. FEEDBACK ROW (ALIGNED RIGHT)
            if (showActionRow && cleanText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CopyButton(text: cleanText),
                    if (hasTable)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.table_chart_outlined,
                          size: 18,
                          color: colors.slateGrey.withValues(alpha: 0.5),
                        ),
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'جاري تجهيز ملف الإكسل...',
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );

                          final success = await ExcelExportService
                              .exportTableFromMarkdown(widget.text);

                          if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'حدث خطأ أثناء تصدير الملف',
                                  style: TextStyle(fontFamily: 'Cairo'),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    FeedbackRowWidget(
                      messageId: widget.messageId,
                      currentRating: widget.rating,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
