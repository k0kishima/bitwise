import 'package:flutter/material.dart';
import 'dart:math';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int targetValue = 0;
  List<String> values = List.filled(8, '0');
  bool correct = false;

  @override
  void initState() {
    super.initState();
    _generateTargetValue();
  }

  void _generateTargetValue() {
    setState(() {
      targetValue = Random().nextInt(256);
    });
  }

  void _toggleValue(int index) {
    setState(() {
      values[index] = values[index] == '0' ? '1' : '0';
      int decimalValue = int.parse(values.join(), radix: 2);
      if (decimalValue == targetValue) {
        correct = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            correct = false;
            _generateTargetValue();
            values = List.filled(8, '0');
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          if (!correct)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    targetValue.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: values.asMap().entries.map((entry) {
                      int index = entry.key;
                      String value = entry.value;
                      return GestureDetector(
                        onTap: () => _toggleValue(index),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          color: Colors.grey.shade200,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          if (correct)
            Positioned.fill(
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
            ),
        ],
      ),
    );
  }
}
