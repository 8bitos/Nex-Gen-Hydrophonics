import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '5e14d22605364e70f9adae96fe7dce66';
  final String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String location) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$location&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
