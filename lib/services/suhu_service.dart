import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class SuhuService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late StreamController<Map<String, dynamic>> _temperatureController;
  Stream<Map<String, dynamic>> get temperatureStream =>
      _temperatureController.stream;

  SuhuService() {
    _temperatureController = StreamController<Map<String, dynamic>>.broadcast();
    _initTemperatureListener();
  }

  void _initTemperatureListener() {
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
          final temperatureData = latestData as Map<dynamic, dynamic>;

          String? suhuUdara = temperatureData['sensor_suhu_udara']?.toString();
          String? suhuAir = temperatureData['sensor_suhu_air']?.toString();
          String? kelembaban =
              temperatureData['sensor_kelembaban_udara']?.toString();

          // Fetch historical data lists
          final suhuAirList = (temperatureData['suhuAirList'] as List?)
                  ?.map((e) => double.parse(e.toString()))
                  .toList() ??
              [];
          final suhuUdaraList = (temperatureData['suhuUdaraList'] as List?)
                  ?.map((e) => double.parse(e.toString()))
                  .toList() ??
              [];
          final kelembabanList = (temperatureData['kelembabanList'] as List?)
                  ?.map((e) => double.parse(e.toString()))
                  .toList() ??
              [];

          final temperatureMap = {
            'udara': suhuUdara ?? 'N/A',
            'air': suhuAir ?? 'N/A',
            'kelembaban': kelembaban ?? 'N/A',
            'suhuAirList': suhuAirList,
            'suhuUdaraList': suhuUdaraList,
            'kelembabanList': kelembabanList,
          };

          _temperatureController.add(temperatureMap);
        }
      }
    });
  }

  Future<void> dispose() async {
    await _temperatureController.close();
  }
}
