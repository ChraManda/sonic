import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool goToNextQuestion = true;
  bool chordsSustain = true;
  bool intervalSustain = true;
  bool whenQuestionEnds = false;
  bool crashReports = true;
  bool usageStats = true;
  String selectedKeyboard = "Classic Piano";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("General Settings"),
          _buildKeyboardSelection(),
          _buildSwitchTile("Go To The Next Question", "Manually", goToNextQuestion, (val) {
            setState(() => goToNextQuestion = val);
          }),
          _buildSectionTitle("Audio"),
          _buildSwitchTile("Chords Sustain Mode", "Sustain All Notes", chordsSustain, (val) {
            setState(() => chordsSustain = val);
          }),
          _buildSwitchTile("Interval Sustain Mode", "Sustain All Notes", intervalSustain, (val) {
            setState(() => intervalSustain = val);
          }),
          _buildSwitchTile("When Question Ends", "Do Not Stop The Sound", whenQuestionEnds, (val) {
            setState(() => whenQuestionEnds = val);
          }),
          _buildSectionTitle("Reset"),
          _buildResetButton("Statistics", "Reset Statistics"),
          _buildResetButton("Points And Streak", "Delete All Points And Streak You Obtained"),
          _buildSectionTitle("Confidentiality"),
          _buildSwitchTile("Crash Reports", "Help Us Improve the App", crashReports, (val) {
            setState(() => crashReports = val);
          }),
          _buildSwitchTile("Usage Statistics", "Allow Anonymous Statistics to be sent", usageStats, (val) {
            setState(() => usageStats = val);
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildKeyboardSelection() {
    return ListTile(
      title: const Text("Keyboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(selectedKeyboard, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.settings, color: Colors.black),
        onSelected: (String value) {
          setState(() {
            selectedKeyboard = value;
          });
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: "Classic Piano", child: Text("Classic Piano")),
          const PopupMenuItem(value: "MIDI", child: Text("MIDI")),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFcddc40),
      ),
    );
  }

  Widget _buildResetButton(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      onTap: () {
        _showResetConfirmation(title);
      },
    );
  }

  void _showResetConfirmation(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Reset $title"),
        content: const Text("Are you sure you want to reset?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performReset(title);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _performReset(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$title has been reset.")),
    );
  }
}
