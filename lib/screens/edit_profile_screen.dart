import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';
import '../reusable_widgets/reusable_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _emailTextController.text = user.email!;
      _usernameTextController.text = user.userName;
      _phoneTextController.text = user.phone;
    }
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (user == null) return;

    final success = await userProvider.updateUserDetails(
      userId: user.id,
      userName: _usernameTextController.text.trim(),
      email: _emailTextController.text.trim(),
      phone: _phoneTextController.text.trim(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: popButton(context),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 55,
                child: Image(image: AssetImage('assets/images/logo_1.png')),
              ),
            ),
            const SizedBox(height: 10),

            Center(
              child: Column(
                children: [
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    user?.userName ?? '',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            buildLabel("Phone"),
            resusableTextField("Phone", Icons.phone, false, _phoneTextController),
            const SizedBox(height: 10),

            buildLabel("Email"),
            resusableTextField("Email", Icons.email_outlined, false, _emailTextController),
            const SizedBox(height: 10),

            buildLabel("Username"),
            resusableTextField("Username", Icons.person, false, _usernameTextController),

            const SizedBox(height: 20),

            CustomButton(
              label: "Save Changes",
              onTap: _saveChanges,
              color: const Color(0xFFcddc40),
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }
}
