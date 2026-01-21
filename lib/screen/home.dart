import 'package:flutter/material.dart';
import 'quiz.dart';
import 'arcade.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      // LEFT PROFILE
      Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/avatar.png'), // ganti sesuai aset
          ),
          const SizedBox(width: 10),
          const Text(
            'John Brown',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),

      // RIGHT INFO
      Row(
        children: [
          // COIN
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // BADGE
          const Icon(Icons.emoji_events, color: Colors.amber, size: 22),

          const SizedBox(width: 10),
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
                width: 450  ,   
                height: 450,
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
        style: TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),

      const SizedBox(height: 20),

      // ===== PLAY NOW (SMALL, INSIDE CARD) =====
      SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ModeSelectionScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ADE80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
          ),
          child: const Text(
            'Play Now',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({Key? key}) : super(key: key);

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
              // BACK BUTTON
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ROBOT ICON
              // ROBOT ICON (SVG)
              SvgPicture.asset(
                'assets/home2.svg',
                width: 400,
                height: 400,
              ),

              const SizedBox(height: 20),


              // CARD
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // CLASSIC
                    _modeButton(
                      text: 'Classic',
                      color: const Color(0xFFFFC107),
                      icon: Icons.quiz,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuizScreen(mode: 'classic'),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ARCADE
                    _modeButton(
                      text: 'Arcade',
                      color: const Color(0xFF4ADE80),
                      icon: Icons.sports_esports,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ArcadeCategoryScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E6BFF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  
  Widget _modeButton({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 210,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}


