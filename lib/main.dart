import 'package:flutter/material.dart';
import 'screen/intro.dart';
import 'screen/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/question_model.dart';
import 'package:hive/hive.dart';
import 'data/seed_question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(QuestionModelAdapter());
  await Hive.openBox<QuestionModel>('questionsBox');
  await seedAllQuestions();

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
      home: const SplashScreen(),
    );
  }
}
