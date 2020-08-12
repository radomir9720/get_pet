import 'package:flutter/material.dart';

enum AppTheme { light, dark }

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.light: ThemeData(
    brightness: Brightness.light,
    accentColor: Colors.orange[600],
    primaryColor: Colors.white,
    highlightColor: Colors.grey.withOpacity(0.3),
    splashColor: Colors.transparent,
    fontFamily: 'MontserratAlternates',
    scaffoldBackgroundColor: const Color(0xffF6F6F6),
    errorColor: Colors.red[700],
    appBarTheme: const AppBarTheme(
      // color: Color(0xffF6AE6C),
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 25.0,
          fontFamily: 'MontserratAlternates',
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyText2: TextStyle(
        fontWeight: FontWeight.w500,
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 35,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    // pageTransitionsTheme: const PageTransitionsTheme(
    //   builders: {
    //     TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
    //   },
    // ),
  ),
  AppTheme.dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    accentColor: Colors.blueAccent,
    toggleableActiveColor: Colors.blueAccent,
    cardColor: const Color(0xff424141),
    highlightColor: Colors.grey.withOpacity(0.3),
    splashColor: Colors.transparent,
    errorColor: const Color(0xffE4695D),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Color(0xff424141),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: const TextTheme(
      headline3: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 35,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  ),
};
