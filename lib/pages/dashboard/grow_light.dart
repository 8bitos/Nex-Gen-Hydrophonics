import 'package:flutter/material.dart';
import 'package:tim1/services/capacity_service.dart';

class GrowLight extends StatelessWidget {
  final CapacityService capacityService = CapacityService();
  final bool isAutomatic;
  final Map<String, bool> controls;
  final Function(String, bool) updateControl;

  // ignore: use_super_parameters
  GrowLight({
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
          // Your existing code...

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Monitoring dan Kontrol Grow Light',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Atur lampu tanaman',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Add conditional image display
              Image.asset(
                controls['relay_grow_light'] ?? false
                    ? 'assets/images/lamp_on.png' // Image path when switch is ON
                    : 'assets/images/lamp_off.png', // Image path when switch is OFF
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Lampu Grow Light'),
                value: controls['relay_grow_light'] ?? false,
                onChanged: !isAutomatic
                    ? (value) {
                        updateControl('relay_grow_light', value);
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
