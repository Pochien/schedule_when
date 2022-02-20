import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
//
import 'package:calendar_view/calendar_view.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:schedule_when/extension/app_colors.dart';
import 'package:schedule_when/extension/extension.dart';
import 'package:schedule_when/extension/event_storage.dart';
import 'package:schedule_when/globals.dart' as globals;
import 'package:schedule_when/model/event.dart';
import 'package:schedule_when/model/sortout_event.dart';
import 'package:schedule_when/presentation/pages/create_event.dart';
import 'package:schedule_when/presentation/widgets/screen_container.dart';
import 'package:schedule_when/presentation/widgets/week_view_widget.dart';
import 'package:schedule_when/themes/default_theme.dart';
import 'package:uuid/uuid.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  //
  final ScreenshotController _screenshotController = ScreenshotController();
  final EventStorage _eventStorage = EventStorage();

  @override
  void initState() {
    super.initState();

    /// Load events from local events.json file.
    // debugPrint("Calendar_view initializing...");
    _loadEventsFromFile();
  }

  @override
  Widget build(BuildContext context) {
    /// WeekViewWidget have to put into CalendarControllerProvider scope.
    WeekViewWidget _weekViewWidget = WeekViewWidget(
      eventController: globals.eventController,
      clockStart: globals.displayClockStart,
      clockEnd: globals.displayClockEnd,
    );

    double _width = MediaQuery.of(context).size.width;
    double _hourHeight = 60;
    double _height = 150 +
        _hourHeight * (globals.displayClockEnd - globals.displayClockStart);

    /// Default global variable check.
    // debugPrint("globals.remark: ${globals.remark}");
    // debugPrint("globals.clockStart: ${globals.displayClockStart}");
    // debugPrint("globals.clockEnd: ${globals.displayClockEnd}");
    // debugPrint("globals.remark: ${globals.remark}");

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'When',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: DefalutTheme.viewBGColor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          /// Refresh SortOutCalendar
          // IconButton(
          //   icon: const Icon(
          //     Icons.refresh_outlined,
          //     color: AppColors.appBarIconColor,
          //   ),
          //   onPressed: () {
          //     // debugPrint("SortOut event refresh");
          //     setState(() {
          //       // _cleanEvents();
          //       _loadEventsFromFile();
          //       // _loadEvents();
          //     });
          //   },
          // ),

          /// Clean calendars.
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: AppColors.appBarIconColor,
            ),
            onPressed: () {
              // debugPrint("Clean calendar view");
              setState(() {
                _cleanEventsOnClendarView();
              });
            },
          ),

          /// Read device calendars's events from local events.json file.
          // IconButton(
          //   icon: const Icon(Icons.read_more),
          //   color: AppColors.appBarIconColor,
          //   onPressed: () async {
          //     _eventStorage.readCalendarEvents().then((value) {
          //       debugPrint("Local calendar events: $value");
          //     });
          //   },
          // ),

          /// Capture SortOutClendar Image for screen.
          // IconButton(
          //   icon: const Icon(
          //     Icons.screenshot,
          //     color: AppColors.appBarIconColor,
          //   ),
          //   onPressed: () {
          //     _screenshotController
          //         // capture from screen
          //         .capture(delay: const Duration(milliseconds: 10))
          //         .then((capturedImage) async {
          //       _showCapturedWidget(context, capturedImage!);
          //     }).catchError(
          //       (onError) {
          //         debugPrint(onError);
          //       },
          //     );
          //   },
          // ),

          /// Capture widget for long screen.
          IconButton(
            icon: const Icon(
              Icons.camera,
              color: AppColors.appBarIconColor,
            ),
            onPressed: () async {
              _screenshotController
                  .captureFromWidget(
                      ScreenContainer(
                          childHeight: _height, childToScreen: _weekViewWidget),
                      delay: const Duration(seconds: 1),
                      targetSize: Size(_width, _height))
                  .then((capturedImage) {
                _showCapturedWidget(context, capturedImage);
              }).catchError(
                (onError) {
                  debugPrint(onError);
                },
              );
            },
          )
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _weekViewWidget,
            Text(
              globals.remark,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        backgroundColor: AppColors.floatingBottonColor,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /// Add an event to CalendarController.
  Future<void> _addEvent() async {
    // Process message.
    // debugPrint("_addEvent()...");

    /// Call CreateEventPage.
    final event =
        await context.pushRoute<CalendarEventData<Event>>(const CreateEventPage(
      withDuration: true,
    ));
    if (event == null) return;

    // debugPrint("Create call back events: $event");

    // 讀取Event local events.json file.
    _eventStorage.readCalendarEvents().then((value) {
      var events = jsonDecode(value) as List;
      List<SortOutEvent> eventList =
          events.map((t) => SortOutEvent.fromJson(t)).toList();

      SortOutEvent newEvent = SortOutEvent(
          id: const Uuid().v4(),
          date: DateTime(event.date.year, event.date.month, event.date.day),
          startTime: DateTime(event.date.year, event.date.month, event.date.day,
              event.startTime!.hour, event.startTime!.minute),
          endTime: DateTime(event.date.year, event.date.month, event.date.day,
              event.endTime!.hour, event.endTime!.minute),
          color: event.color);

      eventList.add(newEvent);

      /// Update to local events.json file.
      var jsonEvents = jsonEncode(eventList.map((e) => e.toMap()).toList());
      _eventStorage.writeCalendarEvents(jsonEvents);

      /// Add events to controller
      // debugPrint("Adding event: $event");
      _addEventsToController(eventList);
    });
  }

  /// Clean events from CalendarController.
  void _cleanEventsOnClendarView() {
    // debugPrint("_cleanEventsOnClendarView()...");

    // get events in CalendarController
    List<CalendarEventData<Event>> _events = globals.eventController.events;

    /// 使用eventController刪除事件.
    if (_events.isNotEmpty) {
      for (CalendarEventData<Event> event in _events) {
        globals.eventController.remove(event);
      }
    }

    /// Clean local events.json file.
    _eventStorage.writeCalendarEvents("[]");
  }

  /// Load events from local events.json file, then add to calendar_view controller.
  Future<void> _loadEventsFromFile() async {
    //
    _eventStorage.readCalendarEvents().then((value) {
      // debugPrint("local events: $value");
      var events = json.decode(value) as List;
      List<SortOutEvent> eventList =
          events.map((t) => SortOutEvent.fromJson(t)).toList();

      // debugPrint("Local file contents: $value");
      // var jsonEvents = jsonEncode(eventList.map((e) => e.toMap()).toList());
      // debugPrint("jsonEvents in _loadEvents(): $jsonEvents");

      if (eventList.isEmpty) return;

      /// Add events to controller
      _addEventsToController(eventList);
    });
  }

  /// Add all events to CalendarController.
  Future<void> _addEventsToController(List<SortOutEvent> eventList) async {
    /// Null check.
    if (eventList.isEmpty) return;

    List<CalendarEventData<Event>> eventDataList = [];

    /// Add events to calendar_view controller.
    for (var event in eventList) {
      var eventData = CalendarEventData(
        eventId: event.id,
        date: DateTime(event.date!.year, event.date!.month, event.date!.day),
        event: const Event(title: ""),
        color: event.color ?? Colors.grey,
        title: "",
        startTime: DateTime(
            event.startTime!.year,
            event.startTime!.month,
            event.startTime!.day,
            event.startTime!.hour,
            event.startTime!.minute),
        endTime: DateTime(event.endTime!.year, event.endTime!.month,
            event.endTime!.day, event.endTime!.hour, event.endTime!.minute),
      );

      /// Check data
      // debugPrint("Add eventData: $eventData");
      eventDataList.add(eventData);
    }

    if (eventDataList.isEmpty) return;

    /// 因為從local events.json file讀出, 所以應該要先清除完eventController
    globals.eventController.removeAll();

    /// 全部加入.
    globals.eventController.addAll(eventDataList);
  }

  /// Show captured iamge.
  Future<dynamic> _showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "Captured Screen",
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: DefalutTheme.viewBGColor,
          foregroundColor: AppColors.appBarIconColor,
          actions: [
            /// Clean calendars.
            IconButton(
              icon: const Icon(
                Icons.save,
                color: AppColors.appBarIconColor,
              ),
              onPressed: () async {
                await _saveCapturedImage(capturedImage);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Center(
            // ignore: unnecessary_null_comparison
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  /// Save captured image to Photo Gallery.
  Future<void> _saveCapturedImage(Uint8List capturedImage) async {
    try {
      // debugPrint("Saving captured image ...");
      String dir = (await getApplicationDocumentsDirectory()).path;
      String fullPath = "$dir/WHEN_${DateTime.now().microsecond}.png";
      File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(capturedImage);
      // debugPrint("Captured image save to ${capturedFile.path}");

      /// Save image.
      await GallerySaver.saveImage(capturedFile.path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
