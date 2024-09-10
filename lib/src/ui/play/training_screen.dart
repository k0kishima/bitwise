import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/domain/game_logic.dart';
import 'package:d2b/src/widgets/binary_input_widget.dart';
import 'package:d2b/src/widgets/correct_answer_widget.dart';
import 'dart:async';

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  int targetValue = 0;
  List<String> values = List.filled(8, '0');
  bool correct = false;
  late ScrollController _scrollController;
  Timer? _timer;
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _toggleValue(int index) {
    setState(() {
      values[index] = values[index] == '0' ? '1' : '0';
      if (GameLogic.isAnswerCorrect(values, targetValue)) {
        correct = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            correct = false;
            targetValue = GameLogic.generateTargetValue();
            values = List.filled(8, '0');
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Training Mode")),
      body: Column(
        children: [
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
