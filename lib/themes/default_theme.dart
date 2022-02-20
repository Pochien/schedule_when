import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefalutTheme {
  static AppBarTheme appBarTheme = const AppBarTheme(
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.light));

  static Color backgroundColor =
      //const Color.fromRGBO(250, 250, 250, 1); // Color(0xF2F4FCFF),
      const Color.fromRGBO(250, 248, 240, 1); // Color(0xF2F4FCFF),

  static Color viewBGColor = const Color.fromRGBO(250, 248, 240, 1);
}
