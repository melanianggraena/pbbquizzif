import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'intro.dart';
import 'home.dart';
import 'package:ppbquizzif/utils/audio_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // =================== INITSTATE ===================
  @override
  void initState() {
    super.initState();

    // ================= PLAY BGM OTOMATIS =================
    AudioController().playBGM('audio/music/background.mp3', volume: 0.5);

    // ================= ANIMASI LOGO =================
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    // ================= TIMER KE NEXT SCREEN =================
    Timer(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final bool isProfileCompleted = prefs.getBool('isProfileCompleted') ?? false;

      if (!mounted) return;

      if (!isProfileCompleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const IntroScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SvgPicture.asset(
            'assets/sukses.svg',
            width: 200,
            height: 200,
            placeholderBuilder: (context) => const CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
