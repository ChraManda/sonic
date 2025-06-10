import 'package:flutter/foundation.dart';
import 'question_model.dart';

class ResponseModel {
  final Question question;
  final int selectedOptionIndex;
  final bool isCorrect;
  final int score;

  ResponseModel({
    required this.question,
    required this.selectedOptionIndex,
    required this.isCorrect,
    required this.score,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic questionData = json['question'];
    late Question parsedQuestion;

    if (questionData is String) {
      // It's just an ID from the backend
      debugPrint("ℹReceived question ID: $questionData");
      parsedQuestion = Question(id: questionData);  // Create with just ID
    } else if (questionData is Map<String, dynamic>) {
      // Full question object
      parsedQuestion = Question.fromJson(questionData);
    } else {
      debugPrint("Invalid question data type: ${questionData.runtimeType}");
      throw Exception("Invalid 'question' data format");
    }

    return ResponseModel(
      question: parsedQuestion,
      selectedOptionIndex: json['selectedOptionIndex'] ?? -1,
      isCorrect: json['isCorrect'] ?? false,
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question.id, // Use just the ID for submission
    'selectedOptionIndex': selectedOptionIndex,
    'isCorrect': isCorrect,
    'score': score,
  };
}
