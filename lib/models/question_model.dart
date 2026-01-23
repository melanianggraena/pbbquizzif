import 'package:hive/hive.dart';

part 'question_model.g.dart';

@HiveType(typeId: 0)
class QuestionModel extends HiveObject {
  @HiveField(0)
  String question;

  @HiveField(1)
  List<String> options;

  @HiveField(2)
  int answerIndex;

  @HiveField(3)
  String category;

  @HiveField(4)
  String level;

  QuestionModel({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.category,
    required this.level,
  });
}
