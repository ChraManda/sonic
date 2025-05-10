import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../reusable_widgets/reusable_widgets.dart';

class FluteScreen extends StatefulWidget {
  const FluteScreen({super.key});

  @override
  State<FluteScreen> createState() => _FluteScreenState();
}

class _FluteScreenState extends State<FluteScreen> {
  bool _isLoading = true;
  final Map<String, AudioPlayer> _players = {};

  final List<String> notes = [
    'A4v15.wav',
    // 'Asharp4v15.wav',
    'B4v15.wav',
    'C4v15.wav',
    // 'Csharp4v15.wav',
    'D4v15.wav',
    // 'Dsharp4v15.wav',
    'E4v15.wav',
    'F4v15.wav',
    // 'Fsharp4v15.wav',
    'G4v15.wav',
    // 'Gsharp4v15.wav',
  ];

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    for (var note in notes) {
      final player = AudioPlayer();
      try {
        await player.setAsset('assets/sounds/flute/$note');
        _players[note] = player;
      } catch (e) {
        debugPrint(" Error loading $note: $e");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> playNote(String fileName) async {
    if (_isLoading) return;

    final player = _players[fileName];
    if (player != null) {
      await player.seek(Duration.zero);
      await player.play();
    } else {
      debugPrint("⚠️ No player loaded for: $fileName");
    }
  }

  @override
  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: popButton(context),
          title: const Text(
            "Flute",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0D47A1),
            ),
          ),
        ),
        body: Center(
          child: RotatedBox(
            quarterTurns: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PianoButtonWithSuperKey(
                  noteLabelMain: 'C',
                  noteLabelSuper: 'C#',
                  onMainKeyPress: () => playNote('C4v15.wav'),
                  onSuperKeyPress: () => playNote('Csharp4v15.wav'),
                ),
                PianoButton(
                  noteLabel: 'B',
                  onKeyPress: () => playNote('B4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'A',
                  noteLabelSuper: 'A#',
                  onMainKeyPress: () => playNote('A4v15.wav'),
                  onSuperKeyPress: () => playNote('Asharp4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'G',
                  noteLabelSuper: 'G#',
                  onMainKeyPress: () => playNote('G4v15.wav'),
                  onSuperKeyPress: () => playNote('Gsharp4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'F',
                  noteLabelSuper: 'F#',
                  onMainKeyPress: () => playNote('F4v15.wav'),
                  onSuperKeyPress: () => playNote('Fsharp4v15.wav'),
                ),
                PianoButton(
                  noteLabel: 'E',
                  onKeyPress: () => playNote('E4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'D',
                  noteLabelSuper: 'D#',
                  onMainKeyPress: () => playNote('D4v15.wav'),
                  onSuperKeyPress: () => playNote('Dsharp4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'C',
                  noteLabelSuper: 'C#',
                  onMainKeyPress: () => playNote('C4v15.wav'),
                  onSuperKeyPress: () => playNote('Csharp4v15.wav'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PianoButtonWithSuperKey extends StatelessWidget {
  final VoidCallback onMainKeyPress;
  final VoidCallback onSuperKeyPress;
  final String noteLabelMain;
  final String noteLabelSuper;

  const PianoButtonWithSuperKey({
    Key? key,
    required this.onMainKeyPress,
    required this.onSuperKeyPress,
    required this.noteLabelSuper,
    required this.noteLabelMain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 2.0, top: 2.0),
            child: Listener(
              onPointerDown: (_) => onMainKeyPress(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF0F0F0),
                      Color(0xFFE0E0E0),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: Offset(-1, -1),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(noteLabelMain),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -22,
            left: -2,
            child: Listener(
              onPointerDown: (_)=>onSuperKeyPress(),
              child: Container(
                height: 60,
                width: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF171717),
                      Color(0xFF2C2C2C),
                      Color.fromRGBO(70, 70, 70, 1.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade800, width: 6),
                    left: BorderSide(color: Colors.grey.shade800, width: 3),
                    right: BorderSide(color: Colors.grey.shade800, width: 15),
                    top: BorderSide(color: Colors.grey.shade800, width: 6), // Or use a value if needed
                  ),
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(noteLabelSuper
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PianoButton extends StatelessWidget {
  final VoidCallback onKeyPress;
  final String noteLabel;

  const PianoButton({
    Key? key,
    required this.onKeyPress,
    required this.noteLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 2.0, top: 2.0),
        child: Listener(
          onPointerDown: (_) => onKeyPress(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFF0F0F0),
                  Color(0xFFE0E0E0),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  offset: Offset(-1, -1),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
            child: Center(
              child: RotatedBox(quarterTurns: 3,
                  child: Text(noteLabel)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
