import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final customLightTheme = ThemeData(
  drawerTheme: DrawerThemeData(backgroundColor: Colors.blue),
    buttonTheme: const ButtonThemeData().copyWith(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.white),
        minWidth: 100,
        height: 40,
        textTheme: ButtonTextTheme.primary),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            )))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)))),
    backgroundColor: Colors.white,
    inputDecorationTheme: const InputDecorationTheme().copyWith(
        border: OutlineInputBorder()
            .copyWith(borderSide: BorderSide().copyWith(color: Colors.blue))),
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    errorColor: Colors.red,
    platform: defaultTargetPlatform,
    primaryColor: Colors.black,
    primarySwatch: Colors.blue,
    primaryIconTheme: const IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue, brightness: Brightness.light)
        .copyWith(secondary: Colors.white54),
    accentIconTheme: const IconThemeData(color: Colors.black),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromRGBO(37, 112, 252, 1)),
    unselectedWidgetColor: Colors.grey,
    brightness: Brightness.light,
    secondaryHeaderColor: const Color.fromRGBO(37, 112, 252, 1),
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.black.withOpacity(.5),
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        titleTextStyle: TextStyle(color: Colors.blue)),
    textTheme:
        Typography.material2018(platform: defaultTargetPlatform).white.copyWith(
              bodyText1: const TextStyle(color: Colors.black, fontSize: 16),
              bodyText2: const TextStyle(color: Colors.black, fontSize: 14),
              caption: const TextStyle(color: Colors.black, fontSize: 12),
              headline1: const TextStyle(color: Colors.black, fontSize: 96),
              headline2: const TextStyle(color: Colors.black, fontSize: 60),
              headline3: const TextStyle(color: Colors.black, fontSize: 48),
              headline4: const TextStyle(color: Colors.black, fontSize: 34),
              headline5: const TextStyle(color: Colors.black, fontSize: 24),
              headline6: const TextStyle(color: Colors.black, fontSize: 20),
              subtitle1: const TextStyle(color: Colors.black, fontSize: 16),
              subtitle2: const TextStyle(color: Colors.black, fontSize: 14),
              overline: const TextStyle(color: Colors.black, fontSize: 10),
              button: const TextStyle(color: Colors.black, fontSize: 16),
            ),
    dividerColor: Colors.grey);

final customDarkTheme = ThemeData(
    buttonTheme: const ButtonThemeData().copyWith(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.red),
        minWidth: 100,
        height: 40,
        textTheme: ButtonTextTheme.primary),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)))),
    inputDecorationTheme: const InputDecorationTheme().copyWith(
        border: OutlineInputBorder()
            .copyWith(borderSide: BorderSide().copyWith(color: Colors.blue))),
    backgroundColor: const Color(0xFF021B3A),
    scaffoldBackgroundColor: const Color(0xFF021B3A),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    cursorColor: const Color.fromRGBO(105, 73, 199, 1),
    errorColor: const Color(0xFFCF6679),
    primaryColor: Colors.white,
    primaryIconTheme: const IconThemeData(color: Colors.white),
    accentIconTheme: const IconThemeData(color: Colors.grey),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1)),
    platform: defaultTargetPlatform,
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue, brightness: Brightness.dark)
        .copyWith(secondary: Colors.white54),
    unselectedWidgetColor: Colors.grey,
    brightness: Brightness.dark,
    secondaryHeaderColor: const Color.fromRGBO(31, 31, 50, 1),
    cardColor: const Color.fromRGBO(31, 31, 31, 1),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white.withOpacity(.7),
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.white,
        titleTextStyle: TextStyle(color: Colors.white)),
    textTheme:
        Typography.material2018(platform: defaultTargetPlatform).white.copyWith(
              bodyText1: const TextStyle(color: Colors.white, fontSize: 16),
              bodyText2: const TextStyle(color: Colors.white, fontSize: 14),
              caption: const TextStyle(color: Colors.white, fontSize: 12),
              headline1: const TextStyle(color: Colors.white, fontSize: 96),
              headline2: const TextStyle(color: Colors.white, fontSize: 60),
              headline3: const TextStyle(color: Colors.white, fontSize: 48),
              headline4: const TextStyle(color: Colors.white, fontSize: 34),
              headline5: const TextStyle(color: Colors.white, fontSize: 24),
              headline6: const TextStyle(color: Colors.white, fontSize: 20),
              subtitle1: const TextStyle(color: Colors.white, fontSize: 16),
              subtitle2: const TextStyle(color: Colors.white, fontSize: 14),
              overline: const TextStyle(color: Colors.white, fontSize: 10),
              button: const TextStyle(color: Colors.white, fontSize: 16),
            ),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white.withOpacity(.6));
