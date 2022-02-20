import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//
// import 'package:calendar_view/calendar_view.dart' as calendar_view;
import 'package:device_calendar/device_calendar.dart' as device_calendar;
import 'package:grouped_list/grouped_list.dart';
import 'package:schedule_when/extension/app_colors.dart';
import 'package:schedule_when/extension/dcalendar_storage.dart';
import 'package:schedule_when/extension/event_storage.dart';
import 'package:schedule_when/model/sortout_event.dart';
// import 'package:schedule_when/model/event.dart' as model;
import 'package:schedule_when/presentation/pages/dcalendar_events_page.dart';
import 'package:schedule_when/globals.dart' as globals;
import 'package:schedule_when/themes/default_theme.dart';

/// View for listing all device calendars account.
class DeviceCalendarView extends StatefulWidget {
  const DeviceCalendarView({Key? key}) : super(key: key);

  @override
  _DeviceCalendarViewState createState() => _DeviceCalendarViewState();
}

class _DeviceCalendarViewState extends State<DeviceCalendarView> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  //
  // ignore: unused_field
  late device_calendar.DeviceCalendarPlugin _deviceCalendarPlugin;
  List<device_calendar.Calendar> _calendars = [];
  DeviceCalendarStorage dcalStorage = DeviceCalendarStorage();
  EventStorage eventStorage = EventStorage();

  // ignore: unused_element
  List<device_calendar.Calendar> get _writableCalendars =>
      _calendars.where((c) => c.isReadOnly == false).toList();

  // ignore: unused_element
  List<device_calendar.Calendar> get _readOnlyCalendars =>
      _calendars.where((c) => c.isReadOnly == true).toList();

  _DeviceCalendarViewState() {
    _deviceCalendarPlugin = device_calendar.DeviceCalendarPlugin();
  }

  @override
  void initState() {
    super.initState();

    /// Retrieve all device calendars.
    _retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    ///
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Calendars',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: DefalutTheme.viewBGColor,
        foregroundColor: AppColors.appBarIconColor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          /// Retrieve device calendars (without events)
          // IconButton(
          //   icon: const Icon(Icons.refresh_outlined),
          //   onPressed: () async {
          //     /// Retrieven device calendars only.(without update events)
          //     _retrieveCalendars();
          //   },
          // ),

          /// Read device calendars from local dcalendars.json file.
          // IconButton(
          //   icon: const Icon(Icons.read_more),
          //   onPressed: () async {
          //     dcalStorage.readDeviceCalendars().then((value) {
          //       debugPrint("global.groupedDeviceCalendars: $value");
          //     });
          //   },
          // ),

          /// Download all selected calendars's events to local event storage file.
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              _downloadSelectedCalendarEvents();
            },
          ),
        ],
      ),
      body: GroupedListView<dynamic, String>(
        elements: globals.groupedDeviceCalendars,
        groupBy: (element) => element["group"],
        groupComparator: (value1, value2) => value2.compareTo(value1),
        itemComparator: (item1, item2) =>
            item1["name"].compareTo(item2["name"]),
        order: GroupedListOrder.ASC,
        useStickyGroupSeparators: true,

        /// Group value
        groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 30,
              child: Text(
                value,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            )),
        itemBuilder: (ctx, element) {
          return SizedBox(
            height: 60,
            child: Card(
              child: ListTile(
                leading: Checkbox(
                  // tristate: true,
                  value: (element["isSelected"] != null)
                      ? element["isSelected"]
                      : false,
                  onChanged: (value) {
                    element["isSelected"] =
                        (value == null) ? element["isSelected"] : value;
                    setState(() {
                      element["isSelected"] = value;
                      // update device calendars to local files.
                      dcalStorage.writeDeviceCalendars(
                          jsonEncode(globals.groupedDeviceCalendars));
                    });
                  },
                ),
                title: Row(
                  children: [
                    Icon(element["isReadOnly"] == true
                        ? Icons.lock
                        : Icons.lock_open),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(element["name"], style: const TextStyle(fontSize: 12)),
                  ],
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarEventsPage(
                        calendar: _calendars
                            .where((item) => item.id == element["id"])
                            .first,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  /// 讀取手機上的行事曆帳戶清單.
  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult.data as List<device_calendar.Calendar>;

        for (var c in _calendars) {
          /// globals.groupedDeviceCalendars不使用清空的方式, 重新加入calendar, 以確保選取項目的保留.
          var contain = globals.groupedDeviceCalendars
              .where((element) => element["id"] == c.id);
          if (contain.isEmpty) {
            /// global variables
            globals.groupedDeviceCalendars.add({
              "id": c.id,
              "group": c.accountName,
              "name": c.name,
              "isReadOnly": c.isReadOnly,
              "isSelected": false,
            });
          }
        }

        /// update groupedDeviceCalendars to local file.
        dcalStorage
            .writeDeviceCalendars(jsonEncode(globals.groupedDeviceCalendars));
      });
    } on PlatformException catch (e) {
      debugPrint(e.stacktrace);
    }
  }

  /// Retrieve events from selected calendars.
  Future<List<SortOutEvent>> _retrieveSelectedCalendarEvents() async {
    /// Check download duration
    // debugPrint("Download duration: ${globals.downloadDuration}");

    /// Get all events during the duration.
    DateTime now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    final endDate = startDate.add(Duration(days: globals.downloadDuration));

    /// Calendar duration
    // debugPrint(
    //     "Retrieve events' duration: ${startDate.toLocal()}-${endDate.toLocal()}");

    /// Check result then add events to SortOutCalendar
    List<SortOutEvent> eventList = [];

    /// Retrieve events from selected device calendars.
    for (var element in globals.groupedDeviceCalendars
        .where((item) => item["isSelected"] == true)) {
      device_calendar.Calendar deviceCalendar =
          _calendars.firstWhere((item) => item.id == element["id"]);

      // ignore: unnecessary_null_comparison
      if (deviceCalendar != null) {
        var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
            element["id"],
            device_calendar.RetrieveEventsParams(
                startDate: startDate, endDate: endDate));
        // calendar request success.
        if (calendarEventsResult.isSuccess) {
          for (var event in calendarEventsResult.data!) {
            // timestamp
            var tsStart = event.start!.millisecondsSinceEpoch;
            var tsEnd = event.end!.millisecondsSinceEpoch;
            // Convert to datetime from timestamp.
            var _startTime = DateTime.fromMillisecondsSinceEpoch(tsStart);
            var _startDate =
                DateTime(_startTime.year, _startTime.month, _startTime.day);
            var _endTime = DateTime.fromMillisecondsSinceEpoch(tsEnd);
            // var _endDate = DateTime(_endTime.year, _endTime.month, _endTime.day);

            /// Add sortout event to list
            eventList.add(SortOutEvent(
                id: event.eventId,
                title: event.title,
                description: event.description,
                date: _startDate,
                startTime: _startTime,
                endTime: _endTime));
          }
        }
      }
    }
    return eventList;
  }

  /// Download device calendar events, and add events to local events.json file.
  Future<void> _downloadSelectedCalendarEvents() async {
    /// debug print.
    // debugPrint(
    //     "Download selected calendars' events to local events.json file ...");

    List<SortOutEvent> localEventList = [];

    /// Retrieve events.
    // debugPrint("Retrieve event from selected celendar account...");
    await _retrieveSelectedCalendarEvents().then((downloadedEvents) {
      // debugPrint("_retrieveSelectedCalendarEvents result: $downloadedEvents");

      /// Check eventList.
      if (downloadedEvents.isEmpty) return;

      /// Convert List<SortOutEvent> to List<String>
      // var jsonEvents =
      //     jsonEncode(downloadedEvents.map((e) => e.toMap()).toList());
      // debugPrint("DownloadedEvents result jasonString: $jsonEvents");

      /// Write to local events storage after compare local events.json file.
      /// first: read contents out.
      eventStorage.readCalendarEvents().then((value) {
        // local events.json file
        // debugPrint("Local events: $value");

        var localEvents = jsonDecode(value) as List;
        localEventList =
            localEvents.map((t) => SortOutEvent.fromJson(t)).toList();

        /// Compare download events and local events.
        /// If downloaded event does not include in local events, then add it
        /// to local events.
        for (var event in downloadedEvents) {
          var eventCheck = localEventList.where((item) => item.id == event.id);
          // 下載的事件不存在於local檔案內.
          if (eventCheck.isEmpty) {
            localEventList.add(event);
          }
        }
      }).whenComplete(() {
        // Update to local events.json file.
        var jsonEvents =
            jsonEncode(localEventList.map((e) => e.toMap()).toList());
        eventStorage.writeCalendarEvents(jsonEvents);
      });
    });
  }
}
