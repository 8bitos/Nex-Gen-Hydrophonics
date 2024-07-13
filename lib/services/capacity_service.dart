import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class CapacityService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  late StreamController<Map<String, String>> _capacityController;
  Stream<Map<String, String>> get capacityStream => _capacityController.stream;

  CapacityService() {
    _capacityController = StreamController<Map<String, String>>.broadcast();
    _initCapacityListener();
  }

  void _initCapacityListener() {
    // Listen to changes at a higher level
    _dbRef.child('esp32info').onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        final data = dataSnapshot.value as Map<dynamic, dynamic>;

        // Determine the latest date and time
        String? latestDate;
        String? latestTime;
        dynamic latestData;

        for (var dateEntry in data.entries) {
          final date = dateEntry.key;
          final timeData = dateEntry.value as Map<dynamic, dynamic>;

          for (var timeEntry in timeData.entries) {
            final time = timeEntry.key;
            if (latestDate == null ||
                latestTime == null ||
                DateTime.parse('$date $time')
                    .isAfter(DateTime.parse('$latestDate $latestTime'))) {
              latestDate = date;
              latestTime = time;
              latestData = timeEntry.value;
            }
          }
        }

        if (latestData != null) {
          final capacityData = latestData as Map<dynamic, dynamic>;

          String? kapasitasNutrisiA =
              capacityData['kapasitas_nutrisi_a']?.toString();
          String? kapasitasNutrisiB =
              capacityData['kapasitas_nutrisi_b']?.toString();
          String? kapasitasPHUp = capacityData['kapasitas_ph_up']?.toString();
          String? kapasitasPHDown =
              capacityData['kapasitas_ph_down']?.toString();
          String? kapasitasPestisida =
              capacityData['kapasitas_pestisida']?.toString();
          String? kapasitasBoxMix =
              capacityData['kapasitas_box_mix']?.toString();

          String? kapasitasTandon =
              capacityData['kapasitas_tandon_pencampuran']?.toString();

          String? sensorTds = capacityData['sensor_tds']?.toString();
          String? sensorPh = capacityData['sensor_ph']?.toString();

          final capacityMap = {
            'kapasitas_nutrisi_a': kapasitasNutrisiA ?? 'N/A',
            'kapasitas_nutrisi_b': kapasitasNutrisiB ?? 'N/A',
            'kapasitasphup': kapasitasPHUp ?? 'N/A',
            'kapasitasphdown': kapasitasPHDown ?? 'N/A',
            'kapasitaspestisida': kapasitasPestisida ?? 'N/A',
            'kapasitasboxmix': kapasitasBoxMix ?? 'N/A',
            'kapasitastandon': kapasitasTandon ?? 'N/A',
            'sensor_tds': sensorTds ?? 'N/A',
            'sensor_ph': sensorPh ?? 'N/A',
          };

          _capacityController.add(capacityMap);
        } else {
          print('Latest data is null');
        }
      } else {
        print('Data snapshot is null or empty');
      }
    }, onError: (error) {
      print('Error fetching data: $error');
    });
  }

  Future<void> dispose() async {
    await _capacityController.close();
  }

  void updateControl(String s, String t) {}
}
