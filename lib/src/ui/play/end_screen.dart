import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EndScreen extends StatelessWidget {
  final List<Duration> answerTimes;

  const EndScreen({super.key, required this.answerTimes});

  @override
  Widget build(BuildContext context) {
    final totalTime = answerTimes.fold(
      Duration.zero,
      (sum, current) => sum + current,
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CongratulationsMessage(),
          const SizedBox(height: 20),
          Text(
            'Total Time: ${totalTime.inSeconds} seconds',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          // 各問題の時間を表示
          Expanded(
            child: ListView.builder(
              itemCount: answerTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Question ${index + 1}'),
                  trailing: Text('${answerTimes[index].inSeconds} seconds'),
                );
              },
            ),
          ),
          const Padding(
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
