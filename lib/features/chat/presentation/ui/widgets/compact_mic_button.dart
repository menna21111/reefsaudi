import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/voice_orb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompactMicButton extends StatelessWidget {
  const CompactMicButton({
    required this.onScrollToBottom,
    required this.onStopAudio,
    required this.isBusy,
    super.key,
  });

  final VoidCallback onScrollToBottom;
  final Future<void> Function() onStopAudio;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) =>
          previous.status.isListening != current.status.isListening,
      builder: (context, state) {
        return VoiceOrb(
          isListening: state.status.isListening,
          compact: true,
          onPressStart: isBusy
              ? null
              : () {
                  onStopAudio();
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<ChatCubit>().startRecording();
                  onScrollToBottom();
                },
          onPressEnd: () {
            HapticFeedback.lightImpact();
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<ChatCubit>().stopRecording();
            onScrollToBottom();
          },
          onPressCancel: () {
            HapticFeedback.lightImpact();
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<ChatCubit>().cancelRecording();
            onScrollToBottom();
          },
        );
      },
    );
  }
}
