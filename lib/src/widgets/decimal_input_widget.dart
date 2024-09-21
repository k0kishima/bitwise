import 'package:flutter/material.dart';

class DecimalInputWidget extends StatefulWidget {
  final String binaryProblem;
  final void Function(String) onSubmit;

  const DecimalInputWidget({
    super.key,
    required this.binaryProblem,
    required this.onSubmit,
  });

  @override
  DecimalInputWidgetState createState() => DecimalInputWidgetState();
}

class DecimalInputWidgetState extends State<DecimalInputWidget> {
  String currentValue = '';

  void _onNumberPressed(String number) {
    setState(() {
      currentValue += number;
    });
    _submitIfComplete();
  }

  void _onClearPressed() {
    setState(() {
      currentValue = '';
    });
    _submitIfComplete();
  }

  void _onDeletePressed() {
    setState(() {
      if (currentValue.isNotEmpty) {
        currentValue = currentValue.substring(0, currentValue.length - 1);
      }
    });
    _submitIfComplete();
  }

  void _submitIfComplete() {
    widget.onSubmit(currentValue);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keypadHeight = screenSize.height * 0.4;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Convert the binary number:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          widget.binaryProblem,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          currentValue.isEmpty ? '0' : currentValue,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
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
