import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/ui/settings/setting_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:d2b/src/state/training_mode.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    void showSettingsModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            maxChildSize: 0.8,
            minChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: SettingScreen(),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: showSettingsModal,
          ),
        ],
      ),
      body: Center(
        child: Text(
          l10n.greeting,
          style: theme.textTheme.bodyLarge,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              final isTrainingMode = ref.read(trainingModeProvider);
              if (isTrainingMode) {
                GoRouter.of(context).go('/training');
              } else {
                GoRouter.of(context).go('/play');
              }
            },
            child: Text(l10n.play),
          ),
        ),
      ),
    );
  }
}
