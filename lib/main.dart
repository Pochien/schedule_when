import 'dart:convert';
import 'package:flutter/material.dart';
//
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:schedule_when/extension/dcalendar_storage.dart';
import 'package:schedule_when/model/event.dart';
import 'package:schedule_when/globals.dart' as globals;
import 'package:schedule_when/presentation/app_router.dart';
import 'package:schedule_when/services/navigation_service.dart';
import 'package:schedule_when/themes/default_theme.dart';

void main() async {
  GetIt.I.registerSingleton<NavigationService>(NavigationService());
  WidgetsFlutterBinding.ensureInitialized();

  /// global variable initialzed.
  globals.downloadDuration =
      await globals.getIntFromSharedPref("Duration", globals.downloadDuration);
  globals.remark =
      await globals.getStringFromSharedPref("Remark", globals.remark);

  int _clockStart = await globals.getIntFromSharedPref(
      "ClockStart", globals.displayClockStart);
  int _clockEnd =
      await globals.getIntFromSharedPref("ClockEnd", globals.displayClockEnd);

  /// Get device calendars from local file. (dcalendars.json)
  DeviceCalendarStorage().readDeviceCalendars().then((value) {
    globals.groupedDeviceCalendars = jsonDecode(value);
  });

  /// Run App.
  runApp(MyApp(
    clockStart: _clockStart,
    clockEnd: _clockEnd,
  ));
}

class MyApp extends StatefulWidget {
  final int clockStart;
  final int clockEnd;
  const MyApp({Key? key, required this.clockStart, required this.clockEnd})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  void initState() {
    /// 鎖定豎屏.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    /// global variable initialzed.
    globals.displayClockStart = widget.clockStart;
    globals.displayClockEnd = widget.clockEnd;

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Event>(
      // controller: EventController<Event>()..addAll(_events),
      controller: globals.eventController,
      child: MaterialApp(
        title: 'Sort Out When',
        theme: ThemeData(
            appBarTheme: DefalutTheme.appBarTheme,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: DefalutTheme.backgroundColor),
        navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
        onGenerateRoute: _appRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
