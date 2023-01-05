import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 80.0,
);

const AlertStyle alertStyle = AlertStyle(
    backgroundColor: Colors.black,
    titleStyle: TextStyle(
      color: Colors.white,
    ),
    descStyle: TextStyle(
      color: Colors.white,
    )
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 50.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
  color: Colors.white,
);

const kConditionTextStyle = TextStyle(
  fontSize: 60.0,
);

const kTextFieldInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    icon: Icon(
      Icons.location_city,
      color: Colors.white,
    ),
    hintText: 'Enter City Name ',
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide.none,
    )
);
