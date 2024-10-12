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
        const SizedBox(height: 50),
        Text(
          widget.binaryProblem,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          currentValue.isEmpty ? '0' : currentValue,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: keypadHeight,
          child: Column(
            children: [
              _buildKeypadRow(['1', '2', '3']),
              _buildKeypadRow(['4', '5', '6']),
              _buildKeypadRow(['7', '8', '9']),
              _buildKeypadRow(['C', '0', '⌫']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Expanded(
      child: Row(
        children: keys.map((key) {
          if (key == 'C') {
            return _buildActionButton(key, _onClearPressed);
          } else if (key == '⌫') {
            return _buildActionButton(key, _onDeletePressed);
          } else {
            return _buildNumberButton(key);
          }
        }).toList(),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: TextButton(
            onPressed: () => _onNumberPressed(number),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(number, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, void Function() action) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: TextButton(
            onPressed: action,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(label, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }
}
