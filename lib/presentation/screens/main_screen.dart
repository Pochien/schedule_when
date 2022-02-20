// ignore_for_file: constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
//
import 'package:schedule_when/extension/app_colors.dart';
import 'package:schedule_when/presentation/pages/calendar.dart';
import 'package:schedule_when/presentation/pages/device_calendar.dart';
import 'package:schedule_when/presentation/pages/settings.dart';

class MainScreen extends StatefulWidget {
  late int currentIndex;
  MainScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _barItems = [
    const CalendarPage(),
    const DeviceCalendarPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _barItems[widget.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.naviBarBGColor,
        selectedItemColor: AppColors.naviBatSelectedColor,
        unselectedItemColor: AppColors.naviBatUnselectedColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_week), label: "When"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
        currentIndex: widget.currentIndex,
        onTap: (int index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
      ),
    );
  }
}
