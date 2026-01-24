import 'package:audioplayers/audioplayers.dart';

class AudioController {
  // ================= SINGLETON =================
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;

  // ================= STATE =================
  bool musicEnabled = true;
  bool sfxEnabled = true;

  String? _currentBGM;

  // ================= 🎵 BGM =================
  Future<void> playBGM(String assetPath, {double volume = 0.5}) async {
    _currentBGM = assetPath;

    if (!musicEnabled) return;

    _bgmPlayer ??= AudioPlayer();
    await _bgmPlayer!.stop();
    await _bgmPlayer!.setSource(AssetSource(assetPath));
    await _bgmPlayer!.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer!.setVolume(volume);
    await _bgmPlayer!.resume();
  }

  Future<void> stopBGM() async {
    await _bgmPlayer?.stop();
  }

  Future<void> pauseBGM() async {
    await _bgmPlayer?.pause();
  }

  Future<void> resumeLastBGM({double volume = 0.5}) async {
    if (!musicEnabled || _currentBGM == null) return;
    await playBGM(_currentBGM!, volume: volume);
  }

  // ================= 🔊 SFX =================
  Future<void> playSFX(String assetPath, {double volume = 1.0}) async {
    if (!sfxEnabled) return;

    _sfxPlayer ??= AudioPlayer();
    await _sfxPlayer!.setSource(AssetSource(assetPath));
    await _sfxPlayer!.setVolume(volume);
    await _sfxPlayer!.resume();
  }
}
