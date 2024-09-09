import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({
    super.key,
    required this.questionDetails,
    required this.totalDuration,
  });

  final List<Map<String, dynamic>> questionDetails;
  final int totalDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'トータル: $totalDuration秒',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: questionDetails.map((question) {
                    final questionText = question['question'];
                    final timeTaken = question['time'];
                    final percentage = (timeTaken / totalDuration) * 100;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '問題 $questionTextの変換',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$timeTaken 秒',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${percentage.toStringAsFixed(2)}%',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          _buildHorizontalBarChart(percentage),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
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

  Widget _buildHorizontalBarChart(double percentage) {
    return SizedBox(
      height: 20,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 1,
                  width: percentage,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ],
          alignment: BarChartAlignment.spaceBetween,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          maxY: 1,
        ),
      ),
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
      side: const BorderSide(color: Colors.grey, width: 1),
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
