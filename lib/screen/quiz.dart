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

  late List<QuestionModel> _questions;

  final List<Color> optionColors = [
    const Color(0xFF3B82F6),
    const Color(0xFFEF4444),
    const Color(0xFFF97316),
    const Color(0xFF22C55E),
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    final box = Hive.box<QuestionModel>('questionsBox');

    final filtered = box.values.where((q) {
      return q.category == widget.category && q.level == widget.level;
    }).toList();

    filtered.shuffle();

    _questions = filtered.length > 20 ? filtered.take(20).toList() : filtered;

    if (_questions.isNotEmpty) {
      _startTimer();
    }
  }

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

                    Text(
                      q.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 32),

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

// ================= RESULT SCREEN =================

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
    final int xp = score * 10;
    final int coins = score * 75;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score: $score / $totalQuestions',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('XP: $xp'),
              Text('Coins: $coins'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                  (_) => false,
                ),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
