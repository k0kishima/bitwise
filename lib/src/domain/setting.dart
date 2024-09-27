import 'package:d2b/src/domain/game_logic.dart';

class Setting {
  ProblemType problemType;
  int totalQuestions;
  bool trainingMode;

  Setting({
    required this.problemType,
    required this.totalQuestions,
    required this.trainingMode,
  });

  Setting copyWith({
    ProblemType? problemType,
    int? totalQuestions,
    bool? trainingMode,
  }) {
    return Setting(
      problemType: problemType ?? this.problemType,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      trainingMode: trainingMode ?? this.trainingMode,
    );
  }
}
