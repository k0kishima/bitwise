import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingModeNotifier extends StateNotifier<bool> {
  TrainingModeNotifier() : super(false);

  void toggleTrainingMode() {
    state = !state;
  }

  void setTrainingMode(bool value) {
    state = value;
  }
}

final trainingModeProvider = StateNotifierProvider<TrainingModeNotifier, bool>((ref) {
  return TrainingModeNotifier();
});
