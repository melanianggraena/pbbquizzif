import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/question_model.dart';

Future<void> seedAllQuestions() async {
  final box = Hive.box<QuestionModel>('questionsBox');

  // 🔒 biar ga dobel insert
  if (box.isNotEmpty) return;

  // ✅ AMBIL DARI ASSETS
  final jsonString = await rootBundle.loadString('assets/data/questions.json');
  final List<dynamic> data = json.decode(jsonString);

  for (final item in data) {
    box.add(
      QuestionModel(
        question: item['question'],
        options: List<String>.from(item['options']),
        answerIndex: item['answerIndex'],
        category: item['category'],
        level: item['level'],
      ),
    );
  }
}
