// import 'package:flutter/material.dart';
// import 'package:tim1/services/tanaman_service.dart';

// class TestPage extends StatefulWidget {
//   @override
//   _TestPageState createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   final TanamanService _tanamanService = TanamanService();
//   Map<String, String?> cabaiData = {};
//   Map<String, String?> seladaData = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   void _fetchData() async {
//     String? estimasiPanenCabai =
//         await _tanamanService.getEstimasiPanen('cabai');
//     String? namaTanamanCabai = await _tanamanService.getNamaTanaman('cabai');
//     String? statusPertubuhanCabai =
//         await _tanamanService.getStatusPertubuhan('cabai');
//     String? tanggalPanenCabai = await _tanamanService.getTanggalPanen('cabai');
//     String? tanggalTanamCabai = await _tanamanService.getTanggalTanam('cabai');
//     String? usiaTanamanCabai = await _tanamanService.getUsiaTanaman('cabai');

//     String? estimasiPanenSelada =
//         await _tanamanService.getEstimasiPanen('selada');
//     String? namaTanamanSelada = await _tanamanService.getNamaTanaman('selada');
//     String? statusPertubuhanSelada =
//         await _tanamanService.getStatusPertubuhan('selada');
//     String? tanggalPanenSelada =
//         await _tanamanService.getTanggalPanen('selada');
//     String? tanggalTanamSelada =
//         await _tanamanService.getTanggalTanam('selada');
//     String? usiaTanamanSelada = await _tanamanService.getUsiaTanaman('selada');

//     setState(() {
//       cabaiData = {
//         'estimasi_panen': estimasiPanenCabai,
//         'nama_tanaman': namaTanamanCabai,
//         'status_pertubuhan': statusPertubuhanCabai,
//         'tanggal_panen': tanggalPanenCabai,
//         'tanggal_tanam': tanggalTanamCabai,
//         'usia_tanaman': usiaTanamanCabai,
//       };
//       seladaData = {
//         'estimasi_panen': estimasiPanenSelada,
//         'nama_tanaman': namaTanamanSelada,
//         'status_pertubuhan': statusPertubuhanSelada,
//         'tanggal_panen': tanggalPanenSelada,
//         'tanggal_tanam': tanggalTanamSelada,
//         'usia_tanaman': usiaTanamanSelada,
//       };
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tanaman Data'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildTanamanDataSection('Cabai', cabaiData),
//               SizedBox(height: 20),
//               _buildTanamanDataSection('Selada', seladaData),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTanamanDataSection(String title, Map<String, String?> data) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         _buildDataRow('Estimasi Panen', data['estimasi_panen']),
//         _buildDataRow('Nama Tanaman', data['nama_tanaman']),
//         _buildDataRow('Status Pertubuhan', data['status_pertubuhan']),
//         _buildDataRow('Tanggal Panen', data['tanggal_panen']),
//         _buildDataRow('Tanggal Tanam', data['tanggal_tanam']),
//         _buildDataRow('Usia Tanaman', data['usia_tanaman']),
//       ],
//     );
//   }

//   Widget _buildDataRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Text(value ?? 'N/A'),
//           ),
//         ],
//       ),
//     );
//   }
// }
