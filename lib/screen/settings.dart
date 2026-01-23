import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool musicOn = true;
  bool soundOn = true;

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
                      onPressed: () => Navigator.pop(context),
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
                    _switchItem(
                      title: 'Music',
                      value: musicOn,
                      onChanged: (v) {
                        setState(() => musicOn = v);
                        // TODO: play / stop bg music
                      },
                    ),
                    const SizedBox(height: 16),
                    _switchItem(
                      title: 'Sound Effects',
                      value: soundOn,
                      onChanged: (v) {
                        setState(() => soundOn = v);
                        // TODO: enable / disable SFX
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
