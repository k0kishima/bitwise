import 'package:flutter/material.dart';

class DecimalInputWidget extends StatefulWidget {
  const DecimalInputWidget({super.key});

  @override
  DecimalInputWidgetState createState() => DecimalInputWidgetState();
}

class DecimalInputWidgetState extends State<DecimalInputWidget> {
  String enteredValue = '';

  void _onNumberPressed(String number) {
    setState(() {
      enteredValue += number;
    });
  }

  void _onClearPressed() {
    setState(() {
      enteredValue = '';
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (enteredValue.isNotEmpty) {
        enteredValue = enteredValue.substring(0, enteredValue.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keypadHeight = screenSize.height * 0.4;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Input your answer:',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          enteredValue.isEmpty ? '0' : enteredValue,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        SizedBox(
          height: keypadHeight,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildNumberButton('1'),
                    _buildNumberButton('2'),
                    _buildNumberButton('3'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _buildNumberButton('4'),
                    _buildNumberButton('5'),
                    _buildNumberButton('6'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _buildNumberButton('7'),
                    _buildNumberButton('8'),
                    _buildNumberButton('9'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _buildActionButton('C', _onClearPressed),
                    _buildNumberButton('0'),
                    _buildActionButton('⌫', _onDeletePressed),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onNumberPressed(number),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
        ),
        child: Text(number, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildActionButton(String label, void Function() action) {
    return Expanded(
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
        ),
        child: Text(label, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
