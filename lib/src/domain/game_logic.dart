import 'dart:math';

enum ProblemType {
  decimalToBinary,
  binaryToDecimal,
}

class ProblemAnswerPair {
  final String problem;
  final String answer;

  ProblemAnswerPair(this.problem, this.answer);
}

abstract class ProblemStrategy {
  ProblemAnswerPair generateProblem();
}

class DecimalToBinaryStrategy implements ProblemStrategy {
  @override
  ProblemAnswerPair generateProblem() {
    int targetValue = Random().nextInt(256);
    String problem = targetValue.toString();
    String answer = targetValue.toRadixString(2).padLeft(8, '0');
    return ProblemAnswerPair(problem, answer);
  }
}

class BinaryToDecimalStrategy implements ProblemStrategy {
  @override
  ProblemAnswerPair generateProblem() {
    int targetValue = Random().nextInt(256);
    String problem = targetValue.toRadixString(2).padLeft(8, '0');
    String answer = targetValue.toString();
    return ProblemAnswerPair(problem, answer);
  }
}

class GameLogic {
  final ProblemStrategy _strategy;

  GameLogic(this._strategy);

  List<ProblemAnswerPair> generateProblems(int numberOfProblems) {
    List<ProblemAnswerPair> problems = [];
    for (int i = 0; i < numberOfProblems; i++) {
      problems.add(_strategy.generateProblem());
    }
    return problems;
  }
}

class GameLogicFactory {
  static GameLogic create(ProblemType problemType) {
    switch (problemType) {
      case ProblemType.decimalToBinary:
        return GameLogic(DecimalToBinaryStrategy());
      case ProblemType.binaryToDecimal:
        return GameLogic(BinaryToDecimalStrategy());
      default:
        throw Exception("Unknown ProblemType");
    }
  }
}
