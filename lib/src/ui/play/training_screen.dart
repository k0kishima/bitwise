import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/domain/game_logic.dart';
import 'package:d2b/src/state/problem_type.dart';
import 'package:d2b/src/widgets/binary_input_widget.dart';
import 'package:d2b/src/widgets/decimal_input_widget.dart';
import 'package:d2b/src/widgets/correct_answer_widget.dart';
import 'dart:async';

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  late ProblemAnswerPair currentProblem;
  List<String> values = List.filled(8, '0');
  bool correct = false;
  late ScrollController _scrollController;
  Timer? _timer;
  int totalDuration = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        totalDuration++;
      });
    });

    _generateNewProblem();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _generateNewProblem() {
    final problemType = ref.read(problemTypeProvider);

    GameLogic gameLogic = GameLogicFactory.create(problemType);
    setState(() {
      currentProblem = gameLogic.generateProblems(1).first;
      values = List.filled(8, '0');
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

  @override
  Widget build(BuildContext context) {
    final problemType = ref.watch(problemTypeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Training Mode")),
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
        values: values,
        onToggle: (index) {
          setState(() {
            values[index] = values[index] == '0' ? '1' : '0';
          });
          if (values.join() == currentProblem.answer) {
            _onAnswerSubmitted(currentProblem.answer);
          }
        },
      );
    } else if (problemType == ProblemType.binaryToDecimal) {
      return const DecimalInputWidget();
    } else {
      return const SizedBox.shrink();
    }
  }
}
