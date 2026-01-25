import 'package:flutter/material.dart';
import 'screen/intro.dart';
import 'screen/home.dart';
import 'screen/profile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/question_model.dart';
import 'package:hive/hive.dart';
import 'data/seed_question.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/audio_controller.dart';

// =====================================================
// 🔥 ROUTE OBSERVER (WAJIB GLOBAL, JANGAN DI DALAM CLASS)
// =====================================================
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  // Pastikan Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // preload dan play BGM sebelum SplashScreen muncul
  await AudioController().playBGM('audio/music/home_bgm.mp3', volume: 0.5);

  // ================= Hive =================
  await Hive.initFlutter();
  Hive.registerAdapter(QuestionModelAdapter());
  await Hive.openBox<QuestionModel>('questionsBox');

  // Seed data pertanyaan
  await seedAllQuestions();

  // ================= Run App =================
  runApp(const MyApp());
}

// ================= SPLASH SCREEN =================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  // ================= CEK FIRST TIME / REDIRECT =================
  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = !(prefs.getBool('isProfileCompleted') ?? false);

    if (!mounted) return;

    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / animasi splash
            Image.asset('assets/sukses.svg', width: 180, height: 180),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

// ================= MY APP =================
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QUIZZIF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),

      // 🔥 PENTING: DAFTARKAN ROUTE OBSERVER
      navigatorObservers: [routeObserver],

      home: const SplashScreen(),
    );
  }
}
