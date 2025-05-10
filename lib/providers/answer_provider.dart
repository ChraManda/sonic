import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/quiz_session_model.dart';
import '../models/response_model.dart';
import 'package:sonic/constants/address_constants.dart';

class AnswerProvider with ChangeNotifier {
  String? _token;
  QuizSession? _currentSession;
  bool _isLoading = false;
  String? _errorMessage;

  void update(String? token) {
    if (token == null) return;
    _token = token;
    notifyListeners(); // Optional but good if UI depends on this
  }

  // Getter for current session if needed
  QuizSession? get currentSession => _currentSession;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for error message
  String? get errorMessage => _errorMessage;

  // Setter for error message
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> submitAnswerToBackend({
    required String quizId,
    required String questionId,
    required ResponseModel responseModel,
  }) async {
    _setErrorMessage(null); // Clear previous errors before starting
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$host/api/v1/quizsession/answer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'quizId': quizId,
          'questionId': questionId,
          'selectedOptionIndex': responseModel.selectedOptionIndex,
        }),
      );
      debugPrint("Raw respooooonse body: ${response.body}");
      if (response.statusCode == 200) {
        debugPrint("✅ Answer successfully submitted");

        // Optionally update session after submitting
        await _updateLocalSession(response);
      } else {
        debugPrint("⚠️ Failed to submit answer: ${response.body}");
        _setErrorMessage('Failed to submit answer: ${response.body}');
      }
    } catch (e) {
      debugPrint("⚠️ Error submitting answer: $e");
      _setErrorMessage('Error submitting answer: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateLocalSession(http.Response response) async {
    try {
      debugPrint("Raw response iiiii body: ${response.body}");

      final data = jsonDecode(response.body); // Safely decode response body
      debugPrint("🔍 Decoded lll  data: $data");

      final sessionData = data['updatedSession'];

      // Here, check if sessionData is already a Map
      if (sessionData is Map<String, dynamic>) {
        // Directly use sessionData as it's already a Map
        _currentSession = QuizSession.fromJson(sessionData);

        debugPrint("✅ Session updated successfully");
      } else {
        // Throw an error if updatedSession is not a Map
        throw Exception("Unexpected type for updatedSession: ${sessionData.runtimeType}");
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error updating session: $e");
    }
  }


  // Set the current session when starting a new session
  void setSession(QuizSession session) {
    _currentSession = session;
  }

  // Optionally add token handling
  void setToken(String token) {
    _token = token;
  }
}
