
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
    List<Question> parseQuestions(dynamic questionsJson) {
      if (questionsJson is List) {
        return questionsJson.map<Question>((e) {
          if (e is String) {
            // Just an ID string, create Question with id only
            return Question(id: e);
          } else if (e is Map<String, dynamic>) {
            // Full question object
            return Question.fromJson(e);
          } else {
            throw Exception('Invalid question data: $e');
          }
        }).toList();
      }
      return [];
    }

    return QuizSession(
      quizId: json['quizId'],
      questions: parseQuestions(json['questions']),
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

}
