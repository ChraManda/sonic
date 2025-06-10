import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:sonic/screens/reading_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../reusable_widgets/reusable_widgets.dart';

class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Instrument Sounds",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF0D47A1),
          ),
        ),

      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16,8,16,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  InstrumentCard(title: "Piano", image: "assets/images/piano_image.jpg", route: '/virtual_piano_screen',),
                  InstrumentCard(title: "Flute", image: "assets/images/Flute_image.jpg", route: '/flute_screen',),
                  InstrumentCard(title: "Guitar", image: "assets/images/guitar_image.jpeg", route: '/virtual_piano_screen',),
                  InstrumentCard(title: "Harp", image: "assets/images/harp_image.jpg", route: '/virtual_piano_screen',),
                  InstrumentCard(title: "Piano Synth", image: "assets/images/piano_synth.jpeg", route: '/virtual_piano_screen',),
            ],
          ),
        ),
      ),
    );
  }
}

class InstrumentCard extends StatelessWidget {
  final String title;
  final String image;
  final String route;

  const InstrumentCard({
    Key? key,
    required this.title,
    required this.image,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
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
