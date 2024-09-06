import 'package:flutter/material.dart';
import 'package:d2b/src/features/play/presentation/screen.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Congratulations!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: buttonStyle,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Home'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const PlayScreen()),
                    );
                  },
                  style: buttonStyle,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Replay'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
