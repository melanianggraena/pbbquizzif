import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'quiz.dart';
import 'arcade.dart';
import 'profile.dart';
import 'settings.dart';
import '../utils/audio_controller.dart';
import 'package:flutter/widgets.dart';
import '../main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  String userName = 'John Brown';
  String userAvatar = 'assets/ava1.svg';
  final AudioController _audio = AudioController();

  @override
  void didChangeDependencies() {
  super.didChangeDependencies();

    // subscribe ke route observer
    routeObserver.subscribe(
      this,
      ModalRoute.of(context)! as PageRoute,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Dipanggil saat BALIK ke Home dari screen lain (Quiz)
    _audio.playBGM('audio/music/home_bgm.mp3', volume: 0.5);
  }


  @override
  void initState() {
    super.initState();
    _loadProfile();
    _initAudio();
  }

  Future<void> _initAudio() async {
    // Delay kecil agar widget sudah build
    await Future.delayed(const Duration(milliseconds: 500));
    await _audio.playBGM('audio/music/home_bgm.mp3', volume: 0.5);
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? userName;
      userAvatar = prefs.getString('userAvatar') ?? userAvatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F3C91), Color(0xFF1E6BFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ================= PROFILE HEADER =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _audio.playSFX('audio/sfx/button_click.mp3');
                        await Future.delayed(const Duration(milliseconds: 100));
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                        if (result != null && mounted) {
                          setState(() {
                            userName = result['name'];
                            userAvatar = result['avatar'];
                          });
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: SvgPicture.asset(
                                userAvatar,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.monetization_on, color: Color(0xFFFFC107), size: 18),
                              SizedBox(width: 4),
                              Text(
                                '301',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () async {
                            await _audio.playSFX('audio/sfx/button_click.mp3');
                            await Future.delayed(const Duration(milliseconds: 100));
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SettingsScreen()),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= AI CARD =================
              Center(
                child: SvgPicture.asset(
                  'assets/quiz.svg',
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),

              // ================= TEXT CARD =================
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Test your knowledge in Informatics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Learn, play, and improve your skills!',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _audio.playSFX('audio/sfx/button_click.mp3');
                          await Future.delayed(const Duration(milliseconds: 150));
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ModeSelectionScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          'Play Now',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= MODE SELECTION =================
class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  final AudioController _audio = AudioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F3C91), Color(0xFF1E6BFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () async {
                      await _audio.playSFX('audio/sfx/button_click.mp3');
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (mounted) Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SvgPicture.asset('assets/home2.svg', width: 400, height: 400),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Pick your path Classic, or Arcade. Dive in!',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _modeButton(
                      context: context,
                      text: 'Classic',
                      color: const Color(0xFFFFC107),
                      svgPath: 'assets/btn_classic.svg',
                      onTap: () async {
                        await _audio.playSFX('audio/sfx/button_click.mp3');
                        await Future.delayed(const Duration(milliseconds: 150));
                        await _audio.stopBGM();
                        await _audio.playBGM('audio/music/quiz_bgm.mp3', volume: 0.5);
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const QuizScreen(mode: 'classic')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _modeButton(
                      context: context,
                      text: 'Arcade',
                      color: const Color(0xFF22C55E),
                      svgPath: 'assets/btn_arcade.svg',
                      onTap: () async {
                        await _audio.playSFX('audio/sfx/button_click.mp3');
                        await Future.delayed(const Duration(milliseconds: 150));
                        await _audio.stopBGM();
                        await _audio.playBGM('audio/music/quiz_bgm.mp3', volume: 0.5);
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ArcadeCategoryScreen()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _modeButton({
    required BuildContext context,
    required String text,
    required Color color,
    required String svgPath,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 210,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath, height: 22),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
