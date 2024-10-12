import 'package:flutter/material.dart';

class CorrectAnswerWidget extends StatelessWidget {
  const CorrectAnswerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: Center(
        child: Icon(
          Icons.check,
          size: 100,
          color: Colors.green,
        ),
      ),
    );
  }
}
