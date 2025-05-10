import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../reusable_widgets/reusable_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _fullNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: popButton(context),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF0D47A1),
          ),
        ),
        actions: [
          popLabel(context, label: 'Done'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align labels to left
          children: [
            // Profile Image
            const Center(
              child: CircleAvatar(
                radius: 55,
                child: Image(image: AssetImage('assets/images/logo_1.png')),
              ),
            ),
            const SizedBox(height: 10),

            // Email and Username Display
            const Center(
              child: Column(
                children: [
                  Text(
                    "email.@.com",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Username",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Username Input
            buildLabel("Full Name"),
            resusableTextField("Full name", Icons.person_outline, false, _fullNameTextController),
            const SizedBox(height: 10),

            buildLabel("Email"),
            resusableTextField("Email", Icons.email_outlined, false, _emailTextController),
            const SizedBox(height: 10),

            buildLabel("Username"),
            resusableTextField("Username", Icons.person, false, _usernameTextController),

            const SizedBox(height: 20),

            // Buttons
            CustomButton(
              label: "Save Changes",
              onTap: () {},
              color: const Color(0xFFcddc40),
              icon: Icons.save,
            ),

          ],
        ),
      ),
    );
  }
}
