import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/state/game_settings.dart';
import 'package:d2b/src/state/training_mode.dart';
import 'package:d2b/src/domain/game_logic.dart';
import 'package:go_router/go_router.dart';

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

  late ScrollController _scrollController;

  late DateTime startTime;
  List<Duration> answerTimes = [];

  @override
  void initState() {
    super.initState();
    targetValue = GameLogic.generateTargetValue();
    _scrollController = ScrollController();
    startTime = DateTime.now();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleValue(int index, bool isTrainingMode) {
    if (!isTrainingMode) {
      final totalQuestions = ref.read(gameSettingsProvider);
      setState(() {
        values[index] = values[index] == '0' ? '1' : '0';
        if (GameLogic.isAnswerCorrect(values, targetValue)) {
          correct = true;
          answerTimes.add(DateTime.now().difference(startTime));

          correctAnswers += 1;
          if (correctAnswers >= totalQuestions) {
            GoRouter.of(context).go('/play/end', extra: answerTimes);
          } else {
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                correct = false;
                targetValue = GameLogic.generateTargetValue();
                values = List.filled(8, '0');
                startTime = DateTime.now();
              });
            });
          }
        }
      });
    } else {
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
  }

  void _showHalfModal(BuildContext context, bool isTrainingMode) {
    if (isTrainingMode) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return CheatSheetWidget(
            targetValue: targetValue,
            scrollController: _scrollController,
          );
        },
      );

      Future.delayed(const Duration(milliseconds: 200), () {
        _scrollController.animateTo(
          targetValue * 40.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = ref.watch(gameSettingsProvider);
    final isTrainingMode = ref.watch(trainingModeProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              if (!isTrainingMode)
                ProgressBarWidget(
                  correctAnswers: correctAnswers,
                  totalQuestions: totalQuestions,
                ),
              Expanded(
                child: Stack(
                  children: [
                    if (!correct)
                      BinaryInputWidget(
                        targetValue: targetValue,
                        values: values,
                        onToggle: (index) =>
                            _toggleValue(index, isTrainingMode),
                      ),
                    if (correct) const CorrectAnswerWidget(),
                  ],
                ),
              ),
            ],
          ),
          if (isTrainingMode)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => _showHalfModal(context, isTrainingMode),
                backgroundColor: Colors.grey.shade800,
                child: const Icon(
                  Icons.visibility,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
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
            style: const TextStyle(fontSize: 24, color: Colors.black87),
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
                    style: const TextStyle(fontSize: 24, color: Colors.black87),
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
