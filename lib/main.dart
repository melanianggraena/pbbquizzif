import 'package:flutter/material.dart';
import 'screen/intro.dart';
import 'screen/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/question_model.dart';
import 'package:hive/hive.dart';
import 'data/seed_question.dart';

// =====================================================
// 🔥 ROUTE OBSERVER (WAJIB GLOBAL, JANGAN DI DALAM CLASS)
// =====================================================
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  // Pastikan Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // ================= Hive =================
  await Hive.initFlutter();
  Hive.registerAdapter(QuestionModelAdapter());
  await Hive.openBox<QuestionModel>('questionsBox');

  // Seed data pertanyaan
  await seedAllQuestions();

  // ================= Run App =================
  runApp(const MyApp());
}

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
