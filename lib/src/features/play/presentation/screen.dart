import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../end/presentation/screen.dart';
import '../../../state/game_settings.dart';
import 'dart:math';

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
    _generateTargetValue();
  }

  void _generateTargetValue() {
    setState(() {
      targetValue = Random().nextInt(256);
    });
  }

  void _toggleValue(int index) {
    final totalQuestions = ref.read(gameSettingsProvider);
    setState(() {
      values[index] = values[index] == '0' ? '1' : '0';
      int decimalValue = int.parse(values.join(), radix: 2);
      if (decimalValue == targetValue) {
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
              _generateTargetValue();
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
              LinearProgressIndicator(
                value: correctAnswers / totalQuestions,
                backgroundColor: Colors.grey.shade300,
                color: Colors.grey.shade600,
              ),
              Expanded(
                child: Stack(
                  children: [
                    if (!correct)
                      Center(
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
                                  onTap: () => _toggleValue(index),
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
                      ),
                    if (correct)
                      Positioned.fill(
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
                      ),
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
