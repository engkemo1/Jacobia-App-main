import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

//Here we Build light Theme
ThemeData lightTheme(context) {
  return ThemeData(
    textTheme: TextTheme(
    ).apply(bodyColor: Colors.black,fontFamily: 'Arial',),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
    //  toolbarHeight: 80,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
      color: Colors.white,
      elevation: 0,

      titleTextStyle: TextStyle(),
    ),
    );
}
