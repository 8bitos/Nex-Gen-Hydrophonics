import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> suhuAir;
  final List<double> suhuUdara;
  final List<double> kelembaban;

  LineChartWidget({
    required this.suhuAir,
    required this.suhuUdara,
    required this.kelembaban,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 120,
        interval: 20,
      ),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries>[
        LineSeries<double, int>(
          name: 'Suhu Air',
          dataSource: suhuAir,
          xValueMapper: (value, index) => index!,
          yValueMapper: (value, _) => value,
          markerSettings: MarkerSettings(isVisible: true),
        ),
        LineSeries<double, int>(
          name: 'Suhu Udara',
          dataSource: suhuUdara,
          xValueMapper: (value, index) => index!,
          yValueMapper: (value, _) => value,
          markerSettings: MarkerSettings(isVisible: true),
        ),
        LineSeries<double, int>(
          name: 'Kelembaban',
          dataSource: kelembaban,
          xValueMapper: (value, index) => index!,
          yValueMapper: (value, _) => value,
          markerSettings: MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}
