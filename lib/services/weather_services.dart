import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  final String apiKey = 'd9c94df5a55942abb83130023250302';

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName&aqi=no'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  Future<Map<String, dynamic>> fetchWeather() async {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    double lat = position.latitude;
    double long = position.longitude;
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$long&aqi=no'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
