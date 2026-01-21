import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';

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
    if (widget.mode == 'arcade') _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _nextQuestion();
        }
      });
    });
  }

  void _answerQuestion(int index) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;

      if (index == _questions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), _nextQuestion);
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _answered = false;
        _timeLeft = 30;
      });
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
                      Text(
                        '$_timeLeft',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 24),

              // ===== ROBOT =====
              const Icon(Icons.smart_toy,
                  size: 64, color: Color(0xFF2563EB)),

              const SizedBox(height: 24),

              // ===== QUESTION =====
              Text(
                q['question'],
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 32),

              // ===== OPTIONS =====
              ...List.generate(q['options'].length, (i) {
                Color bg = const Color(0xFF2563EB);

                if (_answered) {
                  if (i == correct) bg = const Color(0xFF22C55E);
                  else if (i == _selectedAnswer) {
                    bg = const Color(0xFFEF4444);
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
                      q['options'][i],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= RESULT =================
class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String mode;

  const ResultScreen(
      {super.key,
      required this.score,
      required this.totalQuestions,
      required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events,
                size: 120, color: Color(0xFFF59E0B)),
            const SizedBox(height: 24),
            const Text('Result',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (_) => false,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                child: Text('Home',
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
