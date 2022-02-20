// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get navigator => navigatorKey.currentState;

  Future<dynamic> push(Widget page) {
    return navigator!.push(MaterialPageRoute(builder: (context) => page));
  }

  Future<dynamic> pushReplacement(Widget page) {
    return navigator!
        .pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  Future<dynamic> present(Widget page) {
    return navigator!.push(
        MaterialPageRoute(fullscreenDialog: true, builder: (context) => page));
  }

  Future<dynamic> navigatorTo(String routeName) {
    return navigator!.pushNamed(routeName);
  }

  void goBack() {
    return navigator!.pop();
  }
}
