import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:d2b/src/features/home/presentation/screen.dart';

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
    const baseTextStyle = TextStyle(color: Colors.black54);

    return MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      locale: const Locale('ja', ''),
      theme: ThemeData(
        primaryColor: Colors.black87,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey.shade600,
            side: BorderSide(color: Colors.grey.shade400, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: baseTextStyle,
          bodyMedium: baseTextStyle,
          bodySmall: baseTextStyle,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
