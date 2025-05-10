import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widgets.dart';

class ReadNotesScreen extends StatefulWidget {
  const ReadNotesScreen({super.key});

  @override
  State<ReadNotesScreen> createState() => _ReadNotesScreenState();
}

class _ReadNotesScreenState extends State<ReadNotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: popButton(context),
        title: const Text(
          "Read Notes",
          style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0D47A1)),
        ),
      ),
    );
  }
}
