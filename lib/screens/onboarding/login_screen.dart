import 'dart:convert';
import 'package:flutter/material.dart';
// ==== IMPORT PROVIDER ====
import 'package:provider/provider.dart';
import 'package:sonic/providers/answer_provider.dart';
import 'package:sonic/providers/auth.dart';
import 'package:sonic/providers/user.dart';

import '../../providers/quiz_session_provider.dart';
import '../../providers/statistics_provider.dart';
import '../../reusable_widgets/reusable_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _showOTP = false;

  // === FORM CONTROLLERS ===
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // === FORM KEY ===
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_phoneController.text.length != 10) {
        // show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid mobile number'),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await Provider.of<Auth>(context, listen: false)
            .sendOtp(_phoneController.text);
        if (response.statusCode == 200) {
          setState(() {
            _showOTP = true;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent successfully. Please check your phone.'),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to send OTP. Please try again later.'),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to send OTP. Please try again later.'),
          ),
        );
      }
    }
  }

  void _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await Provider.of<Auth>(context, listen: false)
            .verifyOtp(_phoneController.text, _otpController.text, context);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint("Fetched Data: $data");

          // Fetch user info using updated UserProvider
          await Provider.of<UserProvider>(context, listen: false)
              .fetchUserInfo();

          // Set user info in provider
          Provider.of<UserProvider>(context, listen: false)
              .update(data['token']);

          final quizSessionProvider = Provider.of<QuizSessionProvider>(context, listen: false);
          quizSessionProvider.update(data['token']);

          final answerProvider = Provider.of<AnswerProvider>(context, listen: false);
          answerProvider.update(data['token']);

          final statsProvider = Provider.of<StatisticsProvider>(context, listen: false);
          statsProvider.update(data['token']);
          await statsProvider.fetchStatistics();

          final auth = Provider.of<Auth>(context, listen: false);

          setState(() {
            _isLoading = false;
          });

          Navigator.pushReplacementNamed(
            context,
            auth.onboarded ?? false ? '/navbar' : '/onboarding_screen',
          );
        } else {
          setState(() {
            _isLoading = false;
          });

          final jsonResponse = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonResponse['message']),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to verify OTP. Please try again later.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Center(
                    child: SizedBox(
                      height: 170,
                      child: Image.asset(
                        'assets/images/logo_1.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40,),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Color(0xFF0D47A1), fontSize: 32, fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your phone number to continue',
                    style: TextStyle(color: Color(0xFF0D47A1), fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  !_showOTP
                      ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        autofocus: true,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Phone Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your mobile number';
                          } else if (value.length != 10) {
                            return 'Please enter a valid mobile number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _phoneController.text = value!;
                        },
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _sendOTP();
                          }
                        },
                      ))
                      : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          autofocus: true,
                          controller: _otpController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Enter Your OTP',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : _sendOTP,
                        child: const Text('Resend OTP'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0D47A1),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: _isLoading
                            ? "Loading..."
                            : "Continue",
                        onTap: () {
                          if (_isLoading) return;
                          if (_showOTP) {
                            _verifyOTP();
                          } else {
                            _sendOTP();
                          }
                        },
                        color: const Color(0xFFcddc40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
