import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic/providers/auth.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Profile Image
            const CircleAvatar(
              radius: 55,
              child: Image(image: AssetImage('assets/images/logo_1.png')),
            ),
            const SizedBox(height: 10),
            Text('${user.userName}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            Text('rodri@gmail.com${user.email}',
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
                    , Icons.local_fire_department, Colors.red, Colors.blueAccent.shade200),
                const SizedBox(width: 80), // Adjust spacing
                _buildStatBox("Points", "${user.totalPoints} pts", Icons.bolt,
                    Colors.white, Colors.blueAccent.shade200),
              ],
            ),

            const SizedBox(height: 30),

            // Progress Bar
            Column(
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
                Row(
                  children: [
                    const Text(
                      'Level:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    Text(
                      '${user.level}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
              child: Text("Achievements",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),

            // Fixed Achievement Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SizedBox( // Ensures it doesn’t exceed screen height
                height: 180, // Adjust height to fit screen
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevents nested scrolling issues
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                  children: List.generate(
                    achievementList.length,
                        (index) =>
                        _buildAchievementTile(
                          achievementList[index]['imageUrl']!,
                          achievementList[index]['title']!,
                        ),
                  ),
                ),
              ),
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

    );
  }

  Widget _buildStatBox(String title, String value, IconData icon, Color iconColor, Color backgroundColor) {
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
          width: 120,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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



  Widget _buildAchievementTile(String imageUrl, String title) {
    bool isNetworkImage = imageUrl.startsWith(
        "http"); // Check if it's a network image

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3, // Gives a slight shadow effect
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: ClipOval(
                child: isNetworkImage
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.music_note, size: 30, color: Colors.black),
                )
                    : Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.music_note, size: 30, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Handles overflow with ellipsis
              maxLines: 1, // Prevents the text from overflowing on multiple lines
            ),
          ],
        ),
      ),
    );
  }
}
