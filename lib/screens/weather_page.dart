import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skycast/main.dart';
import 'package:skycast/services/weather_services.dart';
import 'package:skycast/widget/weather_data_tile.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  String _bgImg = 'assets/images/haze.jpg';
  String _iconImg = 'assets/icons/haze2.png';
  String _cityName = '';
  String _temperature = '';
  String _pressure = '';
  String _humidity = '';
  String _visibility = '';
  String _windSpeed = '';
  String _main = '';

  getWeather(String cityName) async {
    final weatherService = WeatherServices();
    var weatherData;
    if(_cityName == ''){
      weatherData = await weatherService.fetchWeather();
    } else{
      weatherData = await weatherService.getWeather(cityName);
    }
    debugPrint(weatherData.toString());
    setState(() {
      _cityName = weatherData['location']['name'];
      _temperature = "${weatherData['current']['temp_c']}°C";
      _pressure = "${weatherData['current']['pressure_mb']} hPa";
      _humidity = "${weatherData['current']['humidity']}%";
      _visibility = "${weatherData['current']['vis_km']} km";
      _windSpeed = "${weatherData['current']['wind_kph']} km/h";
      _main = weatherData['current']['condition']['text'];

      if (_main == 'Clear') {
        _bgImg = 'assets/images/clear.jpg';
        _iconImg = 'assets/icons/clear.png';
      } else if (_main == 'Cloudy') {
        _bgImg = 'assets/images/clouds.jpeg';
        _iconImg = 'assets/icons/cloudy.png';
      } else if (_main == 'Haze') {
        _bgImg = 'assets/images/haze.jpg';
        _iconImg = 'assets/icons/haze2.png';
      } else if (_main == 'Mist') {
        _bgImg = 'assets/images/haze.jpg';
        _iconImg = 'assets/icons/haze2.png';
      } else if (_main == 'Rain') {
        _bgImg = 'assets/images/rain.jpeg';
        _iconImg = 'assets/icons/rain.png';
      } else if (_main == 'Snow') {
        _bgImg = 'assets/images/snow.jpg';
        _iconImg = 'assets/icons/snow.png';
      } else if (_main == 'Thunderstorm') {
        _bgImg = 'assets/images/thunderstorm.jpg';
        _iconImg = 'assets/icons/thunderstorm.png';
      }
    });
  }

  Future<bool> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
      getWeather('');
    }
    getWeather('');
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            _bgImg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: _controller,
                    onChanged: (value) {
                      getWeather(value);
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search_outlined),
                      hintText: 'Search Location',
                      filled: true,
                      fillColor: Color.fromARGB(69, 118, 103, 103),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on),
                      Text(
                        _cityName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    _temperature,
                    style: const TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    children: [
                      Text(
                        _main,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        _iconImg,
                        height: 80,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(
                    children: [
                      Icon(Icons.arrow_upward_outlined),
                      Text(
                        '19°C',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.arrow_downward_outlined),
                      Text(
                        '18°C',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Card(
                    color: Colors.transparent,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const WeatherDataTile(
                              index1: "Sunrise",
                              index2: "Sunset",
                              value1: "06:15AM",
                              value2: "06:15PM"),
                          const SizedBox(
                            height: 15,
                          ),
                          const WeatherDataTile(
                              index1: "Humidity",
                              index2: "Visibility",
                              value1: "4",
                              value2: "10000"),
                          const SizedBox(
                            height: 15,
                          ),
                          WeatherDataTile(
                              index1: "Precipitation",
                              index2: "Wind Speed",
                              value1: "6",
                              value2: _windSpeed),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}