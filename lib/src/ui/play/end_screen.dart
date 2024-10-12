import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final l10n = L10n.of(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              l10n.totalDurationLabel(totalDuration),
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
                            l10n.questionConversion(questionText),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.timeTakenLabel(timeTaken),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.percentageLabel(percentage.toStringAsFixed(2)),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).replace('/play', extra: UniqueKey());
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  GoRouter.of(context).go('/');
                },
              ),
            ],
          ),
        ),
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
                  color: Colors.grey.shade600,
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
