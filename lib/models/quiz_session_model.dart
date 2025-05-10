
import '../providers/user.dart';
import 'question_model.dart';
import 'response_model.dart';

class QuizSession {
  final String quizId;
  final List<Question> questions;
  final String category;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  int score;
  final int difficultyLevel;
  final List<ResponseModel> responses;

  QuizSession({
    required this.quizId,
    required this.questions,
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.score,
    required this.difficultyLevel,
    required this.responses,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      quizId: json['quizId'],
      questions: (json['questions'] as List)
          .map((e) => Question.fromJson(e))
          .toList(),
      category: json['category'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
      score: json['score'],
      difficultyLevel: json['difficultyLevel'] ?? 1,
      responses: (json['responses'] is List)
          ? (json['responses'] as List)
          .map((e) => ResponseModel.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'quizId': quizId,
    'questions': questions.map((e) => e.toJson()).toList(),
    'category': category,
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'incorrectAnswers': incorrectAnswers,
    'score': score,
    'difficultyLevel': difficultyLevel,
    'responses': responses.map((e) => e.toJson()).toList(),
  };
}
