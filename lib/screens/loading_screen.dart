import 'dart:io';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:clima/utilities/constants.dart';

const apiKey = '7eeaf49b1dfa830485643fb940d25dd9';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather?';
const gpsOffErrorMessage = 'Location services are disabled. Please turn on location from settings.';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String loadingScreenMessage = 'Loading';

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocationData();
    });
  }



  bool checkGPSOffError(String error){
    if (error == gpsOffErrorMessage){
      return true;
    }return false;
  }

  void getLocationData() async{
    Location location = Location();
    String alertDescription = 'Location Permission not Given';
    await location.getCurrentLocation().catchError((e){
      if (checkGPSOffError(e)){
        alertDescription = 'Location Turned OFF';
      }
      Alert(
        context: context,
        type: AlertType.error,
        style: alertStyle,
        title: "ERROR",
        desc: alertDescription,
        buttons: [
          DialogButton(
            onPressed: (){
              openAppSettings();
              exit(0);
            },
            color: const Color.fromRGBO(0, 179, 134, 1.0),
            child: const Text(
              "Settings",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            onPressed: () => exit(0),
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]),
            child: const Text(
              "Exit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();

      // Fluttertoast.showToast(
      //     msg: '$e. App will shut down in 3 seconds',
      //     toastLength: Toast.LENGTH_LONG,
      //     timeInSecForIosWeb: 3,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
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
