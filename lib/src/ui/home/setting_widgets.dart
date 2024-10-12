import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/providers/setting.dart';
import 'package:d2b/src/domain/game_logic.dart';

class SettingPanel extends ConsumerWidget {
  const SettingPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingProvider);
    final theme = Theme.of(context);

    double modalHeight = MediaQuery.of(context).size.height * 0.6;
    double modalWidth = MediaQuery.of(context).size.width;

    return Container(
      height: modalHeight,
      width: modalWidth,
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('設定', style: theme.textTheme.titleMedium),
          ),
          _buildSection(
            context: context,
            title: 'Training Mode',
            child: _TrainingModeSwitch(
              isTrainingMode: settings.trainingMode,
              onChanged: (value) {
                ref.read(settingProvider.notifier).setTrainingMode(value);
              },
            ),
          ),
          Divider(color: theme.dividerColor),
          _buildSection(
            context: context,
            title: 'Problem Type',
            child: _ProblemTypeSelector(
              problemType: settings.problemType,
              onSelected: (type) {
                ref.read(settingProvider.notifier).setProblemType(type);
              },
            ),
          ),
          Divider(color: theme.dividerColor),
          if (!settings.trainingMode)
            _buildSection(
              context: context,
              title: 'Number of Questions',
              child: _SettingsSlider(
                isTrainingMode: settings.trainingMode,
                totalQuestions: settings.totalQuestions,
                onChanged: (value) {
                  ref.read(settingProvider.notifier).setTotalQuestions(value);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall,
          ),
          child,
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
    return Switch(
      value: isTrainingMode,
      onChanged: onChanged,
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
    return Row(
      children: [
        ChoiceChip(
          label: const Text('10 → 2'),
          selected: problemType == ProblemType.decimalToBinary,
          onSelected: (selected) {
            if (selected) onSelected(ProblemType.decimalToBinary);
          },
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('2 → 10'),
          selected: problemType == ProblemType.binaryToDecimal,
          onSelected: (selected) {
            if (selected) onSelected(ProblemType.binaryToDecimal);
          },
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

    return Slider(
      value: totalQuestions.toDouble(),
      min: 5,
      max: 20,
      divisions: 15,
      label: totalQuestions.toString(),
      onChanged: (value) {
        onChanged(value.toInt());
      },
      activeColor: theme.primaryColor,
      inactiveColor: theme.disabledColor,
    );
  }
}
