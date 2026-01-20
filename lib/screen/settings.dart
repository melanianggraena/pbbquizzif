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
            children: [
              _header(title: 'Settings', onBack: () => Navigator.pop(context)),

              const SizedBox(height: 30),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _settingItem(
                        icon: Icons.volume_up,
                        title: 'Music & Effects',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _MusicEffectsPage(
                                musicOn: musicOn,
                                soundOn: soundOn,
                                onChanged: (m, s) {
                                  setState(() {
                                    musicOn = m;
                                    soundOn = s;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      _settingItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        color: Colors.redAccent,
                        onTap: () {
                          // LOGOUT FUNCTION
                        },
                      ),

                      const Spacer(),

                      const Text(
                        'Privacy Policy © QUIZZIF',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header({required String title, VoidCallback? onBack}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.white70,
        ),
        onTap: onTap,
      ),
    );
  }
}

/* ===========================
   MUSIC & EFFECTS (GAMBAR 2)
   =========================== */

class _MusicEffectsPage extends StatefulWidget {
  final bool musicOn;
  final bool soundOn;
  final Function(bool, bool) onChanged;

  const _MusicEffectsPage({
    required this.musicOn,
    required this.soundOn,
    required this.onChanged,
  });

  @override
  State<_MusicEffectsPage> createState() => _MusicEffectsPageState();
}

class _MusicEffectsPageState extends State<_MusicEffectsPage> {
  late bool music;
  late bool sound;

  @override
  void initState() {
    super.initState();
    music = widget.musicOn;
    sound = widget.soundOn;
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
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        widget.onChanged(music, sound);
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Music & Effects',
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

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      _switchItem(
                        title: 'Music',
                        value: music,
                        onChanged: (v) {
                          setState(() => music = v);
                          // TODO: play / stop bg music
                        },
                      ),
                      const SizedBox(height: 16),
                      _switchItem(
                        title: 'Sound Effects',
                        value: sound,
                        onChanged: (v) {
                          setState(() => sound = v);
                          // TODO: enable / disable SFX
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
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
      ),
    );
  }
}
