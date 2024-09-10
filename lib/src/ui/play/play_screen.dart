import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/state/game_settings.dart';
import 'package:d2b/src/domain/game_logic.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:d2b/src/widgets/binary_input_widget.dart';
import 'package:d2b/src/widgets/correct_answer_widget.dart';

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
  List<Map<String, dynamic>> questionDetails = [];

  late ScrollController _scrollController;
  Timer? _timer;
  int startTime = 0;
  int totalDuration = 0;

  @override
  void initState() {
    super.initState();
    targetValue = GameLogic.generateTargetValue();
    _scrollController = ScrollController();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        totalDuration++;
      });
    });

    startTime = totalDuration;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _toggleValue(int index) {
    final totalQuestions = ref.read(gameSettingsProvider);
    setState(() {
      values[index] = values[index] == '0' ? '1' : '0';
      if (GameLogic.isAnswerCorrect(values, targetValue)) {
        correct = true;
        correctAnswers += 1;

        int questionTime = totalDuration - startTime;
        double percentage = (questionTime / totalDuration) * 100;

        questionDetails.add({
          'question': targetValue.toString(),
          'time': questionTime,
          'percentage': percentage.toStringAsFixed(2),
        });

        if (correctAnswers >= totalQuestions) {
          GoRouter.of(context).go('/play/end', extra: {
            'totalDuration': totalDuration,
            'questionDetails': questionDetails,
          });
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              correct = false;
              targetValue = GameLogic.generateTargetValue();
              values = List.filled(8, '0');
              startTime = totalDuration;
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
      appBar: AppBar(title: const Text("Play Mode")),
      body: Column(
        children: [
          ProgressBarWidget(
              correctAnswers: correctAnswers, totalQuestions: totalQuestions),
          Expanded(
            child: Stack(
              children: [
                if (!correct)
                  BinaryInputWidget(
                    targetValue: targetValue,
                    values: values,
                    onToggle: (index) => _toggleValue(index),
                  ),
                if (correct) const CorrectAnswerWidget(),
              ],
            ),
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
