import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/providers/setting.dart';
import 'package:d2b/src/domain/game_logic.dart';

class SettingPanel extends ConsumerWidget {
  const SettingPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingProvider);

    double modalHeight = MediaQuery.of(context).size.height * 0.6;
    double modalWidth = MediaQuery.of(context).size.width;

    return Container(
      height: modalHeight,
      width: modalWidth,
      padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      child: Column(
        children: [
          _TrainingModeSwitch(
            isTrainingMode: settings.trainingMode,
            onChanged: (bool value) {
              ref.read(settingProvider.notifier).setTrainingMode(value);
            },
          ),
          const SizedBox(height: 20),
          _ProblemTypeSelector(
            problemType: settings.problemType,
            onSelected: (ProblemType type) {
              ref.read(settingProvider.notifier).setProblemType(type);
            },
          ),
          const SizedBox(height: 20),
          _SettingsSlider(
            isTrainingMode: settings.trainingMode,
            totalQuestions: settings.totalQuestions,
            onChanged: (int value) {
              ref.read(settingProvider.notifier).setTotalQuestions(value);
            },
          ),
        ],
      ),
    );
  }
}

class _TrainingModeSwitch extends StatelessWidget {
  final bool isTrainingMode;
  final ValueChanged<bool> onChanged;

  const _TrainingModeSwitch({
    required this.isTrainingMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Training Mode',
          style: TextStyle(fontSize: 18),
        ),
        Switch(
          value: isTrainingMode,
          onChanged: onChanged,
          activeTrackColor: Colors.grey.shade800,
          activeColor: Colors.black,
          inactiveTrackColor: Colors.grey.shade300,
          inactiveThumbColor: Colors.grey.shade600,
        ),
      ],
    );
  }
}

class _ProblemTypeSelector extends StatelessWidget {
  final ProblemType problemType;
  final ValueChanged<ProblemType> onSelected;

  const _ProblemTypeSelector({
    required this.problemType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Problem Type',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChoiceChip(
              label: const Text('10 → 2'),
              selected: problemType == ProblemType.decimalToBinary,
              onSelected: (bool selected) {
                if (selected) {
                  onSelected(ProblemType.decimalToBinary);
                }
              },
            ),
            ChoiceChip(
              label: const Text('2 → 10'),
              selected: problemType == ProblemType.binaryToDecimal,
              onSelected: (bool selected) {
                if (selected) {
                  onSelected(ProblemType.binaryToDecimal);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsSlider extends StatelessWidget {
  final bool isTrainingMode;
  final int totalQuestions;
  final ValueChanged<int> onChanged;

  const _SettingsSlider({
    required this.isTrainingMode,
    required this.totalQuestions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isTrainingMode) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Questions',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Slider(
          value: totalQuestions.toDouble(),
          min: 5,
          max: 20,
          divisions: 15,
          label: totalQuestions.toString(),
          onChanged: (double value) {
            onChanged(value.toInt());
          },
          activeColor: theme.primaryColor,
          inactiveColor: theme.disabledColor,
        ),
      ],
    );
  }
}
