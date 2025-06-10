import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../reusable_widgets/reusable_widgets.dart';

class VirtualPiano extends StatefulWidget {
  const VirtualPiano({super.key});

  @override
  State<VirtualPiano> createState() => _VirtualPianoState();
}

class _VirtualPianoState extends State<VirtualPiano> {
  bool _isLoading = true;
  final Map<String, AudioPlayer> _players = {};

  final List<String> notes = [
    'A4v15.wav',
    'Asharp4v15.wav',
    'B4v15.wav',
    'C4v15.wav',
    'Csharp4v15.wav',
    'D4v15.wav',
    'Dsharp4v15.wav',
    'E4v15.wav',
    'F4v15.wav',
    'Fsharp4v15.wav',
    'G4v15.wav',
    'Gsharp4v15.wav',
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
        await player.setAsset('assets/sounds/$note');
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
            "Virtual Piano",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
                PianoButton(
                  noteLabel: 'C3',
                  onKeyPress: () => playNote('B4v15.wav'),
                ),
                PianoButton(
                  noteLabel: 'B4',
                  onKeyPress: () => playNote('B4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'A4',
                  noteLabelSuper: 'A4#',
                  onMainKeyPress: () => playNote('A4v15.wav'),
                  onSuperKeyPress: () => playNote('Asharp4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'G4',
                  noteLabelSuper: 'G4#',
                  onMainKeyPress: () => playNote('G4v15.wav'),
                  onSuperKeyPress: () => playNote('Gsharp4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'F4',
                  noteLabelSuper: 'F4#',
                  onMainKeyPress: () => playNote('F4v15.wav'),
                  onSuperKeyPress: () => playNote('Fsharp4v15.wav'),
                ),
                PianoButton(
                  noteLabel: 'E4',
                  onKeyPress: () => playNote('E4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'D4',
                  noteLabelSuper: 'D4#',
                  onMainKeyPress: () => playNote('D4v15.wav'),
                  onSuperKeyPress: () => playNote('Dsharp4v15.wav'),
                ),
                PianoButtonWithSuperKey(
                  noteLabelMain: 'C4',
                  noteLabelSuper: 'C4#',
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
                      color: Color.fromRGBO(0, 0, 0, 0.9), // soft black shadow
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.8), // soft white highlight
                      offset: Offset(-1, -1),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          noteLabelMain,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -35,
            left: -2,
            child: Listener(
              onPointerDown: (_) => onSuperKeyPress(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      Colors.grey.shade900,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
                      offset: const Offset(2, 0),
                      blurRadius: 0,
                      spreadRadius: 0.2,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.04),
                      offset: const Offset(-1, -1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(2.5), // thin black edge
                child: Container(
                  height: 65,
                  width: 240,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1A1A1A), // Slightly lighter for 3D illusion
                        Color(0xFF2C2C2C),
                        Color.fromRGBO(60, 60, 60, 1.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade700, width: 2.5),
                      left: BorderSide(color: Colors.grey.shade800, width: 2),
                      right: BorderSide(color: Colors.black.withOpacity(0.85), width: 10),
                      bottom: BorderSide(color: Colors.grey.shade900, width: 4),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Optional glossy highlight line
                      Positioned(
                        top: 8,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.06),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            noteLabelSuper,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  color: Color.fromRGBO(0, 0, 0, 0.9), // soft black shadow
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.8), // soft white highlight
                  offset: Offset(-1, -1),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      noteLabel,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                    ),
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
