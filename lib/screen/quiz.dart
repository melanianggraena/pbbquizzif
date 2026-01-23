import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../main.dart';
import '../models/question_model.dart';

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

  List<QuestionModel> _questions = []; // 🔑 WAJIB INIT KOSONG

  final List<Color> optionColors = [
    Color(0xFF3B82F6),
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFF22C55E),
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // ================= LOAD SOAL DARI HIVE =================
  void _loadQuestions() {
    final box = Hive.box<QuestionModel>('questionsBox');

    final filtered = box.values
        .where((q) => q.category == widget.category && q.level == widget.level)
        .toList();

    filtered.shuffle();

    // 🔒 maksimal 20 soal
    _questions = filtered.length > 20 ? filtered.take(20).toList() : filtered;

    if (_questions.isNotEmpty) {
      _startTimer();
    }
  }

  // ================= TIMER =================
  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;

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

  // ================= JAWAB =================
  void _answerQuestion(int index) {
    if (_answered) return;

    final correct = _questions[_currentQuestionIndex].answerIndex;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      _showBanner = true;
      _isCorrect = index == correct;
      if (_isCorrect) _score++;
    });

    Future.delayed(const Duration(seconds: 1), _nextQuestion);
  }

  // ================= NEXT =================
  void _nextQuestion() {
    _timer?.cancel();

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _answered = false;
        _showBanner = false;
      });
      _startTimer();
    } else {
      _showResult();
    }
  }

  // ================= RESULT =================
  void _showResult() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: _score,
          totalQuestions: _questions.length,
          mode: widget.mode,
          category: widget.category,
          level: widget.level,
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Soal belum tersedia', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final q = _questions[_currentQuestionIndex];
    final correct = q.answerIndex;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== BANNER =====
            if (_showBanner)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: _isCorrect
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFEF4444),
                child: Text(
                  _isCorrect ? 'Correct!' : 'Incorrect!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    SvgPicture.asset('assets/intro2.svg', height: 90),
                    const SizedBox(height: 24),

                    // ===== QUESTION =====
                    Text(
                      q.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ===== OPTIONS =====
                    ...List.generate(q.options.length, (i) {
                      Color bg = optionColors[i];

                      if (_answered) {
                        if (i == correct) {
                          bg = const Color(0xFF22C55E);
                        } else if (i == _selectedAnswer) {
                          bg = const Color(0xFFEF4444);
                        } else {
                          bg = Colors.grey;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: ElevatedButton(
                          onPressed: () => _answerQuestion(i),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bg,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            q.options[i],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
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
class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String mode;
  final String? category;
  final String? level;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.mode,
    this.category,
    this.level,
  }) : super(key: key);

  // =======================
  // 📦 ACHIEVEMENT CARD (SVG)
  // =======================
  Widget _achievementCardSvg({
    required String svgPath,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== SVG ICON =====
          SvgPicture.asset(svgPath, width: 26, height: 26),

          const Spacer(),

          // ===== VALUE =====
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // ===== LABEL =====
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // =======================
    // 📊 HITUNG HASIL
    // =======================
    final correctQuestions = score;
    final xp = score * 10;
    final coins = score * 75;
    final avgTime = 72; // dummy dulu
    final iq = 3234; // placeholder UI
    final rank = 269; // placeholder UI

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // =======================
              // ❌ CLOSE BUTTON + TITLE
              // =======================
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.blue),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                      (_) => false,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Result',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
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
                height: 350,
                child: SvgPicture.asset(
                  'assets/piala.svg',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              // =======================
              // 🏅 YOUR ACHIEVEMENTS
              // =======================
              const Text(
                'Your Achievements',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 24),

              // =======================
              // 📦 GRID ACHIEVEMENT (SVG ICONS)
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
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/bumi.svg',
                      value: rank.toString(),
                      label: 'Rank',
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/jam.svg',
                      value: avgTime.toString(),
                      label: 'Avg time',
                    ),
                  ],
                ),
              ),

              // =======================
              // 🔘 BUTTONS
              // =======================
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.home, color: Colors.white),
                      label: const Text('Home'),
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
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

  // =======================
  // 📦 CARD WIDGET
  // =======================
  Widget _achievementCard({
    required IconData icon,
    required String value,
    required String label,
    Color iconColor = Colors.orange,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
