import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:d2b/src/ui/home/home_screen.dart';
import 'package:d2b/src/ui/play/play_screen.dart';
import 'package:d2b/src/ui/play/training_screen.dart';
import 'package:d2b/src/ui/play/end_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:d2b/src/ui/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return const Locale('en');
        }

        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }

        return const Locale('en');
      },
      theme: AppTheme.theme,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'play',
          builder: (context, state) => const PlayScreen(),
          routes: [
            GoRoute(
              path: 'end',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final questionDetails =
                    extra?['questionDetails'] as List<Map<String, dynamic>>?;
                final totalDuration = extra?['totalDuration'] as int?;

                if (questionDetails == null || totalDuration == null) {
                  return const EndScreen(
                    questionDetails: [],
                    totalDuration: 0,
                  );
                } else {
                  return EndScreen(
                    questionDetails: questionDetails,
                    totalDuration: totalDuration,
                  );
                }
              },
            ),
          ],
        ),
        GoRoute(
          path: 'training',
          builder: (context, state) => const TrainingScreen(),
        ),
      ],
    ),
  ],
);
