import 'dart:convert';
import 'package:flutter/material.dart';

// ==== IMPORT PROVIDER ====
import 'package:provider/provider.dart';
import 'package:sonic/providers/auth.dart';
import 'package:sonic/reusable_widgets/reusable_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isLoading = false;

  // === FORM CONTROLLERS ===
  final TextEditingController _nameController = TextEditingController();

  // === FORM KEY ===
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await Provider.of<Auth>(context, listen: false)
            .onboard(_nameController.text);

        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });

          // Navigate to home screen (like LoginScreen)
          Navigator.pushReplacementNamed(context, '/navbar');
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
            content: Text('Unable to onboard. Please try again later.'),
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
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    height: 170,
                    child: Image.asset(
                      'assets/images/logo_1.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Let\'s  Get Started',
                    style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your Username to continue',
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nameController.text = value!;
                    },
                    onFieldSubmitted: (value) {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _submitForm();
                      }
                    },
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: _isLoading ? "Loading..." : "Continue",
                      onTap: () {
                        if (_isLoading) return;
                        _submitForm();
                      },
                      color: Color(0xFFCDDC39),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}