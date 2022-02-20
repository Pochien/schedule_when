import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// Default colors.
  static const Color black = Color(0xff626262);
  static const Color radiantWhite = Color(0xffffffff);
  static const Color white = Color(0xfff0f0f0);
  static const Color bluishGrey = Color(0xffdddee9);
  static const Color navyBlue = Color(0xff6471e9);
  static const Color lightNavyBlue = Color(0xffb3b9ed);
  static const Color red = Color(0xfff96c6c);
  static const Color green = Color(0xff4caf50);
  static const Color blue = Color(0xff2196f3);
  static const Color grey = Color(0xffe0e0e0);

  /// AppBar icon color.
  /// v1: Kim design
  // static const Color appBarIconColor = Color(0xffe6aa6a);
  /// v1: Kim design
  static const Color appBarIconColor = Color.fromRGBO(228, 72, 103, 1);

  /// MainScreen NavigationBar Color
  /// v1: Kim design
  // static const Color naviBarBGColor = Color.fromRGBO(230, 170, 106, 1);
  // static const Color naviBatUnselectedColor = Color.fromRGBO(13, 110, 10, 1);
  // static const Color naviBatSelectedColor = Color.fromRGBO(255, 255, 255, 1);
  /// v2: Liwei design
  // static const Color naviBarBGColor = Color.fromRGBO(228, 72, 103, 1);  //  桃紅
  static const Color naviBarBGColor = Color.fromRGBO(160, 205, 226, 1); //  淺藍
  // static const Color naviBarBGColor = Color.fromRGBO(13, 110, 10, 1); //  墨綠
  static const Color naviBatSelectedColor = Color.fromRGBO(228, 72, 103, 1);
  static const Color naviBatUnselectedColor =
      Color.fromRGBO(255, 255, 255, 1); // 白色

  /// Button Color
  // static const Color floatingBottonColor = Colors.blueGrey;
  static const Color floatingBottonColor = Color.fromRGBO(228, 72, 103, 1);

  /// Event tile colors.
  static const Color newEventTileColor = Color(0xff4caf50);
  static const Color updatedEventTileColor = Color(0xff2196f3);
}
