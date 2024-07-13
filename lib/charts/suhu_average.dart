import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Background color
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            padding: const EdgeInsets.all(10), // Padding around the chart
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text('Mingguan', style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [
                          BarChartRodData(
                              toY: 10, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(
                              toY: 10, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(
                              toY: 14, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(
                              toY: 15, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 4, barRods: [
                          BarChartRodData(
                              toY: 13, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 5, barRods: [
                          BarChartRodData(
                              toY: 10, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 6, barRods: [
                          BarChartRodData(
                              toY: 14, color: Colors.blue, width: 15)
                        ]),
                      ],
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ), // Hide left titles
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ), // Hide top titles
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = const Text('S', style: style);
                                  break;
                                case 1:
                                  text = const Text('S', style: style);
                                  break;
                                case 2:
                                  text = const Text('R', style: style);
                                  break;
                                case 3:
                                  text = const Text('K', style: style);
                                  break;
                                case 4:
                                  text = const Text('J', style: style);
                                  break;
                                case 5:
                                  text = const Text('S', style: style);
                                  break;
                                case 6:
                                  text = const Text('M', style: style);
                                  break;
                                default:
                                  text = const Text('', style: style);
                                  break;
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 4, // Space between bar and title
                                child: text,
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
            height: 10), // Space between the chart and the text below
      ],
    );
  }
}
