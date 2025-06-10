import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sonic/reusable_widgets/reusable_widgets.dart';

class ReadNotesScreen extends StatefulWidget {
  const ReadNotesScreen({super.key});

  @override
  State<ReadNotesScreen> createState() => _ReadNotesScreenState();
}

class _ReadNotesScreenState extends State<ReadNotesScreen> {
  final Map<String, NoteInfo> notes = {
    "C Major": NoteInfo(
      description: "The first white key in the C major scale.",
      fileName: "C4v15.wav",
      backgroundColor: Colors.red.shade100,
    ),
    "D Major": NoteInfo(
      description: "A step above C, between C and E.",
      fileName: "D4v15.wav",
      backgroundColor: Colors.orange.shade100,
    ),
    "E Major": NoteInfo(
      description: "A major third above C.",
      fileName: "E4v15.wav",
      backgroundColor: Colors.yellow.shade100,
    ),
    "F Major": NoteInfo(
      description: "Right next to E, starting the second half of the octave.",
      fileName: "F4v15.wav",
      backgroundColor: Colors.green.shade100,
    ),
    "G Major": NoteInfo(
      description: "A perfect fifth above C.",
      fileName: "G4v15.wav",
      backgroundColor: Colors.teal.shade100,
    ),
    "A Major": NoteInfo(
      description: "Used in many melodies, one of the most common notes.",
      fileName: "A4v15.wav",
      backgroundColor: Colors.blue.shade100,
    ),
    "B Major": NoteInfo(
      description: "Leads back to C, just before the octave repeats.",
      fileName: "B4v15.wav",
      backgroundColor: Colors.purple.shade100,
    ),
  };

  final Map<String, AudioPlayer> _players = {};

  @override
  void initState() {
    super.initState();
    _preloadPlayers();
  }

  Future<void> _preloadPlayers() async {
    for (var entry in notes.entries) {
      final player = AudioPlayer();
      try {
        await player.setAsset("assets/sounds/${entry.value.fileName}");
        _players[entry.key] = player;
      } catch (e) {
        debugPrint("Error loading ${entry.value.fileName}: $e");
      }
    }
  }

  @override
  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }

  void _play(String note) {
    final player = _players[note];
    if (player != null) {
      player.seek(Duration.zero);
      player.play();
    }
  }

  Widget _buildMiniKeyboard(String highlightNote) {
    final whiteNotes = ["C", "D", "E", "F", "G", "A", "B"];
    final blackNotePositions = {
      0: "C#",
      1: "D#",
      3: "F#",
      4: "G#",
      5: "A#",
    };

    return SizedBox(
      width: 280,
      height: 100,
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: whiteNotes.map((note) {
              bool isHighlighted = note == highlightNote;
              return Container(
                width: 40,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: isHighlighted
                    ? Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.limeAccent, width: 5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
                    : null,
              );
            }).toList(),
          ),
          Positioned(
            top: 0,
            left: 10,
            child: Row(
              children: List.generate(7, (index) {
                if (blackNotePositions.containsKey(index)) {
                  return Container(
                    width: 40,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 24,
                      height: 60,
                      color: Colors.black,
                      margin: const EdgeInsets.only(right: 4),
                    ),
                  );
                } else {
                  return const SizedBox(width: 40);
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(String note, NoteInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1.2, height: 30),
        Text(
          note,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
        ),
        const SizedBox(height: 6),
        Text(
          info.description,
          style: const TextStyle(fontSize: 15, color: Color(0xFF0D47A1)),
        ),
        const SizedBox(height: 10),
        _buildMiniKeyboard(note[0]),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _play(note),
          child: Card(
            color: info.backgroundColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.play_arrow, color:Color(0xFF0D47A1)),
                  const SizedBox(width: 12),
                  Text(
                    "Tap to play $note",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: popButton(context),
        title: const Text(
          "Read Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF0D47A1),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "What is a Note?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 8),
            const Text(
              "A note is a sound with a specific pitch. These notes form scales and melodies in music.",
              style: TextStyle(fontSize: 16, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 24),
            const Text(
              "Common Major Keys",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 5),
            ...notes.entries.map((entry) {
              return _buildNoteSection(entry.key, entry.value);
            }),
          ],
        ),
      ),
    );
  }
}

class NoteInfo {
  final String description;
  final String fileName;
  final Color backgroundColor;

  NoteInfo({
    required this.description,
    required this.fileName,
    required this.backgroundColor,
  });
}
