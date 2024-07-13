import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tim1/services/suhu_service.dart';
import 'package:tim1/services/weather_service.dart';

class PhTanaman extends StatefulWidget {
  const PhTanaman({super.key});

  @override
  _PhTanamanState createState() => _PhTanamanState();
}

class _PhTanamanState extends State<PhTanaman> {
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
        title: const Text('Suhu'),
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
            final suhuUdara = temperatureMap['udara'];
            final suhuAir = temperatureMap['air'];
            final kelembaban = temperatureMap['kelembaban'];

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
                          height: 100, // Adjust height of separator as needed
                          width: 1, // Width of the vertical line
                          color: Colors.grey, // Color of the line
                          margin: const EdgeInsets.symmetric(
                              vertical: 8), // Add margin to position the line
                        ), // Add space between animation and text
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            Text(
                              '${(double.parse(suhuUdara ?? '0')).toInt()}°C',
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

                  const SizedBox(
                      height: 8), // Add space between weather and location
                  Text(
                    '$location',
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
                            'Suhu Air: ${suhuAir ?? 'N/A'}°C',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.opacity, size: 30),
                          const SizedBox(height: 8),
                          Text(
                            'Kelembaban: ${kelembaban ?? 'N/A'}%',
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
                          const SizedBox(height: 32),
                          LineChartWidget(
                            suhuAir: suhuAirList,
                            suhuUdara: suhuUdaraList,
                            kelembaban: kelembabanList,
                          ),
                          const BarChartWidget(),
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

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Background color
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            padding: const EdgeInsets.all(10), // Padding around the chart
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text('Mingguan', style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [
                          BarChartRodData(
                              toY: 10, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(
                              toY: 10, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(
                              toY: 14, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(
                              toY: 15, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 4, barRods: [
                          BarChartRodData(
                              toY: 13, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 5, barRods: [
                          BarChartRodData(
                              toY: 10, color: Colors.blue, width: 15)
                        ]),
                        BarChartGroupData(x: 6, barRods: [
                          BarChartRodData(
                              toY: 14, color: Colors.blue, width: 15)
                        ]),
                      ],
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ), // Hide left titles
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ), // Hide top titles
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = const Text('S', style: style);
                                  break;
                                case 1:
                                  text = const Text('S', style: style);
                                  break;
                                case 2:
                                  text = const Text('R', style: style);
                                  break;
                                case 3:
                                  text = const Text('K', style: style);
                                  break;
                                case 4:
                                  text = const Text('J', style: style);
                                  break;
                                case 5:
                                  text = const Text('S', style: style);
                                  break;
                                case 6:
                                  text = const Text('M', style: style);
                                  break;
                                default:
                                  text = const Text('', style: style);
                                  break;
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 4, // Space between bar and title
                                child: text,
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
            height: 10), // Space between the chart and the text below
      ],
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> suhuAir;
  final List<double> suhuUdara;
  final List<double> kelembaban;

  const LineChartWidget({
    super.key,
    required this.suhuAir,
    required this.suhuUdara,
    required this.kelembaban,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text('Data Harian', style: TextStyle(fontSize: 20)),
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('00:00', style: style);
                              break;
                            case 1:
                              text = const Text('03:00', style: style);
                              break;
                            case 2:
                              text = const Text('06:00', style: style);
                              break;
                            case 3:
                              text = const Text('09:00', style: style);
                              break;
                            case 4:
                              text = const Text('12:00', style: style);
                              break;
                            case 5:
                              text = const Text('15:00', style: style);
                              break;
                            case 6:
                              text = const Text('18:00', style: style);
                              break;
                            case 7:
                              text = const Text('21:00', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: text,
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: suhuAir
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: suhuUdara
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: kelembaban
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
