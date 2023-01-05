import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const apiKey = '7eeaf49b1dfa830485643fb940d25dd9';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class LocationScreen extends StatefulWidget {

  const LocationScreen({super.key, this.locationWeather});
  final locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late DateTime now;
  WeatherModel weather = WeatherModel();
  late int timezone;
  late int temperature;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;
  late var weatherData;
  late String backgroundImage;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData){
    setState(() {
      double temp = weatherData['main']['temp'];
      timezone = weatherData['timezone'];
      now = DateTime.now().add(Duration(seconds: timezone - DateTime.now().timeZoneOffset.inSeconds));

      temperature = temp.toInt();
      weatherMessage = weather.getMessage(temperature);
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition, now);

      cityName = weatherData['name'];
      if (now.hour >= 18 || now.hour <= 6) {
        backgroundImage = 'images/night_background.png';
      } else {
        backgroundImage = 'images/day_background.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
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
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.refresh,
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
                      WillPopScope(
                        onWillPop: () async => true,
                        child: TextButton(
                          onPressed: () async{
                            var typedName = await Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context){
                                  return const CityScreen();
                            }));
                            if (typedName != null) {
                              try {
                                var url = '$openWeatherMapURL?q=$typedName&appid=$apiKey&units=metric';
                                print(url);
                                NetworkHelper networkHelper = NetworkHelper(
                                    url);
                                weatherData = await networkHelper.getData();
                                updateUI(weatherData);
                              }
                              catch(e){
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  style: alertStyle,
                                  title: "ERROR",
                                  desc: "Invalid City Name",
                                  buttons: [
                                    DialogButton(
                                      onPressed: () async {
                                        if (!mounted) return;
                                        Navigator.pop(context);
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                            builder: (context){
                                              return const CityScreen();
                                            }));
                                      },
                                      gradient: const LinearGradient(colors: [
                                        Color.fromRGBO(116, 116, 191, 1.0),
                                        Color.fromRGBO(52, 138, 199, 1.0)
                                      ]),
                                      width: 120,
                                      child: const Text(
                                        'Cancel',
                                      ),
                                    )
                                  ],
                                ).show();
                              }
                            }
                          },
                          child: const Icon(
                            Icons.location_city,
                            size: 50.0,
                            color: Colors.white,
                          ),
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
                          style: kTempTextStyle,
                        ),
                        Text(
                          weatherIcon,
                          style: kConditionTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
                    child: Text(
                      '$weatherMessage   in $cityName!',
                      textAlign: TextAlign.right,
                      style: kMessageTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
