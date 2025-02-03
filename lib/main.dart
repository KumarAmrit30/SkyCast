import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skycast/screens/weather_page.dart';
import 'package:skycast/services/weather_services.dart';
import 'package:skycast/widget/weather_data_tile.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}


