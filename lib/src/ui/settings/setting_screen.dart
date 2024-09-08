import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/state/game_settings.dart';
import 'package:d2b/src/state/training_mode.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.primaryColor,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SettingsSliderWidget(),
            SizedBox(height: 20),
            TrainingModeSwitch(),
            Spacer(),
            SaveSettingsButton(),
          ],
        ),
      ),
    );
  }
}

class SettingsSliderWidget extends ConsumerWidget {
  const SettingsSliderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalQuestions = ref.watch(gameSettingsProvider);

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
            ref
                .read(gameSettingsProvider.notifier)
                .setTotalQuestions(value.toInt());
          },
          activeColor: theme.primaryColor,
          inactiveColor: theme.disabledColor,
        ),
      ],
    );
  }
}

class TrainingModeSwitch extends ConsumerWidget {
  const TrainingModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTrainingMode = ref.watch(trainingModeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Training Mode',
          style: TextStyle(fontSize: 18),
        ),
        Switch(
          value: isTrainingMode,
          onChanged: (bool value) {
            ref.read(trainingModeProvider.notifier).setTrainingMode(value);
          },
          activeTrackColor: Colors.grey.shade800,
          activeColor: Colors.black,
          inactiveTrackColor: Colors.grey.shade300,
          inactiveThumbColor: Colors.grey.shade600,
        ),
      ],
    );
  }
}

class SaveSettingsButton extends StatelessWidget {
  const SaveSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          foregroundColor:
              theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text('Save Settings'),
      ),
    );
  }
}
