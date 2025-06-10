import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_session_provider.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../providers/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Safe progress calculation with clamp
    double progress = 0.0;
    if (user.nextLevelPoints != null && user.nextLevelPoints > 0) {
      progress = (user.pointsInCurrentLevel / user.nextLevelPoints).clamp(0.0, 1.0);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Sonic Skill Up",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF0D47A1),
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(LucideIcons.settings),
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/settings_screen');
        //     },
        //   ),
        // ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                const SizedBox(height: 10),

                // Logo
                Center(
                  child: SizedBox(
                    height: 120,
                    child: Image.asset(
                      'assets/images/logo_1.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Progress Bar + Level
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 20,
                            backgroundColor: const Color(0xFF4E4D4D),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFCDDC39)),
                          ),
                        ),
                        Text(
                          '${user.pointsInCurrentLevel} / ${user.nextLevelPoints} pts to Level ${user.level + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Level ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        Text(
                          '${user.level}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Two Cards
                Row(
                  children: [
                    // Personalized Quiz Card
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                                child: Image.asset(
                                  'assets/images/personalizede.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Personalized Quiz",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF0D47A1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Quizzes tailored to your skill level.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4E4D4D),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  await Provider.of<QuizSessionProvider>(
                                    context,
                                    listen: false,
                                  ).startPersonalizedSession("general", 10);

                                  Navigator.pushNamed(
                                    context,
                                    '/personalized_quiz_screen',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFCDDC39),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Start",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Ear Training Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/reading_screen');
                        },
                        child: Card(
                          color: const Color(0xFF81D4FA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 130,
                                  child: Image.asset(
                                    'assets/images/gym.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Ear Training",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF0D47A1),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Level up your Ear.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF004D40),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Start Quiz Button
                Center(
                  child: CustomButton(
                    label: "Start Quiz",
                    onTap: () async {
                      await Provider.of<QuizSessionProvider>(
                        context,
                        listen: false,
                      ).startSession("general", 10);

                      Navigator.pushNamed(context, '/quiz_screen');
                    },
                    color: const Color(0xFFCDDC39),
                    icon: Icons.play_circle_outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
