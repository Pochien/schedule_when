import 'package:flutter/material.dart';
//
import 'package:schedule_when/presentation/screens/main_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainScreen(currentIndex: 0));

      default:
        return null;
    }
  }
}
