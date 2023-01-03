import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const apiKey = '7eeaf49b1dfa830485643fb940d25dd9';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  late double latitude, longitude;

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async{
    Location location = Location();
    await location.getCurrentLocation().catchError((e){
      Fluttertoast.showToast(
          msg: e,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print(e);
    }).then((value) async {
      NetworkHelper networkHelper = NetworkHelper('https://api.openweathermap.org/data/2.5/weather?'
          'lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

      var weatherData = await networkHelper.getData();
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return LocationScreen(locationWeather: weatherData
          );
      }));
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
