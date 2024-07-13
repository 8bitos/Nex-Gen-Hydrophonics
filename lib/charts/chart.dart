import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tim1/services/suhu_service.dart';

class SuhuChart extends StatelessWidget {
  final SuhuService suhuService = SuhuService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: suhuService.temperatureStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final temperatureData = snapshot.data!;
          final double suhuUdara =
              double.tryParse(temperatureData['udara'] ?? '0') ?? 0.0;
          final double suhuAir =
              double.tryParse(temperatureData['air'] ?? '0') ?? 0.0;

          List<TemperaturePoint> suhuUdaraData = [
            TemperaturePoint(
                suhuUdara, DateTime.now().subtract(Duration(minutes: 7))),
            TemperaturePoint(
                suhuUdara, DateTime.now().subtract(Duration(minutes: 6))),
            TemperaturePoint(
                suhuUdara, DateTime.now().subtract(Duration(minutes: 5))),
            TemperaturePoint(
                suhuUdara, DateTime.now().subtract(Duration(minutes: 4))),
            TemperaturePoint(
                suhuUdara, DateTime.now().subtract(Duration(minutes: 3))),
            TemperaturePoint(
                suhuUdara, DateTime.now().subtract(Duration(minutes: 2))),
            TemperaturePoint(
                suhuUdara, DateTime.now().subtract(Duration(minutes: 1))),
            TemperaturePoint(suhuUdara, DateTime.now()),
          ];

          List<TemperaturePoint> suhuAirData = [
            TemperaturePoint(
                suhuAir, DateTime.now().subtract(Duration(minutes: 7))),
            TemperaturePoint(
                suhuAir, DateTime.now().subtract(Duration(minutes: 6))),
            TemperaturePoint(
                suhuAir, DateTime.now().subtract(Duration(minutes: 5))),
            TemperaturePoint(
                suhuAir, DateTime.now().subtract(Duration(minutes: 4))),
            TemperaturePoint(
                suhuAir, DateTime.now().subtract(Duration(minutes: 3))),
            TemperaturePoint(
                suhuAir, DateTime.now().subtract(Duration(minutes: 2))),
            TemperaturePoint(
                suhuAir, DateTime.now().subtract(Duration(minutes: 1))),
            TemperaturePoint(suhuAir, DateTime.now()),
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Monitoring Suhu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Kondisi suhu air hidroponik',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                CombinedLineChart(
                  suhuUdaraData: suhuUdaraData,
                  suhuAirData: suhuAirData,
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CombinedLineChart extends StatelessWidget {
  final List<TemperaturePoint> suhuUdaraData;
  final List<TemperaturePoint> suhuAirData;
  static const double upperBound = 80.0;
  static const double lowerBound = -50.0;

  CombinedLineChart({
    required this.suhuUdaraData,
    required this.suhuAirData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: const Color.fromARGB(255, 243, 117, 33),
              barWidth: 4,
              belowBarData: BarAreaData(show: false),
              spots: List.generate(suhuUdaraData.length, (index) {
                return FlSpot(
                    index.toDouble(), suhuUdaraData[index].temperature);
              }),
            ),
            LineChartBarData(
              isCurved: true,
              color: Color.fromARGB(255, 87, 175, 248),
              barWidth: 4,
              belowBarData: BarAreaData(show: false),
              spots: List.generate(suhuAirData.length, (index) {
                return FlSpot(index.toDouble(), suhuAirData[index].temperature);
              }),
            ),
          ],
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: upperBound,
                color: Colors.red
                    .withOpacity(0.2), // Adjust opacity to make it less visible
                strokeWidth: 1,
              ),
              HorizontalLine(
                y: lowerBound,
                color: Colors.blue
                    .withOpacity(0.2), // Adjust opacity to make it less visible
                strokeWidth: 1,
              ),
            ],
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}

class TemperaturePoint {
  final double temperature;
  final DateTime timestamp;

  TemperaturePoint(this.temperature, this.timestamp);
}
