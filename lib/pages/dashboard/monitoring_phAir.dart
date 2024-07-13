// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tim1/services/capacity_service.dart';

class MonitoringPhair extends StatelessWidget {
  final CapacityService capacityService = CapacityService();
  final bool isAutomatic;
  final Map<String, bool> controls;
  final Function(String, bool) updateControl;

  MonitoringPhair({
    super.key,
    required this.isAutomatic,
    required this.controls,
    required this.updateControl,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
      stream: capacityService.capacityStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double latestKapasitasNutrisiA =
              double.tryParse(snapshot.data?['kapasitasphup'] ?? '0') ?? 0.0;
          double latestKapasitasNutrisiB =
              double.tryParse(snapshot.data?['kapasitasphdown'] ?? '0') ?? 0.0;
          double sensorTDS =
              double.tryParse(snapshot.data?['sensor_ph'] ?? '0') ?? 0.0;

          double tinggiTandon = 14.0;
          double jarakSensorKeTutupTandon = 32.0;

          double convertToLiters(double kapasitasNutrisi) {
            if (kapasitasNutrisi >= 0 && kapasitasNutrisi <= 46) {
              double tinggiAir =
                  tinggiTandon - (kapasitasNutrisi - jarakSensorKeTutupTandon);
              double tinggiAirValid = tinggiAir.clamp(0, tinggiTandon);
              return (tinggiAirValid / tinggiTandon) * 5.0;
            } else {
              return 0.0;
            }
          }

          double kapasitasNutrisiAInLiters =
              convertToLiters(latestKapasitasNutrisiA).clamp(0.0, 5.0);
          double kapasitasNutrisiBInLiters =
              convertToLiters(latestKapasitasNutrisiB).clamp(0.0, 5.0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Monitoring dan Kontrol pH Air',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Atur pH Air',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('pH Up'),
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: kapasitasNutrisiAInLiters / 5.0,
                        center: Text(
                          "${kapasitasNutrisiAInLiters.toStringAsFixed(1)} / 5.0 L",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('pH Down'),
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: kapasitasNutrisiBInLiters / 5.0,
                        center: Text(
                          "${kapasitasNutrisiBInLiters.toStringAsFixed(1)} / 5.0 L",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
              MonitoringBar(
                title: 'Sensor pH Air Hidroponik',
                value: sensorTDS,
                icon: Icons.cloud,
                barColor: Colors.blue,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading data');
        } else {
          return const CircularProgressIndicator();
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
                value: value / 10,
                backgroundColor: Colors.grey[200],
                color: barColor,
                minHeight: 10,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: barColor),
            const SizedBox(width: 8),
            Text(value.toStringAsFixed(1)),
          ],
        ),
      ],
    );
  }
}
