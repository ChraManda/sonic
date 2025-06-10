import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sonic/constants/address_constants.dart';

class UserModel {
  final String id;
  final String userName;
  final String phone;
  final String? email;
  final int streak;
  final int totalPoints;
  final int level;
  final int pointsInCurrentLevel;
  final int nextLevelPoints;
  final List<String> badges;

  UserModel({
    required this.id,
    required this.userName,
    required this.phone,
    this.email,
    required this.streak,
    required this.totalPoints,
    required this.level,
    required this.pointsInCurrentLevel,
    required this.nextLevelPoints,
    required this.badges,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {int nextLevelPoints = 0}) {
    return UserModel(
      id: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      streak: json['streak'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      level: json['level'] ?? 1,
      pointsInCurrentLevel: json['pointsInCurrentLevel'] ?? 0,
      badges: json['badges'] != null
          ? List<String>.from(json['badges'])
          : [],
      nextLevelPoints: nextLevelPoints,
    );
  }
}

class UserProvider with ChangeNotifier {
  String? _token;
  UserModel? _user;

  UserModel? get user => _user;

  void update(String? token) {
    if (token == null) return;
    _token = token;
    notifyListeners();
  }

  void updateStats(Map<String, dynamic> stats) {
    if (_user == null) return;
    _user = UserModel(
      id: _user!.id,
      userName: _user!.userName,
      phone: _user!.phone,
      email: _user!.email,
      streak: stats['streak'] ?? _user!.streak,
      totalPoints: stats['totalPoints'] ?? _user!.totalPoints,
      level: stats['level'] ?? _user!.level,
      pointsInCurrentLevel: stats['pointsInCurrentLevel'] ?? _user!.pointsInCurrentLevel,
      nextLevelPoints: stats['nextLevelPoints'] ?? _user!.nextLevelPoints,
      badges: _user!.badges,
    );
    notifyListeners();
  }

  // ======================================
  // ====== Fetch User information ========
  // ======================================
  Future<void> fetchUserInfo() async {
    if (_token == null) {
      debugPrint("Token is null. Cannot fetch user info.");
      return;
    }

    final url = '$host/api/v1/get/profile/user';
    debugPrint("Fetching user information from $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint(" Response Status: ${response.statusCode}");
      debugPrint(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // If nextLevelPoints is included in the response, parse it; else 0
        final int nextLevelPoints = data['nextLevelPoints'] ?? 0;

        _user = UserModel.fromJson(data, nextLevelPoints: nextLevelPoints);

        notifyListeners();
        debugPrint("✅ User model updated and listeners notified.");
      } else {
        throw Exception("Failed to get user info (Status: ${response.statusCode})");
      }
    } catch (e) {
      debugPrint("Error fetching user info: $e");
      rethrow;
    }
  }

  // ========= ================== ===================
  //=========== Update User Information =============
  //=================================================
  Future<bool> updateUserDetails({
    required String userId,
    String? userName,
    String? phone,
    String? email,
  }) async {
    if (_token == null) {
      debugPrint("Token is null. Cannot update user details.");
      return false;
    }

    final url = '$host/api/v1/update/user';
    debugPrint("Updating user details at $url");

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "_id": userId,
          if (userName != null) "userName": userName,
          if (phone != null) "phone": phone,
          if (email != null) "email": email,
        }),
      );

      debugPrint("Update response status: ${response.statusCode}");
      debugPrint("Update response body: ${response.body}");

      if (response.statusCode == 200) {
        // Optionally, re-fetch updated user data
        await fetchUserInfo();
        return true;
      } else {
        debugPrint("Failed to update user details");
        return false;
      }
    } catch (e) {
      debugPrint("Error updating user details: $e");
      return false;
    }
  }
}
