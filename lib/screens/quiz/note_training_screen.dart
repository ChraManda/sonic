import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:sonic/models/question_model.dart';
import 'package:sonic/providers/quiz_session_provider.dart';
import 'package:sonic/providers/answer_provider.dart';

import '../../models/response_model.dart';
import '../../providers/statistics_provider.dart';
import '../../providers/user.dart';
import '../../reusable_widgets/reusable_widgets.dart';

class NoteTrainingScreen extends StatefulWidget {
  const NoteTrainingScreen({super.key});

  @override
  State<NoteTrainingScreen> createState() => _NoteTrainingScreenState();
}

class _NoteTrainingScreenState extends State<NoteTrainingScreen> {
  final AudioPlayer _player = AudioPlayer(); // Shared player
  final Map<String, AudioSource> _preloadedSources = {}; // Cached AudioSource
  bool isPreloading = true;

  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool isAnswerChecked = false;
  bool isQuizCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _preloadAllSounds();
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _preloadedSources.clear();
    super.dispose();
  }

  Future<void> _preloadAllSounds() async {
    final quizProvider = Provider.of<QuizSessionProvider>(context, listen: false);
    final questions = quizProvider.questions;

    for (final question in questions) {
      // Preload question sound
      final qSound = question.correctAnswerSound;
      if (qSound != null && !_preloadedSources.containsKey(qSound)) {
        try {
          final file = await DefaultCacheManager().getSingleFile(qSound);
          _preloadedSources[qSound] = AudioSource.file(file.path);
        } catch (e) {
          debugPrint("Error caching question sound: $e");
        }
      }

      // Preload option sounds
      for (final option in question.options ?? []) {
        final oSound = option.sound;
        if (oSound != null && !_preloadedSources.containsKey(oSound)) {
          try {
            final file = await DefaultCacheManager().getSingleFile(oSound);
            _preloadedSources[oSound] = AudioSource.file(file.path);
          } catch (e) {
            debugPrint("Error caching option sound: $e");
          }
        }
      }
    }

    setState(() => isPreloading = false);
    _autoPlayCurrentQuestionSound(); // auto-play first question
  }

  Future<void> _playSound(String? soundUrl) async {
    if (soundUrl == null || !_preloadedSources.containsKey(soundUrl)) return;

    try {
      final source = _preloadedSources[soundUrl]!;

      await _player.setAudioSource(source);
      await _player.seek(Duration.zero); // Always start from beginning
      await _player.play();
    } catch (e) {
      debugPrint("Audio play error: $e");
    }
  }

  Future<void> _autoPlayCurrentQuestionSound() async {
    final quizProvider = Provider.of<QuizSessionProvider>(context, listen: false);
    final questions = quizProvider.questions;

    if (questions.isNotEmpty) {
      final sound = questions[currentQuestionIndex].correctAnswerSound;
      if (sound != null) await _playSound(sound);
    }
  }

  Future<void> _checkAnswer() async {
    if (selectedOptionIndex == null || isAnswerChecked) return;

    final quizProvider = context.read<QuizSessionProvider>();
    final answerProvider = context.read<AnswerProvider>();
    final question = quizProvider.questions[currentQuestionIndex];
    final isCorrect = selectedOptionIndex == question.correctOptionIndex;

    final response = ResponseModel(
      question: question,
      selectedOptionIndex: selectedOptionIndex!,
      isCorrect: isCorrect,
      score: isCorrect ? 10 : 0,
    );

    await answerProvider.submitAnswerToBackend(
      quizId: quizProvider.currentSession!.quizId,
      questionId: question.id,
      responseModel: response,
    );

    quizProvider.answerQuestion(
      question: question,
      selectedIndex: selectedOptionIndex!,
      score: isCorrect ? 10 : 0,
    );

    setState(() => isAnswerChecked = true);
  }

  Future<void> _nextQuestion() async {
    final quizProvider = context.read<QuizSessionProvider>();
    final statisticsProvider = context.read<StatisticsProvider>();
    if (currentQuestionIndex < quizProvider.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        isAnswerChecked = false;
      });
      await Future.delayed(const Duration(milliseconds: 200));
      _autoPlayCurrentQuestionSound();
    } else {
      await quizProvider.submitSession();
      await Provider.of<UserProvider>(context, listen: false)
          .fetchUserInfo();
      await statisticsProvider.fetchStatistics();
      setState(() => isQuizCompleted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizSessionProvider>();
    final questions = quizProvider.questions;

    if (isPreloading || questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentQuestionIndex];
    final totalQuestions = questions.length;
    final currentPoints = quizProvider.currentSession?.score ?? 0;

    final correctImage = question.correctAnswerImg;
    final hasValidSelection = selectedOptionIndex != null &&
        (question.options?.length ?? 0) > selectedOptionIndex!;
    final selectedImage = hasValidSelection
        ? question.options![selectedOptionIndex!].image
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ear Training Quiz"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isQuizCompleted
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.celebration, size: 64, color: Colors.lime),
              const SizedBox(height: 20),
              const Text("Quiz Completed!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("You scored $currentPoints points", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 30),
              CustomButton(
                label: "Back to Home",
                onTap: () => Navigator.of(context).pop(),
                color: const Color(0xFFcddc40),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / totalQuestions,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.lime),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Question ${currentQuestionIndex + 1} of $totalQuestions",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Points: $currentPoints", style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    question.questionText ?? "Which note is this?",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: _autoPlayCurrentQuestionSound,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                correctImage != null && correctImage.isNotEmpty
                    ? Image.network(correctImage, height: 150, width: 140, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported, size: 60),
                selectedImage != null && selectedImage.isNotEmpty
                    ? Image.network(selectedImage, height: 150, width: 140, fit: BoxFit.cover)
                    : const Icon(Icons.touch_app_outlined, size: 60),
              ],
            ),
            const SizedBox(height: 50),
            ...List.generate(question.options?.length ?? 0, (index) {
              final option = question.options?[index];
              if (option == null) return const SizedBox.shrink();

              final isSelected = selectedOptionIndex == index;
              final isCorrect = question.correctOptionIndex == index;

              Color? tileColor;
              if (isAnswerChecked) {
                if (isSelected && isCorrect) {
                  tileColor = Colors.green.shade300;
                } else if (isSelected && !isCorrect) {
                  tileColor = Colors.red.shade300;
                } else if (isCorrect) {
                  tileColor = Colors.green.shade100;
                }
              } else if (isSelected) {
                tileColor = Colors.grey.shade300;
              }

              return Card(
                color: tileColor,
                child: ListTile(
                  title: Text(option.note ?? "Note"),
                  onTap: () {
                    _playSound(option.sound);
                    if (!isAnswerChecked) {
                      setState(() {
                        selectedOptionIndex = index;
                      });
                    }
                  },
                ),
              );
            }),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isAnswerChecked)
                  CustomButton(
                    label: "Check",
                    onTap: () {
                      if (selectedOptionIndex != null) _checkAnswer();
                    },
                    color: const Color(0xFFcddc40),
                  )
                else
                  CustomButton(
                    label: currentQuestionIndex < totalQuestions - 1 ? "Next" : "Finish",
                    onTap: _nextQuestion,
                    color: const Color(0xFFcddc40),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
