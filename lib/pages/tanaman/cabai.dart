import 'package:flutter/material.dart';

class CabaiCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pertumbuhan Tanaman Cabai',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Status Tanaman     : Tumbuh'),
                      const Text(
                          'Tanggal Tanam      : 02-05-2024 06:59:00 WITA'),
                      const Text(
                          'Tanggal Panen      : 02-08-2024 06:59:00 WITA'),
                      const Text('Usia Tanaman       : 68 Hari'),
                      const Text('Estimasi Panen     : 23 Hari'),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
