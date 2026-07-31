import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Two-phase thinking block that matches Gemini/Claude UX:
///
/// **Phase 1 (Active):** Spinner + only the latest step with smooth fade.
/// **Phase 2 (Finished):** Collapsible "عمليات التفكير" accordion.
class DynamicThinkingBlock extends StatefulWidget {
  const DynamicThinkingBlock({
    required this.messageId,
    required this.thinkingSteps,
    required this.isGenerating,
    required this.isThinkingExpanded,
    super.key,
  });

  final String messageId;
  final List<String> thinkingSteps;
  final bool isGenerating;
  final bool isThinkingExpanded;

  @override
  State<DynamicThinkingBlock> createState() => _DynamicThinkingBlockState();
}

class _DynamicThinkingBlockState extends State<DynamicThinkingBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant DynamicThinkingBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isThinkingExpanded && !oldWidget.isThinkingExpanded) {
      _expandController.forward();
    } else if (!widget.isThinkingExpanded && oldWidget.isThinkingExpanded) {
      _expandController.reverse();
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Phase 1: Active generation — spinner + latest step (or default text)
    if (widget.isGenerating) {
      final latestStep = widget.thinkingSteps.isNotEmpty
          ? widget.thinkingSteps.last
          : 'جاري معالجة الطلب...'; // Default text before first chunk arrives

      return _ActiveThinkingRow(latestStep: latestStep);
    }

    // If not generating AND no steps, hide completely
    if (widget.thinkingSteps.isEmpty) {
      return const SizedBox.shrink();
    }

    // Phase 2: Finished — collapsible accordion
    return _FinishedThinkingAccordion(
      messageId: widget.messageId,
      thinkingSteps: widget.thinkingSteps,
      expandAnimation: _expandAnimation,
      isExpanded: widget.isThinkingExpanded,
    );
  }
}

/// Phase 1: Shows a spinner + the latest thinking step with animated fade.
class _ActiveThinkingRow extends StatelessWidget {
  const _ActiveThinkingRow({required this.latestStep});

  final String latestStep;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: colors.electricTeal,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                latestStep,
                key: ValueKey(latestStep),
                style: TextStyle(
                  color: colors.slateGrey.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Phase 2: Collapsible accordion showing all thinking steps.
class _FinishedThinkingAccordion extends StatelessWidget {
  const _FinishedThinkingAccordion({
    required this.messageId,
    required this.thinkingSteps,
    required this.expandAnimation,
    required this.isExpanded,
  });

  final String messageId;
  final List<String> thinkingSteps;
  final Animation<double> expandAnimation;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accordion header
          GestureDetector(
            onTap: () {
              context.read<ChatCubit>().toggleThinkingExpanded(messageId);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✨', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  'عمليات التفكير',
                  style: TextStyle(
                    color: colors.slateGrey.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: colors.slateGrey.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: expandAnimation,
            axisAlignment: -1,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: thinkingSteps
                    .map(
                      (step) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: colors.electricTeal.withValues(
                                    alpha: 0.6,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                step,
                                style: TextStyle(
                                  color: colors.slateGrey.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
