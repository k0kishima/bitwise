import 'package:flutter/material.dart';

class BinaryInputWidget extends StatelessWidget {
  final int targetValue;
  final List<String> values;
  final void Function(int, List<String>) onToggle;

  const BinaryInputWidget({
    super.key,
    required this.targetValue,
    required this.values,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Target: $targetValue',
            style: const TextStyle(fontSize: 24, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: values.asMap().entries.map((entry) {
              int index = entry.key;
              String value = entry.value;
              return GestureDetector(
                onTap: () {
                  List<String> updatedValues = List.from(values);
                  updatedValues[index] =
                      updatedValues[index] == '0' ? '1' : '0';
                  onToggle(index, updatedValues);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.grey.shade200,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 24, color: Colors.black87),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
