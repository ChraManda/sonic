import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic/providers/answer_provider.dart';

import 'package:sonic/providers/auth.dart';
import 'package:sonic/providers/quiz_session_provider.dart';
import 'package:sonic/providers/statistics_provider.dart';
import 'package:sonic/providers/user.dart';
import 'package:sonic/screens/flute_screen.dart';
import 'package:sonic/screens/quiz/interval_training_screen.dart';
import 'package:sonic/screens/quiz/note_training_screen.dart';
import 'package:sonic/screens/quiz/personalized_quiz_screen.dart';
import 'package:sonic/screens/quiz/quiz_screen.dart';

import 'screens/onboarding/login_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'package:sonic/screens/home_screen.dart';
import 'package:sonic/screens/edit_profile_screen.dart';
import 'package:sonic/screens/settings_screen.dart';
import 'package:sonic/screens/profile_screen.dart';
import 'package:sonic/screens/statistics_screen.dart';
import 'package:sonic/screens/virtual_piano.dart';
import 'package:sonic/screens/piano_screen.dart';
import 'package:sonic/screens/read_notes_screen.dart';
import 'package:sonic/screens/read_intervals_screen.dart';
import 'package:sonic/screens/reading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ChangeNotifierProvider(create: (_) => QuizSessionProvider()),
        ChangeNotifierProvider(create: (_) => AnswerProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sonic Skill Up',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthGate(),
      routes: {
        '/login_screen': (context) => const LoginScreen(),
        '/onboarding_screen': (context) => const OnboardingScreen(),
        '/navbar': (context) => const NavBar(), // Navigate to NavBarPage after login
        '/reading_screen': (context) => const ReadingScreen(),
        '/read_intervals': (context) => const ReadIntervalsScreen(),
        '/read_notes': (context) => const ReadNotesScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/settings_screen': (context) => const SettingsScreen(),
        '/profile_screen': (context) => const ProfileScreen(),
        '/virtual_piano_screen': (context) => const VirtualPiano(),
        '/quiz_screen': (context) => const QuizScreen(),
        '/flute_screen': (context) => const FluteScreen(),
        '/personalized_quiz_screen': (context) => const PersonalizedQuizScreen(),
        '/interval_training_screen': (context) => const IntervalTrainingScreen(),
        '/note_training_screen': (context) => const NoteTrainingScreen(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Show progress while waiting for navigation
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0; // Default to HomeScreen

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const PianoScreen(),
    const StatisticsScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index when tapping on a bottom nav item
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use IndexedStack to maintain the state of each screen
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.piano), label: 'Piano'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Progress'),
        ],
        currentIndex: _selectedIndex, // Highlight the selected tab
        selectedItemColor: Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped, // Handle tab changes
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final auth = Provider.of<Auth>(context, listen: false);

      if (auth.isLoggedIn) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(
            context,
            auth.onboarded ?? false ? '/navbar' : '/onboarding_screen', // Navigate to NavBar if logged in
          );
        });
      } else {
        auth.tryAutoLogin(context).then((success) {
          if (!context.mounted) return; // ensures the context is still valid

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (auth.isLoggedIn) {
              if (auth.onboarded ?? false) {
                Navigator.pushReplacementNamed(context, '/navbar');
              } else {
                Navigator.pushReplacementNamed(context, '/onboarding_screen');
              }
            } else {
              Navigator.pushReplacementNamed(context, '/login_screen');
            }
          });
        });
      }


      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(); // Show loading until navigation is handled
  }
}