import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/game_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalQuestions = ref.watch(gameSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                ref.read(gameSettingsProvider.notifier).setTotalQuestions(value.toInt());
              },
              activeColor: theme.primaryColor,
              inactiveColor: theme.disabledColor,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
                foregroundColor: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
