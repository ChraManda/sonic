import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ReadIntervalsScreen extends StatefulWidget {
  const ReadIntervalsScreen({super.key});

  @override
  State<ReadIntervalsScreen> createState() => _ReadIntervalsScreenState();
}

class _ReadIntervalsScreenState extends State<ReadIntervalsScreen> {
  final List<String> whiteKeys = ["C", "D", "E", "F", "G", "A", "B"];
  final List<String> allKeys = [
    "C", "C#", "D", "D#", "E", "F",
    "F#", "G", "G#", "A", "A#", "B"
  ];

  final Map<String, int> noteIndex = {
    "C": 0, "C#": 1, "D": 2, "D#": 3, "E": 4,
    "F": 5, "F#": 6, "G": 7, "G#": 8, "A": 9,
    "A#": 10, "B": 11,
  };

  final List<IntervalInfo> intervals = [
    IntervalInfo(label: "Unison", semitones: 0, explanation: "Same note twice, sounds like a perfect match."),
    IntervalInfo(label: "Major 2nd", semitones: 2, explanation: "One whole step up, like C to D."),
    IntervalInfo(label: "Major 3rd", semitones: 4, explanation: "Bright and cheerful, like C to E."),
    IntervalInfo(label: "Perfect 4th", semitones: 5, explanation: "Strong and stable, like C to F."),
    IntervalInfo(label: "Perfect 5th", semitones: 7, explanation: "Very harmonious, like C to G."),
    IntervalInfo(label: "Major 6th", semitones: 9, explanation: "Warm and optimistic, like C to A."),
    IntervalInfo(label: "Major 7th", semitones: 11, explanation: "Tense and bright, like C to B."),
    IntervalInfo(label: "Octave", semitones: 12, explanation: "Same note, but higher in pitch."),
  ];

  String selectedRoot = "C";
  final Map<String, AudioPlayer> _players = {};

  @override
  void initState() {
    super.initState();
    _preloadPlayers();
  }

  Future<void> _preloadPlayers() async {
    for (var note in allKeys) {
      final player = AudioPlayer();
      try {
        await player.setAsset("assets/sounds/${note}4v15.wav");
        _players[note] = player;
      } catch (e) {
        debugPrint("Error loading ${note}4v15.wav: $e");
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

  Future<void> _playInterval(String root, int semitones) async {
    final rootIdx = noteIndex[root]!;
    final intervalIdx = (rootIdx + semitones) % 12;

    final rootNoteName = noteIndex.entries.firstWhere((e) => e.value == rootIdx).key;
    final intervalNoteName = noteIndex.entries.firstWhere((e) => e.value == intervalIdx).key;

    final rootPlayer = _players[rootNoteName];
    final intervalPlayer = _players[intervalNoteName];

    if (rootPlayer != null && intervalPlayer != null) {
      await rootPlayer.seek(Duration.zero);
      await rootPlayer.play();
      await Future.delayed(const Duration(milliseconds: 400));
      await intervalPlayer.seek(Duration.zero);
      await intervalPlayer.play();
    } else {
      debugPrint("Audio player missing for $rootNoteName or $intervalNoteName");
    }
  }

  Widget _buildToggleBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: whiteKeys.map((note) {
          final isSelected = note == selectedRoot;
          return GestureDetector(
            onTap: () => setState(() => selectedRoot = note),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? Colors.lime.shade600 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.limeAccent.shade700 : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: Text(
                note,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMiniKeyboard(String rootNote, int intervalSemitones) {
    final rootIdx = noteIndex[rootNote]!;
    final intervalIdx = (rootIdx + intervalSemitones) % 12;

    final highlightedNotes = [
      noteIndex.entries.firstWhere((e) => e.value == rootIdx).key,
      noteIndex.entries.firstWhere((e) => e.value == intervalIdx).key
    ];

    return SizedBox(
      width: 400,
      height: 120,
      child: Stack(
        children: [
          Row(
            children: whiteKeys.map((note) {
              final isHighlighted = highlightedNotes.contains(note);
              return Container(
                width: 40,
                height: 120,
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? (note == highlightedNotes[0]
                      ? Colors.limeAccent.shade200
                      : Colors.orange.shade200)
                      : Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              );
            }).toList(),
          ),
          Positioned(
            top: 0,
            left: 30,
            child: Row(
              children: [
                _buildBlackKey("C#", highlightedNotes),
                const SizedBox(width: 10),
                _buildBlackKey("D#", highlightedNotes),
                const SizedBox(width: 40),
                _buildBlackKey("F#", highlightedNotes),
                const SizedBox(width: 10),
                _buildBlackKey("G#", highlightedNotes),
                const SizedBox(width: 10),
                _buildBlackKey("A#", highlightedNotes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlackKey(String note, List<String> highlightedNotes) {
    final isHighlighted = highlightedNotes.contains(note);

    return Container(
      width: 24,
      height: 75,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isHighlighted
            ? (note == highlightedNotes[0]
            ? Colors.blue.shade700
            : Colors.orange.shade700)
            : Colors.black,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black87),
        boxShadow: const [
          BoxShadow(color: Colors.black54, offset: Offset(1, 3), blurRadius: 3),
        ],
      ),
    );
  }

  Widget _buildIntervalCard(IntervalInfo interval) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(interval.label,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
            const SizedBox(height: 6),
            Text(interval.explanation,
                style: const TextStyle(fontSize: 16, color: Color(0xFF0D47A1))),
            const SizedBox(height: 12),
            _buildMiniKeyboard(selectedRoot, interval.semitones),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _playInterval(selectedRoot, interval.semitones),
                icon: const Icon(Icons.play_arrow),
                label: const Text("Play Interval"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Read Intervals")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose root note:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildToggleBar(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: intervals.length,
                itemBuilder: (context, index) => _buildIntervalCard(intervals[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntervalInfo {
  final String label;
  final int semitones;
  final String explanation;

  IntervalInfo({
    required this.label,
    required this.semitones,
    required this.explanation,
  });
}
