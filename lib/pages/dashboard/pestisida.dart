import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tim1/services/capacity_service.dart';

class MonitoringPestisida extends StatelessWidget {
  final CapacityService capacityService = CapacityService();
  final bool isAutomatic;
  final Map<String, bool> controls;
  final Function(String, bool) updateControl;

  MonitoringPestisida({
    Key? key,
    required this.isAutomatic,
    required this.controls,
    required this.updateControl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
      stream: capacityService.capacityStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double latestKapasitasPestisida =
              double.tryParse(snapshot.data?['kapasitaspestisida'] ?? '0') ??
                  0.0;
          double tinggiTandon = 9.0;
          double jarakSensorKeTutupTandon = 37.0;

          double kapasitasPestisidaInLiters;

          if (latestKapasitasPestisida >= 0 && latestKapasitasPestisida <= 46) {
            // Hitung tinggi air dari dasar tandon
            double tinggiAir = tinggiTandon -
                (latestKapasitasPestisida - jarakSensorKeTutupTandon);

            // Pastikan tinggi air tidak melebihi tinggi tandon
            double tinggiAirValid = tinggiAir.clamp(0, tinggiTandon);

            // Hitung kapasitas dalam liter
            kapasitasPestisidaInLiters = (tinggiAirValid / tinggiTandon) * 5.0;
          } else {
            // Jika nilai > 46 cm atau < 0, set kapasitas menjadi 0 liter
            kapasitasPestisidaInLiters = 0.0;
          }

          // Ensure kapasitasPestisidaInLiters is within 0 to 5 liters range
          kapasitasPestisidaInLiters =
              kapasitasPestisidaInLiters.clamp(0.0, 5.0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Monitoring dan Kontrol Hama',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Atur model secara manual atau otomatis',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 13.0,
                animation: true,
                percent: kapasitasPestisidaInLiters / 5.0,
                center: Text(
                  "${kapasitasPestisidaInLiters.toStringAsFixed(1)} / 5.0 L",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'AI pendeteksi hama tidak aktif',
                style: TextStyle(fontSize: 16),
              ),
              SwitchListTile(
                title: const Text('Pompa Pestisida'),
                value: controls['relay_pompa_pestisida'] ?? false,
                onChanged: !isAutomatic
                    ? (value) {
                        updateControl('relay_pompa_pestisida', value);
                      }
                    : null,
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
