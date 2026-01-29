import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioController {
  // ================= SINGLETON =================
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  // ================= PLAYERS =================
  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;

  // ================= STATE =================
  bool musicEnabled = true;
  bool sfxEnabled = true;

  String? _currentBGM;
  double _currentBGMVolume = 0.5;

  // ================= 🎵 BGM =================
  Future<void> playBGM(String assetPath, {double volume = 0.5}) async {
    if (!musicEnabled) {
      debugPrint('🔇 Music disabled, skipping BGM');
      return;
    }

    _bgmPlayer ??= AudioPlayer();

    // ✅ Kalau lagu yang sama & sudah jalan → jangan restart (PENTING!)
    if (_currentBGM == assetPath &&
        _bgmPlayer!.state == PlayerState.playing) {
      debugPrint('🎧 BGM already playing: $assetPath');
      return;
    }

    _currentBGM = assetPath;
    _currentBGMVolume = volume;

    try {
      await _bgmPlayer!.stop(); // Stop dulu kalau ada yang lagi jalan
      await _bgmPlayer!.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer!.setVolume(volume);
      await _bgmPlayer!.play(AssetSource(assetPath)); // ✅ PLAY bukan RESUME

      debugPrint('🎵 BGM started: $assetPath');
    } catch (e) {
      debugPrint('❌ Error playBGM: $e');
    }
  }

  Future<void> pauseBGM() async {
    try {
      await _bgmPlayer?.pause();
      debugPrint('⏸️ BGM paused');
    } catch (e) {
      debugPrint('❌ Error pauseBGM: $e');
    }
  }

  Future<void> stopBGM() async {
    try {
      await _bgmPlayer?.stop();
      _currentBGM = null; // ✅ Clear current BGM
      debugPrint('⏹️ BGM stopped');
    } catch (e) {
      debugPrint('❌ Error stopBGM: $e');
    }
  }

  Future<void> resumeBGM() async {
    if (!musicEnabled) {
      debugPrint('🔇 Music disabled, skipping resume');
      return;
    }
    
    try {
      await _bgmPlayer?.resume();
      debugPrint('▶️ BGM resumed');
    } catch (e) {
      debugPrint('❌ Error resumeBGM: $e');
    }
  }

  Future<void> resumeLastBGM({double? volume}) async {
    if (!musicEnabled || _currentBGM == null) {
      debugPrint('ℹ️ No BGM to resume or music disabled');
      return;
    }

    await playBGM(_currentBGM!, volume: volume ?? _currentBGMVolume);
  }

  // ================= 🔊 SFX =================
  Future<void> playSFX(String assetPath, {double volume = 1.0}) async {
    if (!sfxEnabled) {
      debugPrint('🔇 SFX disabled, skipping');
      return;
    }

    _sfxPlayer ??= AudioPlayer();

    try {
      await _sfxPlayer!.stop(); // Stop SFX sebelumnya
      await _sfxPlayer!.setVolume(volume);
      await _sfxPlayer!.play(AssetSource(assetPath));

      debugPrint('🔊 SFX played: $assetPath');
    } catch (e) {
      debugPrint('❌ Error playSFX: $e');
    }
  }

  // ================= 🧹 CLEANUP (OPTIONAL) =================
  Future<void> dispose() async {
    await _bgmPlayer?.dispose();
    await _sfxPlayer?.dispose();
    _bgmPlayer = null;
    _sfxPlayer = null;
    debugPrint('🗑️ AudioController disposed');
  }
}