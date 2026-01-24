import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home.dart';
import '../models/question_model.dart';
import '../utils/audio_controller.dart';


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


  List<QuestionModel> _questions = [];

  // =======================
  // ⏱ TIME TRACKING
  // =======================
  DateTime? _questionStartTime;
  final List<int> _timePerQuestion = [];

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
      // ✅ START QUIZ BGM SAAT QUIZ BENAR-BENAR DIMULAI
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AudioController().stopBGM();
      await AudioController().playBGM(
    'audio/music/quiz_bgm.mp3',
    volume: 0.5,
  );
      });
  }

  @override
  void dispose() {
    _timer?.cancel();

    // 🔴 STOP quiz BGM saat keluar
    AudioController().stopBGM();
    super.dispose();
  }

  // ================= LOAD SOAL =================
  void _loadQuestions() {
    final box = Hive.box<QuestionModel>('questionsBox');

    // ================= Classic Campuran =================
    if (widget.mode == 'classic') {
      // Ambil semua kategori yang ada
      final categories = box.values.map((q) => q.category).toSet();

      List<QuestionModel> selectedQuestions = [];

      for (final cat in categories) {
        // Filter: kategori sesuai, level Easy
        final easyQuestions = box.values
            .where((q) => q.category == cat && q.level == 'Easy')
            .toList();
        
        easyQuestions.shuffle(); // acak soal

        // Ambil max 4 soal dari tiap kategori
        selectedQuestions.addAll(
          easyQuestions.take(1)
        );
      }

      selectedQuestions.shuffle(); // acak total soal
      _questions = selectedQuestions;
    } else {
      // ================= Arcade / mode biasa =================
      final filtered = box.values
          .where((q) => q.category == widget.category && q.level == widget.level)
          .toList();

      filtered.shuffle();
      _questions = filtered.length > 20 ? filtered.take(20).toList() : filtered;
    }

    if (_questions.isNotEmpty) _startTimer();
  }

  // ================= TIMER =================
  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _questionStartTime = DateTime.now(); // ⏱ mulai hitung waktu soal

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

    _saveQuestionTime();

    setState(() {
      _answered = true;
      _showBanner = true;
      _isCorrect = false;
    });

    Future.delayed(const Duration(seconds: 1), _nextQuestion);
  }

  // ================= SIMPAN WAKTU =================
  void _saveQuestionTime() {
    if (_questionStartTime == null) return;
    final end = DateTime.now();
    final duration = end.difference(_questionStartTime!).inSeconds;
    _timePerQuestion.add(duration);
  }

  // ================= JAWAB =================
  void _answerQuestion(int index) {
    if (_answered) return;

    final correct = _questions[_currentQuestionIndex].answerIndex;

    _saveQuestionTime();

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      _showBanner = true;
      _isCorrect = index == correct;
      if (_isCorrect) _score++;

      // sfx
      AudioController().playSFX(
      _isCorrect
        ? 'audio/sfx/correct.mp3'
        : 'audio/sfx/incorrect.mp3',
);

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

  // ================= RESULT ==========================
  void _showResult() {
    // fx
    AudioController().playSFX('audio/sfx/result.mp3');

    final totalTime = _timePerQuestion.fold(0, (a, b) => a + b);
    final avgTime = _timePerQuestion.isNotEmpty
        ? (totalTime / _timePerQuestion.length).round()
        : 0;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: _score,
          totalQuestions: _questions.length,
          mode: widget.mode,
          category: widget.category,
          level: widget.level,
          avgTime: avgTime, // 🔥 REAL DATA
        ),
      ),
    );
  }

  // ================= KONFIRMASI KELUAR =================
  void _showExitConfirmation() {
    // Pause timer sementara
    _timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Text('Keluar Quiz?'),
          ],
        ),
        content: Text(
          'Progress kamu akan hilang. Yakin ingin keluar?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // Resume timer
              if (!_answered) {
                _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  if (_timeLeft > 0) {
                    setState(() => _timeLeft--);
                  } else {
                    _handleTimeout();
                  }
                });
              }
            },
            child: Text(
              'Batal',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pop(context); // Keluar dari quiz
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Keluar',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Soal belum tersedia')),
      );
    }

    final q = _questions[_currentQuestionIndex];
    final correct = q.answerIndex;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_showBanner)
              Container(
                width: double.infinity, // 🔥 INI KUNCINYA
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
                      fontWeight: FontWeight.bold),
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
                        Text('${_currentQuestionIndex + 1}/${_questions.length}'),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 42,
                              height: 42,
                              child: CircularProgressIndicator(
                                value: _timeLeft / 30,
                                strokeWidth: 4,
                              ),
                            ),
                            Text('$_timeLeft'),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _showExitConfirmation, // 🔥 KONFIRMASI KELUAR
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
                          fontSize: 22, fontWeight: FontWeight.w700),
                    ),

                    const SizedBox(height: 32),

                    ...List.generate(q.options.length, (i) {
                      Color bg = optionColors[i];

                      if (_answered) {
                        if (_isCorrect) {
                          // Kalau jawabannya benar, yang benar hijau, yang lain abu-abu
                          if (i == correct) {
                            bg = const Color(0xFF22C55E); // hijau
                          } else {
                             bg = const Color(0xFFEF4444); // yang lain
                          }
                        } else {
                          // Kalau jawabannya salah, semua jadi merah kecuali yang benar tetap hijau
                          if (i == correct) {
                            bg = const Color(
                              0xFF22C55E,
                            ); // jawaban benar tetap hijau
                          } else {
                            bg = const Color(
                              0xFFEF4444,
                            ); // semua salah jadi merah
                          }
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: ElevatedButton(
                          onPressed: () => _answerQuestion(i),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bg,
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Text(
                            q.options[i],
                            style: const TextStyle(color: Colors.white),
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
  final int avgTime; // 🔥 REAL AVG TIME (DETIK)

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.mode,
    this.category,
    this.level,
    required this.avgTime,
  }) : super(key: key);

  // =======================
  // 📦 ACHIEVEMENT CARD (SVG)
  // =======================
  Widget _achievementCardSvg({
    required String svgPath,
    required String value,
    required String label,
    double iconSize = 40,
    double valueSize = 32,
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
          // ICON + ANGKA
          Row(
            children: [
              SvgPicture.asset(
                svgPath,
                width: iconSize,
                height: iconSize,
              ),
              const SizedBox(width: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // LABEL
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =======================
  // ⏱ FORMAT DETIK → mm:ss
  // =======================
  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // =======================
    // 📊 HITUNG HASIL
    // =======================
    final correctQuestions = score;
    final xp = score * 10;
    final coins = score * 75;

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
                    icon: const Icon(Icons.close, color: Colors.blue),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
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
              // 🏆 PIALA
              // =======================
              SizedBox(
                height: 300,
                child: SvgPicture.asset(
                  'assets/piala.svg',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              // =======================
              // 🏅 TITLE
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
              // 📦 GRID ACHIEVEMENT
              // =======================
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,
                  children: [
                    _achievementCardSvg(
                      svgPath: 'assets/point.svg',
                      value: coins.toString(),
                      label: 'Coins',
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/xp.svg',
                      value: xp.toString(),
                      label: 'XP',
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/centang.svg',
                      value: correctQuestions.toString(),
                      label: 'Correct',
                    ),
                    _achievementCardSvg(
                      svgPath: 'assets/jam.svg',
                      value: _formatTime(avgTime), // 🔥 REAL AVG TIME
                      label: 'Avg Time',
                    ),
                  ],
                ),
              ),

              // =======================
              // 🔘 BUTTON HOME
              // =======================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: const Text(
                    'Back To Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
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
            ],
          ),
        ),
      ),
    );
  }
}