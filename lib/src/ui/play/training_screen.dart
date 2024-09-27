import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/domain/game_logic.dart';
import 'package:d2b/src/providers/setting.dart';
import 'package:d2b/src/widgets/binary_input_widget.dart';
import 'package:d2b/src/widgets/decimal_input_widget.dart';
import 'package:d2b/src/widgets/correct_answer_widget.dart';
import 'dart:async';

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  TrainingScreenState createState() => TrainingScreenState();
}

class TrainingScreenState extends ConsumerState<TrainingScreen> {
  late ProblemAnswerPair currentProblem;
  String currentValue = '';
  bool correct = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateNewProblem();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _generateNewProblem() {
    final problemType = ref.read(settingProvider).problemType;

    GameLogic gameLogic = GameLogicFactory.create(problemType);
    setState(() {
      currentProblem = gameLogic.generateProblems(1).first;
      currentValue = '0' * 8;
      correct = false;
    });
  }

  void _onAnswerSubmitted(String answer) {
    if (answer == currentProblem.answer) {
      setState(() {
        correct = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          _generateNewProblem();
        });
      });
    }
  }

  void _showHalfModal(BuildContext context) {
    int targetScrollValue;

    if (ref.read(settingProvider).problemType == ProblemType.binaryToDecimal) {
      targetScrollValue = int.parse(currentProblem.problem, radix: 2);
    } else {
      targetScrollValue = int.parse(currentProblem.problem);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CheatSheetWidget(
          targetValue: targetScrollValue,
          scrollController: _scrollController,
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        targetScrollValue * 40.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final problemType = ref.watch(settingProvider).problemType;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () => _showHalfModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (!correct) _buildInputWidget(problemType),
                if (correct) const CorrectAnswerWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputWidget(ProblemType problemType) {
    if (problemType == ProblemType.decimalToBinary) {
      return BinaryInputWidget(
        targetValue: int.parse(currentProblem.problem),
        values: currentValue.split(''),
        onToggle: (index, newValues) {
          setState(() {
            currentValue = newValues.join();
            if (currentValue == currentProblem.answer) {
              _onAnswerSubmitted(currentProblem.answer);
            }
          });
        },
      );
    } else if (problemType == ProblemType.binaryToDecimal) {
      return DecimalInputWidget(
        binaryProblem: currentProblem.problem,
        onSubmit: _onAnswerSubmitted,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class CheatSheetWidget extends StatelessWidget {
  final int targetValue;
  final ScrollController scrollController;

  const CheatSheetWidget({
    super.key,
    required this.targetValue,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Cheat Sheet',
              style: TextStyle(fontSize: 24, color: Colors.black87),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: 256,
              itemBuilder: (context, index) {
                return Container(
                  color: index == targetValue
                      ? Colors.grey.shade300.withOpacity(0.5)
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('$index',
                            style: const TextStyle(color: Colors.black87)),
                        Text(
                          index.toRadixString(2).padLeft(8, '0'),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
