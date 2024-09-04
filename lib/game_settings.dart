import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSettings extends StateNotifier<int> {
  GameSettings() : super(10);

  void setTotalQuestions(int value) {
    state = value;
  }
}

final gameSettingsProvider = StateNotifierProvider<GameSettings, int>((ref) {
  return GameSettings();
});
