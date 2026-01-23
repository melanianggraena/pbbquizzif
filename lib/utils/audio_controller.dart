// File: lib/controllers/audio_controller.dart
import 'package:audioplayers/audioplayers.dart';

class AudioController {
  // Singleton supaya gampang dipanggil di mana aja
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;

  // =======================
  // 🎵 BACKGROUND MUSIC
  // =======================
  void playBGM(String assetPath, {double volume = 0.5}) async {
    _bgmPlayer ??= AudioPlayer();
    await _bgmPlayer!.setSource(AssetSource(assetPath));
    _bgmPlayer!.setReleaseMode(ReleaseMode.loop);
    _bgmPlayer!.setVolume(volume);
    _bgmPlayer!.resume();
  }

  void stopBGM() {
    _bgmPlayer?.stop();
    _bgmPlayer?.dispose();
    _bgmPlayer = null;
  }

  void pauseBGM() => _bgmPlayer?.pause();
  void resumeBGM() => _bgmPlayer?.resume();

  // =======================
  // 🔊 SOUND EFFECT
  // =======================
  void playSFX(String assetPath, {double volume = 1.0}) async {
    _sfxPlayer ??= AudioPlayer();
    await _sfxPlayer!.setSource(
      AssetSource(assetPath),
    ); // ini yang kamu tanyain
    _sfxPlayer!.setVolume(volume);
    _sfxPlayer!.resume(); // play
  }
}
