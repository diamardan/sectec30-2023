import 'package:sectec30/config/constants/constants.dart';
import 'package:flutter/material.dart';

const scaffoldBackgroundColor = Color(0xFFF8F7F7);

class AppTheme {
  ThemeData getTheme() => ThemeData(
        ///* General
        useMaterial3: true,
        colorSchemeSeed: primaryColor,

        ///* Scaffold Background Color

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: primaryColor, foregroundColor: Colors.white),

        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ))),

        inputDecorationTheme: const InputDecorationTheme(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: softGrey, width: 0),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: softGrey, width: 0),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: softGrey, width: 0),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: softGrey, width: 0),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: softGrey, width: 0),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: softGrey, width: 0),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
        ),

        ///* AppBar
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
              color: Colors.white //OR Colors.red or whatever you want
              ),
          titleTextStyle: TextStyle(fontSize: 18, color: Colors.white),
          backgroundColor: primaryColor,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      );
}
