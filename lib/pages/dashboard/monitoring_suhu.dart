import 'package:flutter/material.dart';
import 'package:tim1/services/suhu_service.dart';

class MonitoringSuhu extends StatelessWidget {
  final SuhuService suhuService = SuhuService();

  MonitoringSuhu({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: suhuService.temperatureStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final temperatureData = snapshot.data!;
          // Log the data for debugging

          final double kelembapan =
              double.tryParse(temperatureData['kelembaban'] ?? '0') ?? 0.0;
          final double suhuUdara =
              double.tryParse(temperatureData['udara'] ?? '0') ?? 0.0;
          final double suhuAir =
              double.tryParse(temperatureData['air'] ?? '0') ?? 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Monitoring Suhu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kondisi suhu air hidroponik',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                MonitoringBar(
                  title: 'Kelembapan',
                  value: kelembapan,
                  icon: Icons.cloud,
                  barColor: Colors.blue,
                ),
                MonitoringBar(
                  title: 'Suhu Udara',
                  value: suhuUdara,
                  icon: Icons.thermostat,
                  barColor: const Color.fromARGB(255, 243, 117, 33),
                ),
                MonitoringBar(
                  title: 'Suhu Air',
                  value: suhuAir,
                  icon: Icons.thermostat,
                  barColor: const Color.fromARGB(255, 87, 175, 248),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class MonitoringBar extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  final Color barColor;

  const MonitoringBar({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey[200],
                color: barColor,
                minHeight: 10,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: barColor),
            const SizedBox(width: 8),
            Text('${value.toStringAsFixed(1)}°C'),
          ],
        ),
      ],
    );
  }
}
