import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/ui/play/end_screen.dart';
import 'package:d2b/src/state/game_settings.dart';
import 'package:d2b/src/domain/game_logic.dart';

class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  int targetValue = 0;
  List<String> values = List.filled(8, '0');
  bool correct = false;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    targetValue = GameLogic.generateTargetValue();
  }

  void _toggleValue(int index) {
    final totalQuestions = ref.read(gameSettingsProvider);
    setState(() {
      values[index] = values[index] == '0' ? '1' : '0';
      if (GameLogic.isAnswerCorrect(values, targetValue)) {
        correct = true;
        correctAnswers += 1;
        if (correctAnswers >= totalQuestions) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const EndScreen()),
            );
          });
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              correct = false;
              targetValue = GameLogic.generateTargetValue();
              values = List.filled(8, '0');
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = ref.watch(gameSettingsProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              ProgressBarWidget(
                  correctAnswers: correctAnswers,
                  totalQuestions: totalQuestions),
              Expanded(
                child: Stack(
                  children: [
                    if (!correct)
                      BinaryInputWidget(
                        targetValue: targetValue,
                        values: values,
                        onToggle: _toggleValue,
                      ),
                    if (correct) const CorrectAnswerWidget(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressBarWidget extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const ProgressBarWidget({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: correctAnswers / totalQuestions,
      backgroundColor: Colors.grey.shade300,
      color: Colors.grey.shade600,
    );
  }
}

class BinaryInputWidget extends StatelessWidget {
  final int targetValue;
  final List<String> values;
  final void Function(int) onToggle;

  const BinaryInputWidget({
    super.key,
    required this.targetValue,
    required this.values,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            targetValue.toString(),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: values.asMap().entries.map((entry) {
              int index = entry.key;
              String value = entry.value;
              return GestureDetector(
                onTap: () => onToggle(index),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.grey.shade200,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class CorrectAnswerWidget extends StatelessWidget {
  const CorrectAnswerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.9),
            ),
            child: const Icon(
              Icons.check,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
