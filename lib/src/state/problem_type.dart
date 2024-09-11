import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d2b/src/domain/game_logic.dart';

class ProblemTypeNotifier extends StateNotifier<ProblemType> {
  ProblemTypeNotifier() : super(ProblemType.decimalToBinary);

  void setProblemType(ProblemType type) {
    state = type;
  }
}

final problemTypeProvider =
    StateNotifierProvider<ProblemTypeNotifier, ProblemType>((ref) {
  return ProblemTypeNotifier();
});
