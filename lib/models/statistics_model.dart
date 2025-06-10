import 'note_accuracy_model.dart';
import 'category_accuracy_model.dart';

class StatisticsModel {
  final double averageAccuracy;
  final List<double> recentAccuracy;
  final int totalQuizzes;
  final int totalCorrectAnswers;
  final int totalIncorrectAnswers;
  final List<NoteAccuracy> strongAreas;
  final List<NoteAccuracy> weakAreas;
  final List<CategoryAccuracy> categoryAccuracy;

  StatisticsModel({
    required this.averageAccuracy,
    required this.recentAccuracy,
    required this.totalQuizzes,
    required this.totalCorrectAnswers,
    required this.totalIncorrectAnswers,
    required this.strongAreas,
    required this.weakAreas,
    required this.categoryAccuracy,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    List<NoteAccuracy> parseNoteAccuracies(dynamic jsonList) {
      if (jsonList is List) {
        return jsonList
            .map((e) => NoteAccuracy.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    List<CategoryAccuracy> parseCategoryAccuracies(dynamic jsonList) {
      if (jsonList is List) {
        return jsonList
            .map((e) => CategoryAccuracy.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    return StatisticsModel(
      averageAccuracy: (json['averageAccuracy'] ?? 0).toDouble(),
      recentAccuracy: (json['recentAccuracy'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [],
      totalQuizzes: json['totalQuizzes'] ?? 0,
      totalCorrectAnswers: json['totalCorrectAnswers'] ?? 0,
      totalIncorrectAnswers: json['totalIncorrectAnswers'] ?? 0,
      strongAreas: parseNoteAccuracies(json['strongAreas']),
      weakAreas: parseNoteAccuracies(json['weakAreas']),
      categoryAccuracy: parseCategoryAccuracies(json['categoryAccuracy']),
    );
  }
}
