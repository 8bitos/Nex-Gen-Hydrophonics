import 'package:flutter/material.dart';
import 'package:tim1/model/model_tanaman.dart';
import 'package:tim1/services/tanaman_service.dart';

class TanamanScreen extends StatefulWidget {
  @override
  _TanamanScreenState createState() => _TanamanScreenState();
}

class _TanamanScreenState extends State<TanamanScreen> {
  FirebaseService _firebaseService = FirebaseService();
  Tanaman? _tanamanData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var data = await _firebaseService.getTanamanData();
    setState(() {
      _tanamanData = Tanaman.fromMap(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Tanaman'),
        centerTitle: true,
        backgroundColor: Colors.white, // Example background color
        elevation: 4, // Example shadow elevation
      ),
      body: _tanamanData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  buildTanamanCard('Cabai'),
                  buildTanamanCard('Selada'),
                ],
              ),
            ),
    );
  }

  Widget buildTanamanCard(String tanamanName) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tanamanName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            buildSection(
                'Estimasi Panen', _tanamanData!.estimasiPanen[tanamanName],
                additionalText: ' Hari'),
            buildStatusPertumbuhanSection('Status Pertumbuhan',
                _tanamanData!.statusPertumbuhan[tanamanName]!),
            buildSection(
                'Tanggal Panen', _tanamanData!.tanggalPanen[tanamanName]),
            buildSection(
                'Tanggal Tanam', _tanamanData!.tanggalTanam[tanamanName]),
            buildSection('Usia Tanaman', _tanamanData!.usiaTanaman[tanamanName],
                additionalText: ' Hari'),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, dynamic data, {String? additionalText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: additionalText != null
                ? Text('$data $additionalText')
                : Text('$data'),
          ),
        ],
      ),
    );
  }

  Widget buildStatusPertumbuhanSection(String title, PertumbuhanStatus data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '  Panen: ${data.panen ? "Siap Panen" : "Belum Siap Panen"}'),
                Text('  Semai: ${data.semai ? "Yes" : "No"}'),
                Text('  Tumbuh: ${data.tumbuh ? "Tumbuh" : " Tidak Tumbuh"}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
