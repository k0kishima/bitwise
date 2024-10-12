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
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final keypadHeight = screenSize.height * 0.4;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Text(
          widget.binaryProblem,
          style: theme.textTheme.headlineMedium,
        ),
        const Spacer(),
        Text(
          currentValue.isEmpty ? '0' : currentValue,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: keypadHeight,
          child: _buildKeypad(theme),
        ),
      ],
    );
  }

  Widget _buildKeypad(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3'], theme),
          _buildKeypadRow(['4', '5', '6'], theme),
          _buildKeypadRow(['7', '8', '9'], theme),
          _buildKeypadRow(['C', '0', '⌫'], theme),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys, ThemeData theme) {
    return Expanded(
      child: Row(
        children: keys.map((key) {
          if (key == 'C') {
            return _buildActionButton(key, _onClearPressed, theme);
          } else if (key == '⌫') {
            return _buildActionButton(key, _onDeletePressed, theme);
          } else {
            return _buildNumberButton(key, theme);
          }
        }).toList(),
      ),
    );
  }

  Widget _buildNumberButton(String number, ThemeData theme) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: theme.dividerColor, width: 1),
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
              foregroundColor: theme.colorScheme.onSurface,
            ),
            child: Text(number, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, void Function() action, ThemeData theme) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          border: Border.all(color: theme.dividerColor, width: 1),
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
              foregroundColor: theme.colorScheme.onSecondaryContainer,
            ),
            child: Text(label, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }
}
