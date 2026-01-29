import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'quiz.dart';
import '../utils/audio_controller.dart';

// ======================================================
// ⏳ CLASSIC - LOADING SCREEN
// ======================================================
class ClassicLoadingScreen extends StatefulWidget {
  const ClassicLoadingScreen({Key? key}) : super(key: key);

  @override
  State<ClassicLoadingScreen> createState() => _ClassicLoadingScreenState();
}

class _ClassicLoadingScreenState extends State<ClassicLoadingScreen> {
  @override
  void initState() {
    super.initState();
    
    // ✅ Play quiz BGM saat loading
    _initAudioAndNavigate();
  }

  Future<void> _initAudioAndNavigate() async {
    // Stop home BGM, ganti ke quiz BGM
    await AudioController().stopBGM();
    await AudioController().playBGM(
      'audio/music/quiz_bgm.mp3',
      volume: 0.5,
    );

    // Timer 3 detik ke Quiz Screen
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const QuizScreen(mode: 'classic'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3C91),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/quiz.svg',
              height: 160,
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'QUIZZIF offers Informatics quizzes designed to sharpen your understanding, making every session engaging.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),
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