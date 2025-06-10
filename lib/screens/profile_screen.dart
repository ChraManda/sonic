import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic/providers/auth.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/statistics_provider.dart';
import '../providers/user.dart';
import '../reusable_widgets/reusable_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, String>> achievementList = [
    {
      'imageUrl': 'assets/images/logo_1.png',
      'title': 'Pitch Perfect'
    },
    {
      'imageUrl': 'assets/images/logo_1.png',
      'title': 'Interval Master'
    },
    {
      'imageUrl': 'assets/images/logo_1.png',
      'title': 'Chord Master'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider
        .of<UserProvider>(context)
        .user;

    // If the user is not found return progress screen
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Your Profile",
          style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF0D47A1)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              const CircleAvatar(
                radius: 55,
                child: Image(image: AssetImage('assets/images/gym.png')),
              ),
              const SizedBox(height: 10),
              Text('${user.userName}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              Text((user.email != null && user.email!.isNotEmpty) ? user.email! : '_@_',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),


              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit_profile');
                },
                child: const Text("Edit", style: TextStyle(color: Colors.blue)),
              ),

              const SizedBox(height: 10),

              // Streak & Points
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatBox("Day Streak", "${user.streak}"
                      , Icons.local_fire_department, Colors.red,
                      Colors.blueAccent.shade200),
                  const SizedBox(width: 50), // Adjust spacing
                  _buildStatBox("Points", "${user.totalPoints} pts", Icons.bolt,
                      Colors.white, Colors.blueAccent.shade200),
                ],
              ),

              const SizedBox(height: 30),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: user.nextLevelPoints != null && user.nextLevelPoints > 0
                              ? (user.pointsInCurrentLevel / user.nextLevelPoints).clamp(0.0, 1.0)
                              : 0.0,
                          minHeight: 20,
                          backgroundColor: const Color(0xFF4E4D4D),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFCDDC39),
                          ),
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


              const SizedBox(height: 30),

          // Achievements Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Achievements",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBadgeBox("🎯", "Accuracy Master", Colors.blue),
                  _buildBadgeBox("🔥", "Streak Hero", Colors.red),
                  _buildBadgeBox("💡", "Quick Learner", Colors.green),
                ],
              ),


              SizedBox(height: 20),
              SecondaryButton(
                label: "Logout",
                onTap: () async {
                  // Get the Auth instance using Provider
                  final auth = Provider.of<Auth>(context, listen: false);

                  // Call the logout method
                  await auth.logout();

                  // After logging out, navigate to the desired screen
                  Navigator.pushReplacementNamed(context, '/login_screen');
                },
                borderColor: Color(0xFFcddc40), // Change the outline color
                icon: Icons.logout, // Customize the icon
              )
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildStatBox(String title, String value, IconData icon,
      Color iconColor, Color backgroundColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 145,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildBadgeBox(String emoji, String label, Color backgroundColor) {
    return SizedBox(
      width: 90, // Uniform width for all badge items
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 32, // Reserve enough height for up to 2 lines
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}