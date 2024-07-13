// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class CabaiService {
  final DatabaseReference _db = FirebaseDatabase.instance.reference();

  Future<String?> getTanggalTanamFormatted() async {
    try {
      DataSnapshot snapshot = (await _db
          .child('settings/tanaman/tanggal_tanam/Cabai')
          .once()) as DataSnapshot;

      dynamic value = snapshot.value;
      if (value is String) {
        // Parse the date string
        DateTime parsedDate = DateTime.parse(value);
        // Format date to 'd MMMM' (e.g., '2 August')
        String formattedDate = DateFormat('d MMMM').format(parsedDate);
        return formattedDate;
      } else {
        return null; // Handle case where data doesn't exist or is of unexpected type
      }
    } catch (e) {
      return null; // Return null or handle error as appropriate
    }
  }

  Future<String?> getTanggalPanenFormatted() async {
    try {
      DataSnapshot snapshot = (await _db
          .child('settings/tanaman/tanggal_panen/Cabai')
          .once()) as DataSnapshot;

      dynamic value = snapshot.value;
      if (value is String) {
        // Parse the date string
        DateTime parsedDate = DateTime.parse(value);
        // Format date to 'd MMMM' (e.g., '2 August')
        String formattedDate = DateFormat('d MMMM').format(parsedDate);
        return formattedDate;
      } else {
        return null; // Handle case where data doesn't exist or is of unexpected type
      }
    } catch (e) {
      return null; // Return null or handle error as appropriate
    }
  }
}
