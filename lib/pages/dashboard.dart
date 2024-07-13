// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tim1/pages/dashboard/grow_light.dart';
import 'package:tim1/pages/dashboard/monitoring_nutrisi.dart';
import 'package:tim1/pages/dashboard/monitoring_phAir.dart';
import 'package:tim1/pages/dashboard/monitoring_suhu.dart';
import 'package:tim1/pages/dashboard/pestisida.dart';
import 'package:tim1/pages/dashboard/saluran_irigasi.dart';
import 'package:tim1/services/control_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ControlService controlService = ControlService();
  Map<String, bool> controls = {};
  bool isAutomatic = false;
  // ignore: deprecated_member_use
  final databaseReference = FirebaseDatabase.instance.reference();

  final Map<String, String> controlLabels = {
    'controls_action': 'CONTROL ACTION',
    'relay_dinamo_pengaduk': 'Dinamo Penganduk',
    'relay_grow_light': 'Grow Light',
    'relay_nutrisi_ab': 'Nutrisi AB',
    'relay_pengurasan_pipa': 'Pengurasan',
    'relay_ph_down': 'pH Penurun ',
    'relay_ph_up': 'pH Penaik',
    'relay_pompa_irigasi': 'Pompa Irigasi',
    'relay_pompa_pestisida': 'Pompa Pestisida',
    'relay_sumber_air': 'Sumber Air'
  };

  @override
  void initState() {
    super.initState();
    _initializeControls();
    _listenToRealtimeDatabase();
  }

  void _initializeControls() async {
    try {
      Map<String, int> initialValues = await controlService.getInitialValues();
      if (initialValues.isNotEmpty) {
        setState(() {
          initialValues.forEach((key, value) {
            controls[key] = value == 1;
          });
          isAutomatic = initialValues['controls_action'] == 1;
        });
        print('Initial switch states: $controls');
      } else {
        print('Initial values are empty');
      }
    } catch (error) {
      print('Error loading initial values: $error');
    }
  }

  void _listenToRealtimeDatabase() {
    databaseReference.child('controls').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        data.forEach((key, value) {
          controls[key] = value == 1;
        });
        isAutomatic = data['controls_action'] == 1;
      });
    });
  }

  void _updateControl(String key, bool value) async {
    setState(() {
      controls[key] = value;
    });
    await controlService.updateControl(key, value ? 1 : 0);
    await databaseReference.child('controls/$key').set(value ? 1 : 0);
  }

  void _toggleAutomatic(bool value) async {
    setState(() {
      isAutomatic = value;
    });
    await controlService.updateControl('controls_action', value ? 1 : 0);
    await databaseReference
        .child('controls/controls_action')
        .set(value ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(192, 22, 182, 43),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: Text(isAutomatic ? 'Automatic' : 'Manual'),
              value: isAutomatic,
              onChanged: (value) {
                _toggleAutomatic(value);
              },
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SaluranIrigasi(
                  isAutomatic: isAutomatic,
                  controls: controls,
                  updateControl: _updateControl,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MonitoringPestisida(
                  isAutomatic: isAutomatic,
                  controls: controls,
                  updateControl: _updateControl,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MonitoringSuhu(),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MonitoringNutrisi(
                  isAutomatic: isAutomatic,
                  controls: controls,
                  updateControl: _updateControl,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MonitoringPhair(
                  isAutomatic: isAutomatic,
                  controls: controls,
                  updateControl: _updateControl,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GrowLight(
                  isAutomatic: isAutomatic,
                  controls: controls,
                  updateControl: _updateControl,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
