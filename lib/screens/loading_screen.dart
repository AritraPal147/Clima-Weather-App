import 'dart:io';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const apiKey = '7eeaf49b1dfa830485643fb940d25dd9';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather?';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String loadingScreenMessage = 'Loading';

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async{
    Location location = Location();
    await location.getCurrentLocation().catchError((e){
      Fluttertoast.showToast(
          msg: '$e. App will shut down in 3 seconds',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print(e);
      Duration threeSeconds = Duration(seconds: 3);
      Future.delayed(threeSeconds, (){
        exit(0);
      });
    }).then((value) async {
      NetworkHelper networkHelper = NetworkHelper('$openWeatherMapURL'
          'lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

      var weatherData = await networkHelper.getData();
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return LocationScreen(locationWeather: weatherData
          );
      })).then((value) => getLocationData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SpinKitSpinningLines(
            color: Colors.white,
            size: 100.0,
          ),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 40),
          )
        ],
      ),
    );
  }
}
