import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tim1/services/capacity_service.dart';

class SaluranIrigasi extends StatelessWidget {
  final CapacityService capacityService = CapacityService();
  final bool isAutomatic;
  final Map<String, bool> controls;
  final Function(String, bool) updateControl;

  // ignore: use_super_parameters
  SaluranIrigasi({
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
          double latestKapasitasTandon =
              double.tryParse(snapshot.data?['kapasitastandon'] ?? '0') ?? 0.0;
          double tinggiTandon = 39;
          double jarakSensorKeTutupTandon = 30.0;

          double kapasitasTandonInLiters;

          if (latestKapasitasTandon >= 0 && latestKapasitasTandon <= 69) {
            // Calculate water height from the bottom of the tank
            double tinggiAir = tinggiTandon -
                (latestKapasitasTandon - jarakSensorKeTutupTandon);

            // Ensure water height does not exceed tank height
            double tinggiAirValid = tinggiAir.clamp(0, tinggiTandon);

            // Calculate capacity in liters
            kapasitasTandonInLiters = (tinggiAirValid / tinggiTandon) * 150.0;
          } else {
            // Set capacity to 0 liters if value > 69 cm or < 0
            kapasitasTandonInLiters = 0.0;
          }

          // Ensure capacity is within 0 to 150 liters range
          kapasitasTandonInLiters = kapasitasTandonInLiters.clamp(0.0, 150.0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sistem Saluran Irigasi Otomatis',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Atur saluran irigasi secara manual atau otomatis',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Tandon Air Otomatis',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 13.0,
                animation: true,
                percent: kapasitasTandonInLiters / 150.0,
                center: Text(
                  "${kapasitasTandonInLiters.toStringAsFixed(1)} / 150 L",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Sumber Air'),
                value: controls['relay_sumber_air'] ?? false,
                onChanged: !isAutomatic
                    ? (value) {
                        updateControl('relay_sumber_air', value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: const Text('Pompa Irigasi'),
                value: controls['relay_pompa_irigasi'] ?? false,
                onChanged: !isAutomatic
                    ? (value) {
                        updateControl('relay_pompa_irigasi', value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: const Text('Pengurasan Pipa'),
                value: controls['relay_pengurasan_pipa'] ?? false,
                onChanged: !isAutomatic
                    ? (value) {
                        updateControl('relay_pengurasan_pipa', value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: const Text('Pengaduk Air'),
                value: controls['relay_dinamo_pengaduk'] ?? false,
                onChanged: !isAutomatic
                    ? (value) {
                        updateControl('relay_dinamo_pengaduk', value);
                      }
                    : null,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading data');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
