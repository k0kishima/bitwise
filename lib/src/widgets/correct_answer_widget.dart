import 'package:flutter/material.dart';

class CorrectAnswerWidget extends StatelessWidget {
  const CorrectAnswerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.9),
            ),
            child: const Icon(
              Icons.check,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
