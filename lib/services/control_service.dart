// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';

class ControlService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('esp32controls');

  Future<Map<String, int>> getInitialValues() async {
    DataSnapshot snapshot = await _databaseReference.get();
    if (snapshot.exists && snapshot.value != null) {
      Map<String, int> values = {};
      (snapshot.value as Map).forEach((key, value) {
        values[key] =
            int.tryParse(value.toString()) ?? 0; // Convert String to int
      });
      print('Fetched values from Firebase: $values');
      return values;
    }
    print('No data found in Firebase');
    return {};
  }

  Future<void> updateControl(String key, int value) async {
    await _databaseReference.child(key).set(value);
  }
}
