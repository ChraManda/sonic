import 'package:flutter/material.dart';
import 'package:sonic/reusable_widgets/reusable_widgets.dart';
class ReadIntervalsScreen extends StatefulWidget {
  const ReadIntervalsScreen({super.key});

  @override
  State<ReadIntervalsScreen> createState() => _ReadIntervalsScreenState();
}

class _ReadIntervalsScreenState extends State<ReadIntervalsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: popButton(context),
        title: const Text(
          "Read Intervals",
          style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0D47A1)),
        ),
      ),
    );
  }
}
