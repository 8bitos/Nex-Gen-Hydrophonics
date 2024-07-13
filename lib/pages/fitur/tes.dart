// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:tim1/services/cabai_service.dart';

// class Tanaman extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tanaman',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Fruits & Vegetables'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.shopping_cart),
//               onPressed: () {
//                 // Handle shopping cart button press
//               },
//             ),
//           ],
//         ),
//         body: CabaiDetailsPage(), // Use CabaiDetailsPage instead of ProductPage
//       ),
//     );
//   }
// }

// class CabaiDetailsPage extends StatefulWidget {
//   @override
//   _CabaiDetailsPageState createState() => _CabaiDetailsPageState();
// }

// class _CabaiDetailsPageState extends State<CabaiDetailsPage> {
//   String _tanggalTanam = ''; // Default empty string
//   String _tanggalPanen = ''; // Default empty string
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchDatesFromFirebase();
//   }

//   Future<void> _fetchDatesFromFirebase() async {
//     try {
//       CabaiService cabaiService = CabaiService();
//       _tanggalTanam = await cabaiService.getTanggalTanamFormatted() ?? '';
//       _tanggalPanen = await cabaiService.getTanggalPanenFormatted() ?? '';
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching dates: $e');
//       setState(() {
//         _isLoading = false;
//       });
//       // Handle error fetching dates
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cabai Details'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Card(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset('assets/images/cabai.png'),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Cabai',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             'Belum Siap Panen',
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Details',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Text(
//                       'Usia Tanaman',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   _buildGauge(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildGauge() {
//     return SfRadialGauge(
//       axes: <RadialAxis>[
//         RadialAxis(
//           minimum: 0,
//           maximum: 13,
//           startAngle: 180,
//           endAngle: 0,
//           radiusFactor:
//               0.8, // Adjust this value to make the gauge smaller or larger
//           ranges: <GaugeRange>[
//             GaugeRange(
//               startValue: 0,
//               endValue: 3,
//               color: Colors.red,
//               startWidth: 10,
//               endWidth: 10,
//             ),
//             GaugeRange(
//               startValue: 3,
//               endValue: 6,
//               color: Colors.orange,
//               startWidth: 10,
//               endWidth: 10,
//             ),
//             GaugeRange(
//               startValue: 6,
//               endValue: 9,
//               color: Colors.yellow,
//               startWidth: 10,
//               endWidth: 10,
//             ),
//             GaugeRange(
//               startValue: 9,
//               endValue: 13,
//               color: Colors.green,
//               startWidth: 10,
//               endWidth: 10,
//             ),
//           ],
//           pointers: <GaugePointer>[
//             NeedlePointer(
//               value: _calculateGaugeValue(),
//               needleLength: 0.8,
//               needleStartWidth: 1,
//               needleEndWidth: 5,
//               knobStyle:
//                   KnobStyle(color: Colors.black, borderColor: Colors.black),
//             ),
//           ],
//           annotations: <GaugeAnnotation>[
//             GaugeAnnotation(
//               widget: Text(
//                 _tanggalTanam,
//                 style: TextStyle(fontSize: 16),
//               ),
//               angle: 180,
//               positionFactor: 1.2,
//             ),
//             GaugeAnnotation(
//               widget: Text(
//                 _tanggalPanen,
//                 style: TextStyle(fontSize: 16),
//               ),
//               angle: 0,
//               positionFactor: 1.2,
//             ),
//             GaugeAnnotation(
//               widget: Text(
//                 'Siap Panen',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//               angle: 90,
//               positionFactor: 1.2,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   double _calculateGaugeValue() {
//     double todayDay = DateTime.now().day.toDouble();
//     double startDay = 0.0;
//     double endDay = 0.0;

//     if (_tanggalTanam.isNotEmpty) {
//       startDay = double.tryParse(_tanggalTanam.split(' ')[0]) ?? 0.0;
//     }

//     if (_tanggalPanen.isNotEmpty) {
//       endDay = double.tryParse(_tanggalPanen.split(' ')[0]) ?? 0.0;
//     }

//     double pointerValue = 0.0;

//     if (startDay != 0.0 && endDay != 0.0) {
//       if (todayDay >= startDay && todayDay <= endDay) {
//         pointerValue = (todayDay - startDay) / (endDay - startDay) * 13.0;
//       } else if (todayDay < startDay) {
//         pointerValue = 0.0; // Before planting
//       } else {
//         pointerValue = 13.0; // After harvest
//       }
//     }

//     return pointerValue;
//   }
// }
