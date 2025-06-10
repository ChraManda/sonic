import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sonic/constants/address_constants.dart';
import 'package:sonic/models/statistics_model.dart';
import 'package:sonic/models/category_accuracy_model.dart';
import 'package:sonic/models/note_accuracy_model.dart';

class StatisticsProvider with ChangeNotifier {
  String? _token;
  StatisticsModel? _statistics;

  StatisticsModel get statistics => _statistics ?? _defaultStats();

  // ========================
  // ====== Update token ====
  // ========================
  void update(String? token) {
    if (token == null) return;
    _token = token;
    notifyListeners(); // Useful if UI depends on token changes
  }

  // ================================
  // ====== Fetch Statistics ========
  // ================================
  Future<void> fetchStatistics() async {
    if (_token == null) {
      debugPrint("Token is null. Cannot fetch statistics.");
      return;
    }

    final url = '$host/api/v1/statistics/user';
    debugPrint('Fetching stats from $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint("Stats response status: ${response.statusCode}");
      debugPrint("Stats response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Stats fetched: $data");

        _statistics = StatisticsModel.fromJson(data);
        notifyListeners();
      } else {
        debugPrint('❌ Failed to fetch stats: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Error fetching statistics: $e");
    }
  }

  // ========================================
  // === Optional: Force update statistics ==
  // ========================================
  void updateStatistics(StatisticsModel newStats) {
    _statistics = newStats;
    notifyListeners();
  }

  // ========================================
  // === Fallback in case no stats fetched ==
  // ========================================
  StatisticsModel _defaultStats() {
    return StatisticsModel(
      averageAccuracy: 0,
      recentAccuracy: [],
      totalQuizzes: 0,
      totalCorrectAnswers: 0,
      totalIncorrectAnswers: 0,
      strongAreas: [],
      weakAreas: [],
      categoryAccuracy: [],
    );
  }
}
