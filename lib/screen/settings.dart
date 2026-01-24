import 'package:flutter/material.dart';
import '../utils/audio_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AudioController audio = AudioController();

  late bool musicOn;
  late bool soundOn;

  @override
  void initState() {
    super.initState();

    // 🔥 AMBIL STATE GLOBAL DARI AudioController
    musicOn = audio.musicEnabled;
    soundOn = audio.sfxEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        audio.playSFX(
                          'audio/sfx/button_click.mp3',
                          volume: 0.8,
                        );
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= CONTENT =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // ========= MUSIC =========
                    _switchItem(
                      title: 'Music',
                      value: musicOn,
                      onChanged: (v) async {
                        audio.playSFX('audio/sfx/button_click.mp3');

                        setState(() => musicOn = v);
                        audio.musicEnabled = v;

                        if (v) {
                          await audio.resumeLastBGM();
                        } else {
                          await audio.stopBGM();
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // ========= SOUND EFFECT =========
                    _switchItem(
                      title: 'Sound Effects',
                      value: soundOn,
                      onChanged: (v) {
                        audio.playSFX('audio/sfx/button_click.mp3');

                        setState(() => soundOn = v);
                        audio.sfxEnabled = v;
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              const Center(
                child: Text(
                  'Privacy Policy © QUIZZIF',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SWITCH ITEM =================
  Widget _switchItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: Colors.blueAccent,
      inactiveTrackColor: Colors.white30,
    );
  }
}
