import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tim1/charts/chart.dart';
import 'package:tim1/services/suhu_service.dart';
import 'package:tim1/services/weather_service.dart';

class Suhu extends StatefulWidget {
  @override
  _SuhuState createState() => _SuhuState();
}

class _SuhuState extends State<Suhu> {
  final WeatherService weatherService = WeatherService();
  final SuhuService databaseService = SuhuService();
  Map<String, dynamic>? weatherData;
  String location = 'Singaraja, Jineng Dalem';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final data = await weatherService.fetchWeather(location);
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Failed to fetch weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 250, 244),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Suhu'),
        centerTitle: true,
        backgroundColor: Colors.white, // Example background color
        elevation: 4, // Example shadow elevation
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchWeather(),
        child: StreamBuilder(
          stream: databaseService.temperatureStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(
                  child: Text('Failed to load temperature data'));
            }
            final temperatureMap = snapshot.data as Map<String, dynamic>;
            final double suhuUdara =
                double.tryParse(temperatureMap['udara'] ?? '0') ?? 0.0;
            final double suhuAir =
                double.tryParse(temperatureMap['air'] ?? '0') ?? 0.0;
            final double kelembaban =
                double.tryParse(temperatureMap['kelembaban'] ?? '0') ?? 0.0;

            // Safely handle null values and default to empty lists if data is not available
            final suhuAirList = (temperatureMap['suhuAirList'] as List?)
                    ?.map((e) => double.parse(e.toString()))
                    .toList() ??
                [];
            final suhuUdaraList = (temperatureMap['suhuUdaraList'] as List?)
                    ?.map((e) => double.parse(e.toString()))
                    .toList() ??
                [];
            final kelembabanList = (temperatureMap['kelembabanList'] as List?)
                    ?.map((e) => double.parse(e.toString()))
                    .toList() ??
                [];

            // Debugging statements to check data being passed to the chart
            print('suhuAirList: $suhuAirList');
            print('suhuUdaraList: $suhuUdaraList');
            print('kelembabanList: $kelembabanList');

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (weatherData != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          getWeatherAnimation(
                              weatherData!['weather'][0]['main']),
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 100,
                          width: 1,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            Text(
                              '${suhuUdara.toInt()}°C',
                              style: const TextStyle(
                                  fontSize: 60, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  Text(
                    '${weatherData!['weather'][0]['description']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.thermostat, size: 30),
                          const SizedBox(height: 8),
                          Text(
                            'Suhu Air: ${suhuAir.toStringAsFixed(1)}°C',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.opacity, size: 30),
                          const SizedBox(height: 8),
                          Text(
                            'Kelembaban: ${kelembaban.toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          SuhuChart(),
                          const SizedBox(height: 32),
                          // BarChartWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/weather/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/weather/cloudy.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/weather/fog.json';
      case 'rain':
        return 'assets/weather/rainy.json';
      case 'drizzle':
      case 'shower rain':
        return 'assets/weather/drizzle.json';
      case 'thunderstorm':
        return 'assets/weather/thunderstorm.json';
      case 'clear':
        return 'assets/weather/sunny.json';
      default:
        return 'assets/weather/sunny.json';
    }
  }
}
