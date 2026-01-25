import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'profile.dart';
import 'package:ppbquizzif/utils/audio_controller.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // pastikan BGM sudah jalan
    // AudioController().resumeLastBGM(volume: 0.5);
    // Loading singkat biar ada efek smooth
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // ================= START BUTTON LOGIC =================
  Future<void> _onStart() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isProfileCompleted =
        prefs.getBool('isProfileCompleted') ?? false;

    if (!mounted) return;

    if (!isProfileCompleted) {
      // 🔴 First time → Profile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(isFirstTime: true),
        ),
      );
    } else {
      // 🟢 Sudah pernah → Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ================= INTRO SCREEN =================
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ================= LOGO =================
              SvgPicture.asset(
                'assets/quizzif_logo.svg',
                height: 280,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 10),

              // ================= ILLUSTRATION =================
              SvgPicture.asset(
                'assets/intro1.svg',
                height: 400,
                fit: BoxFit.contain,
              ),

              const Spacer(),

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

              const SizedBox(height: 20),

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
