import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonic/constants/address_constants.dart';
import 'package:sonic/providers/quiz_session_provider.dart';
import 'package:sonic/providers/statistics_provider.dart';
import 'package:sonic/providers/user.dart';
import 'package:provider/provider.dart';

import 'answer_provider.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _phone;
  String? _userName;
  String? _status;
  bool? _onboarded;

  String? get userName => _userName;
  String? get phone => _phone;
  String? get token => _token;
  String? get status => _status;
  String? get userId => _userId;
  bool? get onboarded => _onboarded;

  bool get isLoggedIn => _token != null;

  Future<void> setSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'phone': _phone,
      'userName': _userName,
      'status': _status,
      'onboarded': _onboarded ?? false,
    });
    await prefs.setString('userData', userData);
    debugPrint("Saved userData to SharedPreferences: $userData");
  }

  Future<http.Response> sendOtp(String phone) async {
    try {
      debugPrint("Sending OTP to $phone");
      final url = "$host/api/v1/send/otp/number/$phone";
      final response = await http.get(Uri.parse(url));
      debugPrint("OTP Response: ${response.body}");
      return response;
    } catch (e) {
      debugPrint("Send OTP Error: $e");
      rethrow;
    }
  }

  Future<http.Response> verifyOtp(String phone, String otp, BuildContext context) async {
    try {
      debugPrint("Verifying OTP for $phone");
      final url = "$host/api/v1/verify/otp";
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({"phone": phone, "otp": otp}),
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = jsonDecode(response.body);
      debugPrint("OTP Verification Response: $responseBody");

      if (response.statusCode == 200 && responseBody.containsKey('token')) {
        _token = responseBody['token'];

        final userResponse = await http.get(
          Uri.parse("$host/api/v1/current-user"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );

        if (userResponse.statusCode == 200) {
          final user = jsonDecode(userResponse.body);
          _userId = user['_id'];
          _phone = user['phone'];
          _userName = user['userName'];
          _status = user['status'];
          _onboarded = user['isOnboarded'] ?? false;

          await setSharedPreference();
          notifyListeners();

          // Now that the user is authenticated, fetch the user info and notify the UserProvider
          // Pass the userId dynamically if available
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.update(_token); // optional: keep token in sync
          await userProvider.fetchUserInfo();


          debugPrint("OTP Verified and user fetched successfully.");
        } else {
          debugPrint("Failed to fetch user after OTP verification. Status code: ${userResponse.statusCode}");
        }
      } else {
        debugPrint("Invalid OTP verification response: $responseBody");
      }

      return response;
    } catch (e) {
      debugPrint("Verify OTP Error: $e");
      rethrow;
    }
  }

  Future<http.Response> onboard(String userName) async {
    try {
      debugPrint("Onboarding with userName: $userName");
      final url = "$host/api/v1/onboard";
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({"userName": userName}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        _onboarded = true;
        _userName = userName;
        await setSharedPreference();
        notifyListeners();
        debugPrint("Onboarding successful.");
      } else {
        debugPrint("Onboarding failed with status code: ${response.statusCode}");
      }

      return response;
    } catch (e) {
      debugPrint("Onboard Error: $e");
      rethrow;
    }
  }

  Future<bool> tryAutoLogin(BuildContext context) async {
    debugPrint("Attempting auto login...");
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData == null) {
      debugPrint("No user data found in SharedPreferences.");
      return false;
    }

    final userDataJson = jsonDecode(userData);
    _token = userDataJson['token'];
    _userId = userDataJson['userId'];
    _phone = userDataJson['phone'];
    _userName = userDataJson['userName'];
    _status = userDataJson['status']  ?? "ACTIVE";
    _onboarded = userDataJson['onboarded'] ?? false;

    try {
      final url = "$host/api/v1/current-user";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _userId = responseBody['_id'];
        _phone = responseBody['phone'];
        _userName = responseBody['userName'];
        _status = responseBody['status'] ??  "ACTIVE";
        _onboarded = responseBody['isOnboarded'] ?? false;

        // Save user data to shared preferences
        await setSharedPreference();
        notifyListeners();

        // Fetch user info from the UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.update(_token);
        await userProvider.fetchUserInfo();
        // Fetch user details after successful auto-login
        final quizSessionProvider = Provider.of<QuizSessionProvider>(context, listen: false);
        quizSessionProvider.update(_token);

        final answerProvider = Provider.of<AnswerProvider>(context, listen: false);
        answerProvider.update(_token);

        final statsProvider = Provider.of<StatisticsProvider>(context, listen: false);
        statsProvider.update(_token);
        await statsProvider.fetchStatistics();

        debugPrint("Auto login successful.");
        return true;
      }

      debugPrint("Auto login failed. Status code: ${response.statusCode}");
      return false;
    } catch (e) {
      debugPrint("Auto login error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _phone = null;
    _userName = null;
    _status = null;
    _onboarded = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');

    notifyListeners();
    debugPrint("User logged out and SharedPreferences cleared.");
  }
}
