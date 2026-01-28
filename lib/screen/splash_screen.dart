// views/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'intro.dart';
import 'home.dart';
import '../utils/audio_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioController _audio = AudioController();

  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    // 🎧 start BGM dari splash (AMAN buat first & second time)
    await Future.delayed(const Duration(milliseconds: 200));
    await _audio.playBGM(
      'audio/music/home_bgm.mp3',
      volume: 0.5,
    );

    // ⏳ delay loading
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final bool isProfileCompleted =
        prefs.getBool('isProfileCompleted') ?? false;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            isProfileCompleted ? const HomeScreen() : const IntroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B5ED7),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO / ILUSTRASI
            SvgPicture.asset(
              'assets/quiz.svg',
              height: 160,
            ),
            const SizedBox(height: 32),

            // DESKRIPSI
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'QUIZZIF offers Informatics quizzes designed to sharpen your understanding, making every session engaging.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // LOADING TEXT
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            // PROGRESS BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: LinearProgressIndicator(
                minHeight: 8,
                backgroundColor: Colors.white30,
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
