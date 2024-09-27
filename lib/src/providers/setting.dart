import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/domain/setting.dart';
import 'package:d2b/src/domain/game_logic.dart';

class SettingNotifier extends StateNotifier<Setting> {
  SettingNotifier()
      : super(Setting(
          problemType: ProblemType.decimalToBinary,
          totalQuestions: 10,
          trainingMode: false,
        ));

  void setProblemType(ProblemType type) {
    state = state.copyWith(problemType: type);
  }

  void setTotalQuestions(int value) {
    state = state.copyWith(totalQuestions: value);
  }

  void setTrainingMode(bool value) {
    state = state.copyWith(trainingMode: value);
  }

  void toggleTrainingMode() {
    state = state.copyWith(trainingMode: !state.trainingMode);
  }
}

final settingProvider = StateNotifierProvider<SettingNotifier, Setting>((ref) {
  return SettingNotifier();
});
