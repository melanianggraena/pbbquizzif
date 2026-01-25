import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart'; // ini buat debugPrint


class AudioController {
  // ================= SINGLETON =================
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  // ================= AUDIO PLAYERS =================
  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;

  // ================= STATE =================
  bool musicEnabled = true;
  bool sfxEnabled = true;

  String? _currentBGM;

  // ================= 🎵 BGM =================
  /// Play background music (looping)
  Future<void> playBGM(String assetPath, {double volume = 0.5}) async {
    if (!musicEnabled) return;

    _currentBGM = assetPath;

    _bgmPlayer ??= AudioPlayer();
    try {
      await _bgmPlayer!.stop(); // stop dulu kalau lagi play
      await _bgmPlayer!.setSource(AssetSource(assetPath));
      await _bgmPlayer!.setReleaseMode(ReleaseMode.loop); // loop
      await _bgmPlayer!.setVolume(volume);
      await _bgmPlayer!.resume();
      debugPrint('BGM playing: $assetPath');
    } catch (e) {
      debugPrint('Error playBGM: $e');
    }
  }

  Future<void> stopBGM() async {
    try {
      await _bgmPlayer?.stop();
      debugPrint('BGM stopped');
    } catch (e) {
      debugPrint('Error stopBGM: $e');
    }
  }

  Future<void> pauseBGM() async {
    try {
      await _bgmPlayer?.pause();
      debugPrint('BGM paused');
    } catch (e) {
      debugPrint('Error pauseBGM: $e');
    }
  }

  Future<void> resumeLastBGM({double volume = 0.5}) async {
    if (!musicEnabled || _currentBGM == null) return;
    await playBGM(_currentBGM!, volume: volume);
  }

  // ================= 🔊 SFX =================
  Future<void> playSFX(String assetPath, {double volume = 1.0}) async {
    if (!sfxEnabled) return;

    _sfxPlayer ??= AudioPlayer();
    try {
      await _sfxPlayer!.setSource(AssetSource(assetPath));
      await _sfxPlayer!.setVolume(volume);
      await _sfxPlayer!.resume();
      debugPrint('SFX played: $assetPath');
    } catch (e) {
      debugPrint('Error playSFX: $e');
    }
  }
}
