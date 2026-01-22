import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuizScreen extends StatefulWidget {
  final String mode;
  final String? category;
  final String? level;

  const QuizScreen({super.key, required this.mode, this.category, this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;

  int? _selectedAnswer;
  bool _answered = false;
  bool _showBanner = false;
  bool _isCorrect = false;

  final List<Color> optionColors = [
    Color(0xFF3B82F6), // blue
    Color(0xFFEF4444), // red
    Color(0xFFF97316), // orange
    Color(0xFF22C55E), // green
  ];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which spell is used to disarm an opponent in Harry Potter?',
      'options': [
        'Expelliarmus',
        'Stupefy',
        'Petrificus Totalus',
        'Confringo'
      ],
      'correctAnswer': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (_answered) return;
    setState(() {
      _answered = true;
      _showBanner = true;
      _isCorrect = false;
    });

    Future.delayed(const Duration(seconds: 1), _nextQuestion);
  }

  void _answerQuestion(int index) {
    if (_answered) return;

    final correct = _questions[_currentQuestionIndex]['correctAnswer'];

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      _showBanner = true;
      _isCorrect = index == correct;
      if (_isCorrect) _score++;
    });

    Future.delayed(const Duration(seconds: 1), _nextQuestion);
  }

  void _nextQuestion() {
    _timer?.cancel();

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _answered = false;
        _showBanner = false;
        _timeLeft = 30;
      });
      _startTimer();
    } else {
      _showResult();
    }
  }

  void _showResult() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: _score,
          totalQuestions: _questions.length,
          mode: widget.mode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestionIndex];
    final correct = q['correctAnswer'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== STATUS BANNER =====
            if (_showBanner)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: _isCorrect
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFEF4444),
                child: Column(
                  children: [
                    Text(
                      _isCorrect ? 'Correct!' : 'Incorrect!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _isCorrect ? '+945' : 'That was close',
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // ===== TOP BAR =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_currentQuestionIndex + 1}/${_questions.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 42,
                              height: 42,
                              child: CircularProgressIndicator(
                                value: _timeLeft / 30,
                                strokeWidth: 4,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                            Text('$_timeLeft'),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),

                    const SizedBox(height: 24),
                    // ===== SVG ICON (GANTI ROBOT) =====
                    SvgPicture.asset(
                      'assets/intro2.svg',
                      height: 90,
                    ),
                    
                    const SizedBox(height: 24),

                    Text(
                      q['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700),
                    ),

                    const SizedBox(height: 32),

                    // ===== OPTIONS =====
                    ...List.generate(q['options'].length, (i) {
                      Color bg = optionColors[i];

                      if (_answered) {
                        if (i == correct) {
                          bg = const Color(0xFF22C55E);
                        } else if (i == _selectedAnswer) {
                          bg = const Color(0xFFEF4444);
                        } else {
                          bg = const Color(0xFFEF4444);
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: ElevatedButton(
                          onPressed: () => _answerQuestion(i),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bg,
                            minimumSize:
                                const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            q['options'][i],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== RESULT SCREEN ====================
// ====================
// 🎉 RESULT SCREEN
// ====================
class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String mode;
  final String? category;
  final String? level;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.mode,
    this.category,
    this.level,
  });

  @override
  Widget build(BuildContext context) {
    // =======================
    // 📊 HITUNG HASIL (LOGIC)
    // =======================
    final int correctQuestions = score;
    final int xp = score * 10;
    final int coins = score * 75;
    final int avgTime = 12; // dummy dulu
    final int iq = 120; // dummy UI
    final int rank = 269; // dummy UI

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              // =======================
              // ❌ CLOSE + TITLE
              // =======================
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF2563EB)),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                      (_) => false,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Result',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 20),

              // =======================
              // 🏆 PIALA SVG BESAR
              // =======================
              SizedBox(
                height: 260,
                child: SvgPicture.asset(
                  'assets/piala.svg',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              // =======================
              // 🏅 TITLE ACHIEVEMENT
              // =======================
              const Text(
                'Your Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 24),

              // =======================
              // 📦 GRID ACHIEVEMENTS
              // =======================
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.6,
                  children: [
                    _achievementCardSvg(
                      svgPath: 'assets/iq.svg',
                      value: iq.toString(),
                      label: 'IQ',
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/point.svg',
                      value: coins.toString(),
                      label: 'Coins Earned',
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/xp.svg',
                      value: xp.toString(),
                      label: 'XP',
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/centang.svg',
                      value: correctQuestions.toString(),
                      label: 'Correct Questions',
                      iconColor: Colors.green,
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/bumi.svg',
                      value: rank.toString(),
                      label: 'Rank',
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/jam.svg',
                      value: avgTime.toString(),
                      label: 'Avg Time',
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =======================
              // 🔘 BUTTONS
              // =======================
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.home, color: Colors.white),
                      label: const Text('Home',),
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainScreen(),
                        ),
                        (_) => false,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text('Share'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // 📦 ACHIEVEMENT CARD (SVG | ICON SEJAJAR ANGKA)
  // =====================================================
  Widget _achievementCardSvg({
    required String svgPath,
    required String value,
    required String label,
    Color iconColor = Colors.blue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // =======================
          // 🔢 ICON + ANGKA (ROW)
          // =======================
          Row(
            children: [
              SvgPicture.asset(
                svgPath,
                width: 40,
                height: 40,
                colorFilter:
                    ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // =======================
          // 🏷 LABEL
          // =======================
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
