import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'signin.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLoadingScreen = true;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLoadingScreen = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- 1. LAYAR HITAM (LOADING) ---
    if (_showLoadingScreen) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(),
      );
    }

    // --- 2. LAYAR INTRO (BIRU) ---
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStartScreen(),    // START
                  _buildSliderScreen1(),  // GUEST / SIGN IN
                  _buildSliderScreen2(),  // GET STARTED
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SCREEN 1: START (Gambar intro1.svg)
  // ==========================================
  Widget _buildStartScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text(
            'QUIZZIF',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
              fontFamily: 'Arial',
            ),
          ),
          const Spacer(),
          
          // UPDATE: Nama file tanpa spasi
          SvgPicture.asset(
            'assets/intro1.svg', 
            height: 320, 
            fit: BoxFit.contain,
          ),
          
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1976D2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'START',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }

  // ==========================================
  // SCREEN 2: GUEST (Gambar intro2.svg)
  // ==========================================
  Widget _buildSliderScreen1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // UPDATE: Nama file tanpa spasi
          Expanded(
            flex: 6,
            child: SvgPicture.asset(
              'assets/intro2.svg',
              fit: BoxFit.contain,
            ),
          ),
          
          const Text(
            "Enjoy interactive Informatics\nquizzes.\nLearn and have fun anytime,\nanywhere!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, color: Colors.white, height: 1.4, fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildDotsIndicator(0),
          const SizedBox(height: 32),
          _buildDarkButton(
            text: "CONTINUE AS GUEST",
            onPressed: _nextPage,
          ),
          const SizedBox(height: 16),
          _buildWhiteButton(
            text: "SIGN IN OR SIGN UP",
            onPressed: _navigateToLogin,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================
  // SCREEN 3: GET STARTED (Gambar intro2.svg)
  // ==========================================
  Widget _buildSliderScreen2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // UPDATE: Nama file tanpa spasi
          Expanded(
            flex: 6,
            child: SvgPicture.asset(
              'assets/intro2.svg',
              fit: BoxFit.contain,
            ),
          ),
          
          const Text(
            "Our Informatics quizzes are\ndesigned to support effective\nlearning.\nDiscover something new every\nday through engaging challenges.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, color: Colors.white, height: 1.4, fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildDotsIndicator(1),
          const SizedBox(height: 32),
          _buildDarkButton(
            text: "GET STARTED",
            onPressed: _navigateToLogin,
          ),
          const SizedBox(height: 16),
          _buildWhiteButton(
            text: "I ALREADY HAVE AN ACCOUNT",
            onPressed: _navigateToLogin,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildDotsIndicator(int activeIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildDarkButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142B4E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildWhiteButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1976D2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}