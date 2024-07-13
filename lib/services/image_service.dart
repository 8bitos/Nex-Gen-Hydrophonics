// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_database/firebase_database.dart';

class ImageService {
  final DatabaseReference _databaseReference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child('esp32cam');

  Stream<Map<String, String>> getImageUrls() {
    return _databaseReference.limitToLast(1).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      if (data == null || data.isEmpty) {
        return {}; // Return an empty map if no data or empty data
      }

      final latestEntry = data.entries.first;
      final timeData = latestEntry.value as Map<dynamic, dynamic>;
      final time = timeData.keys.first as String;
      final photoData = timeData[time] as Map<dynamic, dynamic>;

      // Check if photoData is null or does not contain expected fields
      if (photoData == null ||
          !photoData.containsKey('photo_original') ||
          !photoData.containsKey('photo_hama')) {
        return {
          'photo_original': '',
          'photo_hama': '',
        };
      }

      final photoOriginal = photoData['photo_original'] as String;
      final photoHama = photoData['photo_hama'] as String;

      return {
        'photo_original': photoOriginal,
        'photo_hama': photoHama,
      };
    });
  }
}
