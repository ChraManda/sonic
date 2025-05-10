import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sonic/constants/address_constants.dart';

class UserModel {
  final String id;
  final String userName;
  final String phone;
  final String email;
  final int streak;
  final int totalPoints;
  final int level;
  final List<dynamic> badges;
  final int nextLevelPoints;

  UserModel({
    required this.id,
    required this.userName,
    required this.phone,
    required this.email,
    required this.streak,
    required this.totalPoints,
    required this.badges,
    required this.level,
    required this.nextLevelPoints,
  });
}

class UserProvider with ChangeNotifier {
  String? _token;
  UserModel? _user;
  int totalPoints = 0;
  int level = 1;
  int streak = 0;

  UserModel? get user => _user;

  void update(String? token) {
    if (token == null) return;
    _token = token;
    notifyListeners(); // Optional but good if UI depends on this
  }

  void updateStats(Map<String, dynamic> stats) {
    totalPoints = stats['totalPoints'];
    level = stats['level'];
    streak = stats['streak'];
    notifyListeners();
  }

  Future<void> fetchUserInfo() async {
    if (_token == null) {
      debugPrint("Token is null. Cannot fetch user info.");
      return;
    }

    final url = '$host/api/v1/get/profile/user';
    debugPrint("Fetching user infor from $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint(" Response  Status: ${response.statusCode}");
      debugPrint(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Parsed user data: $data");

        _user = UserModel(
          id: data['_id'] ?? '',
          userName: data['userName'] ?? '',
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
          streak: data['streak'] ?? 0,
          totalPoints: data['totalPoints'] ?? 0,
          badges: data['badges'] ?? [],
          level: data['level'] ?? 1,
          nextLevelPoints: data['nextLevelPoints'] ?? 0,
        );
        notifyListeners();
        debugPrint("✅ User model updated and listeners notified.");
      } else {
        throw Exception(
            "Failed to get user info (Status: ${response.statusCode})");
      }
    } catch (e) {
      debugPrint("Error fetching user info: $e");
      rethrow;
    }
  }
}
