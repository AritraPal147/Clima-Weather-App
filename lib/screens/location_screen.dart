import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class LocationScreen extends StatefulWidget {

  const LocationScreen({super.key, this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  late int temperature;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData){
    setState(() {
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      weatherMessage = weather.getMessage(temperature);
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);

      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('images/location_background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.near_me,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.location_city,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(
                        '$temperature°',
                        style: const TextStyle(fontSize: 80, fontFamily: 'Spartan MB'),
                      ),
                      Text(
                        weatherIcon,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
                  child: Text(
                    '$weatherMessage   in $cityName!',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 50, fontFamily: 'Spartan MB'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
