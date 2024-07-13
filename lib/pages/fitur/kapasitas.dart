import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tim1/services/capacity_service.dart'; // Import CapacityService

class Kapasitas extends StatefulWidget {
  @override
  _KapasitasState createState() => _KapasitasState();
}

class _KapasitasState extends State<Kapasitas> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode unfocusNode = FocusNode();
  late CapacityService _capacityService; // Declare CapacityService instance
  Map<String, String> capacityData = {
    'kapasitas_nutrisi_a': 'Loading...',
    'kapasitas_nutrisi_b': 'Loading...',
    'kapasitasphup': 'Loading...',
    'kapasitasphdown': 'Loading...',
    'kapasitaspestisida': 'Loading...',
    'kapasitasboxmix': 'Loading...',
  }; // Initialize with default values

  @override
  void initState() {
    super.initState();
    _capacityService = CapacityService();
    _capacityService.capacityStream.listen((data) {
      setState(() {
        capacityData = data;
      });
    });
  }

  @override
  void dispose() {
    _capacityService.dispose(); // Dispose CapacityService instance
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Kapasitas'),
          centerTitle: true,
          backgroundColor: Colors.white, // Example background color
          elevation: 4, // Example shadow elevation
        ),
        backgroundColor: const Color.fromARGB(192, 22, 182, 43),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10.0), // Add margin for shadow
              padding:
                  const EdgeInsets.all(10.0), // Add padding for content spacing
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    192, 22, 182, 43), // Background color of the container
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 5,
                    blurRadius: 70,
                    offset: const Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildChart('Nutrisi A', 'kapasitas_nutrisi_a', Colors.blue),
                  _buildChart('Nutrisi B', 'kapasitas_nutrisi_b', Colors.green),
                  _buildChart('PH Penaik', 'kapasitasphup', Colors.orange),
                  _buildChart('PH Penurun', 'kapasitasphdown', Colors.red),
                  _buildChart('Pestisida', 'kapasitaspestisida', Colors.purple),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(String title, String dataKey, Color chartColor) {
    double kapasitasPercentage = 0;
    if (capacityData[dataKey] != 'Loading...' &&
        capacityData[dataKey] != null) {
      kapasitasPercentage =
          (double.tryParse(capacityData[dataKey]!) ?? 0) / 1000 * 100;
    }

    double remainingPercentage = 100 - kapasitasPercentage;
    double kapasitasValue = double.tryParse(capacityData[dataKey] ?? '0') ?? 0;
    double remainingValue = 1000 - kapasitasValue;

    // Format percentages to 2 decimal places
    kapasitasPercentage = double.parse(kapasitasPercentage.toStringAsFixed(2));
    remainingPercentage = double.parse(remainingPercentage.toStringAsFixed(2));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 120.0,
                width: 120.0,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: const Color.fromARGB(255, 233, 232, 232),
                        value: remainingPercentage,
                        radius: 30.0,
                      ),
                      PieChartSectionData(
                        color: chartColor,
                        value: kapasitasPercentage,
                        radius: 30.0,
                      ),
                    ],
                    startDegreeOffset: -90,
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40.0,
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 800),
                  swapAnimationCurve: Curves.easeInOutCubic,
                ),
              ),
              Text(
                '${kapasitasPercentage.toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Kapasitas Tersisa: ${capacityData[dataKey] ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Larutan Keluar: ${remainingValue.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
