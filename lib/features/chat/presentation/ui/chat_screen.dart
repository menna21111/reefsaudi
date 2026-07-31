import 'dart:async';
import 'dart:typed_data';

import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';
import 'package:reefsaudia/features/chat/core/services/audio_player_service.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/chat_app_bar.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/chat_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  late final AudioPlayerService _audioPlayerService;
  StreamSubscription<Uint8List>? _audioSub;
  StreamSubscription<ChatState>? _cubitSub;
  final AppLogger _logger = AppLogger();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _audioPlayerService = GetIt.instance<AudioPlayerService>();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _audioPlayerService.init();

    if (!mounted) {
      return;
    }

    final cubit = context.read<ChatCubit>();

    // Reset AI voice when user sends new message or presses mic
    _cubitSub = cubit.stream.listen((state) async {
      if (state.status == ChatStatus.thinking ||
          state.status == ChatStatus.listening) {
        await _audioPlayerService.reset();
      }
    });

    // Listen to raw audio stream and feed to player
    _audioSub = cubit.rawAudioStream.listen(
      (chunk) => _audioPlayerService.feedChunk(chunk),
      onError: (Object e, StackTrace st) => _logger.e('Stream Error', e, st),
    );
  }

  @override
  void dispose() {
    _cubitSub?.cancel();
    _audioSub?.cancel();
    _audioPlayerService.reset();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ChatAppBar(),
      body: ChatScreenBody(
        scrollController: _scrollController,
        textController: _textController,
        onScrollToBottom: _scrollToBottom,
        onStopAudio: _audioPlayerService.reset,
      ),
    );
  }
}
