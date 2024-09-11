import 'dart:math';

enum ProblemType {
  decimalToBinary,
  binaryToDecimal,
}

class GameLogic {
  static int generateTargetValue() {
    return Random().nextInt(256);
  }

  static bool isAnswerCorrect(List<String> values, int targetValue) {
    int decimalValue = int.parse(values.join(), radix: 2);
    return decimalValue == targetValue;
  }
}
