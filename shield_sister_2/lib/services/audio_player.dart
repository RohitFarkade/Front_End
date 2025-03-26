import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerUtil {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playBuzzer() async {
    try {
      debugPrint("Attempting to load asset: assets/sample.wav");
      await _player.setAsset('assets/sample.wav');
      debugPrint("Asset loaded successfully");
      await _player.play();
      debugPrint("Buzzer playback completed");
    } catch (e) {
      debugPrint("Error playing buzzer: $e");
      if (e.toString().contains("Unable to load asset")) {
        debugPrint("Check if assets/sample.wav exists and is correctly declared in pubspec.yaml");
      }
    }
  }

  static Future<void> stop() async {
    try {
      await _player.stop();
      debugPrint("Buzzer stopped");
    } catch (e) {
      debugPrint("Error stopping buzzer: $e");
    }
  }
}