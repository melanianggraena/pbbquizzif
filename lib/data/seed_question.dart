import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/question_model.dart';

Future<void> seedQuestions() async {
  final box = Hive.box<QuestionModel>('questionsBox');
  if (box.isNotEmpty) return;

  final jsonString = await rootBundle.loadString('lib/data/questions.json');
  final List data = json.decode(jsonString);

  final questions = data
      .map(
        (e) => QuestionModel(
          question: e['question'],
          options: List<String>.from(e['options']),
          answerIndex: e['answerIndex'],
          category: e['category'],
          level: e['level'],
        ),
      )
      .toList();

  await box.addAll(questions);
}
