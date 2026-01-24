import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLoadingScreen = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showLoadingScreen = false;
        });
      }
    });
  }

void _goToHome() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  );
}

  @override
  Widget build(BuildContext context) {
    // ================= LOADING SCREEN =================
    if (_showLoadingScreen) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(),
      );
    }

    // ================= INTRO SCREEN =================
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 🔥 LOGO SVG GANTI TEXT
              SvgPicture.asset(
                'assets/quizzif_logo.svg',
                height: 280, // tinggal gede-kecilin di sini
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 0), // atur jarak manual

              SvgPicture.asset(
                'assets/intro1.svg',
                height: 400,
                fit: BoxFit.contain,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _goToHome,
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
