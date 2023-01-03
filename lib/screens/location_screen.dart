import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:fluttertoast/fluttertoast.dart';

const apiKey = '7eeaf49b1dfa830485643fb940d25dd9';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

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
  late var weatherData;

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                                Fluttertoast.showToast(
                                    msg: 'Not a valid country name',
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                if (!mounted) return;
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context){
                                      return const CityScreen();
                                    }));
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
