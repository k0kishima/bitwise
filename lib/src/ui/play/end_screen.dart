import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: CongratulationsMessage(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: HomeButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class CongratulationsMessage extends StatelessWidget {
  const CongratulationsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Congratulations!',
      style: TextStyle(fontSize: 24),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey.shade600,
      side: BorderSide(color: Colors.grey.shade400, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );

    return ElevatedButton(
      onPressed: () {
        GoRouter.of(context).go('/');
      },
      style: buttonStyle,
      child: const Text('Home'),
    );
  }
}
