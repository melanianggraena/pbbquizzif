import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';
import 'profile.dart';
import 'package:ppbquizzif/utils/audio_controller.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  // ================= START BUTTON =================
  Future<void> _onStart() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isProfileCompleted =
        prefs.getBool('isProfileCompleted') ?? false;

    if (!mounted) return;

    // 🎧 play BGM saat user klik START (AMAN)
    await AudioController().playBGM(
      'audio/music/home_bgm.mp3',
      volume: 0.5,
    );

    if (!isProfileCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(isFirstTime: true),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [

              const SizedBox(height: 12),

              // ================= LOGO =================
              SvgPicture.asset(
                'assets/quizzif_logo.svg',
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 12),

              // ================= ILLUSTRATION =================
              Expanded(
                child: SvgPicture.asset(
                  'assets/intro1.svg',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              // ================= START BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'START',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Copyright © 2026 Kelompok DDMT",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
