import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('settings/tanaman');

  Future<Map<dynamic, dynamic>> getTanamanData() async {
    DatabaseEvent event = await _databaseReference.once();
    DataSnapshot snapshot = event.snapshot;
    return snapshot.value as Map<dynamic, dynamic>;
  }
}
