import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/chat_input_send_button.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/chat_input_text_field.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/compact_mic_button.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/voice_recording_waves.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputArea extends StatefulWidget {
  const ChatInputArea({
    required this.textController,
    required this.onScrollToBottom,
    required this.onStopAudio,
    this.horizontalPadding = 6,
    super.key,
  });

  final TextEditingController textController;
  final VoidCallback onScrollToBottom;
  final Future<void> Function() onStopAudio;
  final double horizontalPadding;

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

/// Shared height for mic, send button, and text field (single-line)
/// in the input row.
const double kInputSlotSize = 56;

class _ChatInputAreaState extends State<ChatInputArea> {
  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasText = widget.textController.text.trim().isNotEmpty;

    return SafeArea(
      child: BlocBuilder<ChatCubit, ChatState>(
        buildWhen: (previous, current) =>
            previous.status.isListening != current.status.isListening ||
            previous.isBusy != current.isBusy,
        builder: (context, state) {
          final showRecordingMode = state.status.isListening;
          final isBusy = state.isBusy;

          return Transform.translate(
            offset: const Offset(0, -30),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: kInputSlotSize,
                    height: kInputSlotSize,
                    child: showRecordingMode || !hasText
                        ? CompactMicButton(
                            key: const ValueKey('stable_mic'),
                            isBusy: isBusy,
                            onScrollToBottom: widget.onScrollToBottom,
                            onStopAudio: widget.onStopAudio,
                          )
                        : ChatInputSendButton(
                            key: const ValueKey('send'),
                            isBusy: isBusy,
                            textController: widget.textController,
                          ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: showRecordingMode
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: ClipRect(
                                      child: VoiceRecordingWaves(
                                        amplitudeStream: context
                                            .read<ChatCubit>()
                                            .amplitudeStream,
                                        isListening: state.status.isListening,
                                        isThinking:
                                            state.status.isThinking &&
                                            state.wasVoiceInput,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.tr('swipeToCancel'),
                                  style: TextStyle(
                                    color: colors.slateGrey.withValues(
                                      alpha: 0.9,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RepaintBoundary(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: kInputSlotSize,
                              ),
                              child: ChatInputTextField(
                                isBusy: isBusy,
                                textController: widget.textController,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
