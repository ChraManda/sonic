import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_session_provider.dart';

import '../providers/user.dart';
import '../reusable_widgets/reusable_widgets.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool selectMode = false;
  Alignment toggleAlignment = Alignment.topCenter;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: popButton(context),
        title: const Text(
          "Ear Training",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF0D47A1),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: toggleAlignment,
              child: AnimatedToggleSwitch<bool>.size(
                current: selectMode,
                values: const [false, true],
                iconOpacity: 0.5,
                indicatorSize: const Size.fromWidth(200),
                customIconBuilder: (context, local, global) => Text(
                  local.value ? 'Note Reading' : 'Interval Reading',
                  style: TextStyle(
                    color: Color.lerp(Colors.black, Colors.white70, local.animationValue),
                  ),
                ),
                borderWidth: 5.0,
                iconAnimationType: AnimationType.onHover,
                style: ToggleStyle(
                  indicatorColor: const Color(0xFFcddc40),
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                selectedIconScale: 1.0,
                onChanged: (value) => setState(() {
                  selectMode = value;
                }),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: selectMode
                    ? [
                  InstrumentCard(
                    title: "Read Notes",
                    image: "assets/images/music_reading.jpg",
                    onTap: () => Navigator.pushNamed(context, '/read_notes'),
                  ),
                  InstrumentCard(
                    title: "Train Notes",
                    image: "assets/images/note_training.png",
                    onTap: () async {
                      await Provider.of<QuizSessionProvider>(context, listen: false)
                          .startSession("note_training", 10);
                      Navigator.pushNamed(context, '/note_training_screen');
                    },
                  ),
                ]
                    : [
                  InstrumentCard(
                    title: "Read Intervals",
                    image: "assets/images/music_reading.jpg",
                    onTap: () => Navigator.pushNamed(context, '/read_intervals'),
                  ),
                  InstrumentCard(
                    title: "Train Intervals",
                    image: "assets/images/interval_training.jpg",
                    onTap: () async {
                      await Provider.of<QuizSessionProvider>(context, listen: false)
                          .startSession("interval_training", 10);
                      Navigator.pushNamed(context, '/interval_training_screen');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InstrumentCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const InstrumentCard({
    Key? key,
    required this.title,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        height: 130,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
