import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/quiz_session_model.dart';
import '../models/question_model.dart';
import '../models/response_model.dart';
import 'package:sonic/constants/address_constants.dart';
import 'package:sonic/providers/answer_provider.dart';

class QuizSessionProvider with ChangeNotifier {
  String? _token;
  QuizSession? _currentSession;
  List<Question> _questions = [];
  List<ResponseModel> _responses = [];

  QuizSession? get currentSession => _currentSession;
  List<Question> get questions => _questions;
  List<ResponseModel> get responses => _responses;

  void update(String? token) {
    if (token == null) return;
    _token = token;
    debugPrint("Token updated: $_token");
    notifyListeners();
  }

  Future<void> startSession(String category, int totalQuestions) async {
    try {
      final url = '$host/api/v1/quizsession/start';
      debugPrint("Starting quiz session at $url");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'category': category,
          'totalQuestions': totalQuestions,
        }),
      );


      debugPrint("Server responded with status: ${response.statusCode}");
      debugPrint("Raw response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        debugPrint('Parsed session data: ${jsonEncode(data)}');

        if (data['quizSession'] != null) {
          _currentSession = QuizSession.fromJson(data['quizSession']);
          _questions = (data['quizSession']['questions'] as List)
              .map((q) => Question.fromJson(q))
              .toList();
          _responses.clear();
          debugPrint("Session started: Quiz ID: ${_currentSession!.quizId}, Questions loaded: ${_questions.length}");
          notifyListeners();
        } else {
          throw Exception("No quiz session data in response.");
        }
      } else {
        throw Exception("Failed to start quiz session. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Start session error: $e");
      rethrow;
    }
  }

  // =================================
  // == Personalized Quiz ============
  Future<void> startPersonalizedSession(String category, int totalQuestions) async {
    try {
      final url = '$host/api/v1/quizsession/personalized';
      debugPrint("Starting quiz session at $url");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'category': category,
          'totalQuestions': totalQuestions,
        }),
      );


      debugPrint("Server responded with status: ${response.statusCode}");
      debugPrint("Raw response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        debugPrint('Parsed session data: ${jsonEncode(data)}');

        if (data['quizSession'] != null) {
          _currentSession = QuizSession.fromJson(data['quizSession']);
          _questions = (data['quizSession']['questions'] as List)
              .map((q) => Question.fromJson(q))
              .toList();
          _responses.clear();
          debugPrint("Session started: Quiz ID: ${_currentSession!.quizId}, Questions loaded: ${_questions.length}");
          notifyListeners();
        } else {
          throw Exception("No quiz session data in response.");
        }
      } else {
        throw Exception("Failed to start quiz session. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Start session error: $e");
      rethrow;
    }
  }
  
  //--------------------------------------------------------
  void answerQuestion({
    required Question question,
    required int selectedIndex,
    required int score,
  }) {
    final isCorrect = question.correctOptionIndex == selectedIndex;

    _responses.add(ResponseModel(
      question: question,
      selectedOptionIndex: selectedIndex,
      isCorrect: isCorrect,
      score: score,
    ));

    if (_currentSession != null) {
      _currentSession!.score = (_currentSession!.score ?? 0) + (isCorrect ? 10 : 0);
      debugPrint("Answered question: ${question.questionText}");
      debugPrint("Selected Index: $selectedIndex | Correct Index: ${question.correctOptionIndex}");
      debugPrint("Is Correct: $isCorrect | Updated Score: ${_currentSession!.score}");
    }

    notifyListeners();
  }

  Future<Map<String, dynamic>?> submitSession() async {
    if (_currentSession == null) return null;

    try {
      final url = '$host/api/v1/quizsession/submit';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'quizId': _currentSession!.quizId,
          'responses': _responses.map((r) => r.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        debugPrint("Submit response: ${jsonEncode(decoded)}");

        final updatedSessionData = decoded['updatedSession'];
        if (updatedSessionData is Map<String, dynamic>) {
          _currentSession = QuizSession.fromJson(updatedSessionData);
        }

        // Return user stats to be used in UI
        final userStats = decoded['userStats'];
        if (userStats != null) {
          return userStats; // Pass user stats back to the UI layer
        }

        debugPrint("Session submitted successfully. Final Score: ${_currentSession!.score}");
        notifyListeners();
        return null; // Return null if no userStats in response
      } else {
        throw Exception("Failed to submit quiz session. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Submit session error: $e");
      rethrow;
    }
  }


  void resetSession() {
    debugPrint("Resetting session...");
    _currentSession = null;
    _questions = [];
    _responses = [];
    notifyListeners();
  }

  void updateScore(int score) {
    if (_currentSession != null) {
      _currentSession!.score = score;
      debugPrint("Score manually updated to: $score");
      notifyListeners();
    }
  }
}
