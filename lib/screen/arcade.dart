import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'quiz.dart';

// ======================================================
// 🎮 ARCADE - CATEGORY
// ======================================================
class ArcadeCategoryScreen extends StatelessWidget {
  const ArcadeCategoryScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> categories = const [
    {'title': 'C++', 'color': Color(0xFFFACC15)},
    {'title': 'Database', 'color': Color(0xFF22C55E)},
    {'title': 'Java', 'color': Color(0xFFF97316)},
    {'title': 'Flutter', 'color': Color(0xFF3B82F6)},
    {'title': 'RPL', 'color': Color(0xFFEC4899)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B5ED7),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  BackButton(color: Colors.white),
                  Spacer(),
                  Text(
                    'Arcade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),

            // ===== MASKOT =====
            SvgPicture.asset(
              'assets/intro2.svg',
              height: 160,
            ),

            const SizedBox(height: 24),

            // ===== CARD =====
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0A4EC4).withOpacity(0.85), // semi transparan
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // 🔥 PENTING: ngikutin isi
                children: [
                  const Text(
                    'Choose your category\nExplore!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),

                  ...categories.map(
                    (cat) => _CategoryButton(
                      title: cat['title'],
                      color: cat['color'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArcadeLevelScreen(
                              category: cat['title'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// ======================================================
// 🎯 ARCADE - LEVEL
// ======================================================
class ArcadeLevelScreen extends StatelessWidget {
  final String category;
  const ArcadeLevelScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B5ED7),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  BackButton(color: Colors.white),
                  Spacer(),
                  Text(
                    'Arcade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),

            // ===== ILLUSTRATION =====
            SvgPicture.asset(
              'assets/intro2.svg',
              height: 300,
            ),

            const SizedBox(height: 24),

            // ===== CARD LEVEL (TINGGI SESUAI ISI) =====
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A4EC4),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 🔥 KUNCI UTAMA
                  children: [
                    const Text(
                      'Choose your Level',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _LevelButton(
                      title: 'Easy',
                      color: Colors.green,
                      onTap: () => _goLoading(context, 'Easy'),
                    ),
                    const SizedBox(height: 12),

                    _LevelButton(
                      title: 'Medium',
                      color: Colors.amber,
                      onTap: () => _goLoading(context, 'Medium'),
                    ),
                    const SizedBox(height: 12),

                    _LevelButton(
                      title: 'Hard',
                      color: Colors.red,
                      onTap: () => _goLoading(context, 'Hard'),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(), // biar posisi tetap enak
          ],
        ),
      ),
    );
  }

  void _goLoading(BuildContext context, String level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArcadeLoadingScreen(
          category: category,
          level: level,
        ),
      ),
    );
  }
}


// ======================================================
// ⏳ ARCADE - LOADING
// ======================================================
class ArcadeLoadingScreen extends StatefulWidget {
  final String category;
  final String level;

  const ArcadeLoadingScreen({
    Key? key,
    required this.category,
    required this.level,
  }) : super(key: key);

  @override
  State<ArcadeLoadingScreen> createState() => _ArcadeLoadingScreenState();
}

class _ArcadeLoadingScreenState extends State<ArcadeLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            mode: 'arcade',
            category: widget.category,
            level: widget.level,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B5ED7),
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

// ======================================================
// 🔘 BUTTONS
// ======================================================
class _CategoryButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _LevelButton({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
