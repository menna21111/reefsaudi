import 'package:audioplayers/audioplayers.dart';

class SoundHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSuccess() async {
    try {
      await _player.play(AssetSource('sound/scuess_order.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static void dispose() {
    _player.dispose();
  }
}
