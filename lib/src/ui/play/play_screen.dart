import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/state/game_settings.dart';
import 'package:d2b/src/state/problem_type.dart';
import 'package:d2b/src/domain/game_logic.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:d2b/src/widgets/binary_input_widget.dart';
import 'package:d2b/src/widgets/decimal_input_widget.dart';
import 'package:d2b/src/widgets/correct_answer_widget.dart';

class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key});

  @override
  PlayScreenState createState() => PlayScreenState();
}

class PlayScreenState extends ConsumerState<PlayScreen> {
  List<ProblemAnswerPair> problems = [];
  String currentProblem = '';
  String currentAnswer = '';
  String currentValue = '';
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
    _scrollController = ScrollController();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        totalDuration++;
      });
    });

    startTime = totalDuration;

    _initializeGame();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    final totalQuestions = ref.read(gameSettingsProvider);
    final problemType = ref.read(problemTypeProvider);

    GameLogic gameLogic = GameLogicFactory.create(problemType);
    problems = gameLogic.generateProblems(totalQuestions);

    _setNextProblem();
  }

  void _setNextProblem() {
    if (correctAnswers < problems.length) {
      setState(() {
        currentProblem = problems[correctAnswers].problem;
        currentAnswer = problems[correctAnswers].answer;
        currentValue = '0' * 8;
        correct = false;
      });
    }
  }

  void _onAnswerSubmitted(String answer) {
    final totalQuestions = ref.read(gameSettingsProvider);

    if (answer == currentAnswer) {
      setState(() {
        correct = true;
        correctAnswers += 1;

        int questionTime = totalDuration - startTime;
        double percentage = (questionTime / totalDuration) * 100;

        questionDetails.add({
          'question': currentProblem,
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
              startTime = totalDuration;
              _setNextProblem();
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = ref.watch(gameSettingsProvider);
    final problemType = ref.watch(problemTypeProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ProgressBarWidget(
              correctAnswers: correctAnswers, totalQuestions: totalQuestions),
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
        targetValue: int.parse(currentProblem),
        values: currentValue.split(''),
        onToggle: (index, newValues) {
          setState(() {
            currentValue = newValues.join();
            if (currentValue == currentAnswer) {
              _onAnswerSubmitted(currentAnswer);
            }
          });
        },
      );
    } else if (problemType == ProblemType.binaryToDecimal) {
      return DecimalInputWidget(
        binaryProblem: currentProblem,
        onSubmit: _onAnswerSubmitted,
      );
    } else {
      return const SizedBox.shrink();
    }
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
