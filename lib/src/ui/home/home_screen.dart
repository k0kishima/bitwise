import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/ui/home/setting_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:d2b/src/providers/setting.dart';

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
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: SettingPanel(),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          l10n.greeting,
          style: theme.textTheme.bodyLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final isTrainingMode = ref.read(settingProvider).trainingMode;
          if (isTrainingMode) {
            GoRouter.of(context).go('/training');
          } else {
            GoRouter.of(context).go('/play');
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: showSettingsModal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
