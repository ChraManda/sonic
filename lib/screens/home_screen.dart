import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart'; // Add this import
import '../providers/quiz_session_provider.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../providers/user.dart'; // Ensure this import is present

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double progress = 0.0; // Initial progress (0%)

  @override
  void initState() {
    super.initState();
  }

  void increaseProgress() {
    setState(() {
      progress += 0.1; // Example: Increase by 10% (Adjust based on points)
      if (progress > 1.0) progress = 1.0; // Cap progress at 100%
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetching the User from UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    double maxPoints = user!.totalPoints / 1.3;

    // Ensure user is loaded before trying to access username
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Sonic Skill Up",
            style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF0D47A1)),
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings_screen');
              },
            ),
          ],
        ),
        backgroundColor: Colors.white, // Background color to match the design
        body: const Center(child: CircularProgressIndicator()), // Loading until user is fetched
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Sonic Skill Up",
          style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0D47A1)),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings_screen');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Background color to match the design
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Small Logo at the Top
            Center(
              child: SizedBox(
                height: 170, // Reduced size for the logo
                child: Image(
                  image: AssetImage('assets/images/logo_1.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,

                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (user.totalPoints / 5000),
                          minHeight: 12,
                          backgroundColor: const Color(0xFF4E4D4D),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFCDDC39)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "${user.totalPoints} pts",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),
            CustomLabel(
              text: "Level: ${user.level}",
              color: Color(0xFF0D47A1),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(20, 5, 5, 0), // Aligns label to the center
            ),

            const SizedBox(height: 150),

            // Start Button
            CustomButton(
              label: "Start", onTap: () async {
              await Provider.of<QuizSessionProvider>(context, listen: false)
                  .startSession("general",10);
                Navigator.pushNamed(context, '/quiz_screen');
            },
              color: Color(0xFFcddc40),
              icon: Icons.play_circle_outline,
            ),

            const SizedBox(height: 50),

            // Ear Training Section
            const Text(
              "Level Up Your Ear",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            SecondaryButton(
              label: "Ear Training",
              onTap: () {
                Navigator.pushNamed(context, '/reading_screen');
              },
              borderColor: Color(0xFFcddc40), // Change the outline color
              icon: Icons.hearing_rounded, // Customize the icon
            ),
          ],
        ),
      ),
    );
  }
}
