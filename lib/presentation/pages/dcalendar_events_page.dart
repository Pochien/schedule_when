import 'package:flutter/material.dart';
//
import 'package:device_calendar/device_calendar.dart' as device_calendar;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_when/model/sortout_event.dart';
import 'package:schedule_when/globals.dart' as globals;

class CalendarEventsPage extends StatefulWidget {
  final device_calendar.Calendar calendar;

  const CalendarEventsPage({Key? key, required this.calendar})
      : super(key: key);

  @override
  _CalendarEventsPageState createState() => _CalendarEventsPageState();
}

class _CalendarEventsPageState extends State<CalendarEventsPage> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  //
  late device_calendar.DeviceCalendarPlugin _deviceCalendarPlugin;
  bool _isLoading = true;

  _CalendarEventsPageState() {
    _deviceCalendarPlugin = device_calendar.DeviceCalendarPlugin();
  }

  late SortOutCalendar _sortOutCalendar = SortOutCalendar();
  late int _duration = 15;

  @override
  void initState() {
    super.initState();

    /// Get data from SharedPreference.
    _getIntFromSharedPref("Duration", globals.downloadDuration).then(
      (value) => {
        setState(() {
          _duration = value;
          // Retrieve events from device selected calendar account.
          _retrieveCalendarEvents();
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${widget.calendar.name} events',
          style: const TextStyle(color: Colors.black54),
        ),
        backgroundColor: const Color.fromRGBO(250, 248, 240, 1),
        foregroundColor: Colors.grey,
      ),
      body: ((_sortOutCalendar.events != null) || _isLoading)
          ? Stack(
              children: [
                ListView.builder(
                  itemCount: _sortOutCalendar.events!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shadowColor: Colors.grey,
                      child: ListTile(
                        leading: const Icon(Icons.event, size: 20.0),
                        title: Text(_sortOutCalendar.events![index].title ??
                            'No title!'),
                        subtitle: Column(
                          children: [
                            Text(
                                'duration: ${_sortOutCalendar.events![index].startTime!}-${_sortOutCalendar.events![index].endTime!}'),
                            const Divider(
                              color: Colors.grey,
                            ),
                            Text(_sortOutCalendar.events![index].description ??
                                ""),
                          ],
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                    );
                  },
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            )
          : const Center(
              child: Text("No events found"),
            ),
    );
  }

  /// To get device calendar within duration days by device_calendar.
  Future _retrieveCalendarEvents() async {
    /// Check download duration
    // debugPrint("Download durarion: $_duration");

    // Get all events during the duration.
    DateTime now = DateTime.now();
    final startDate =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 0));
    final endDate = DateTime.now().add(Duration(days: _duration));

    /// Retrieve events
    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        widget.calendar.id,
        device_calendar.RetrieveEventsParams(
            startDate: startDate, endDate: endDate));

    /// Check result then add events to SortOutCalendar
    List<SortOutEvent> eventList = [];
    if (calendarEventsResult.isSuccess) {
      for (var e in calendarEventsResult.data!) {
        // timestamp
        var tsStart = e.start!.millisecondsSinceEpoch;
        var tsEnd = e.end!.millisecondsSinceEpoch;
        // Convert to datetime from timestamp.
        var _startTime = DateTime.fromMillisecondsSinceEpoch(tsStart);
        var _startDate =
            DateTime(_startTime.year, _startTime.month, _startTime.day);
        var _endTime = DateTime.fromMillisecondsSinceEpoch(tsEnd);
        //var _endDate = DateTime(_endTime.year, _endTime.month, _endTime.day);

        eventList.add(SortOutEvent(
            id: e.eventId,
            title: e.title,
            description: e.description,
            date: _startDate,
            startTime: _startTime,
            endTime: _endTime));
      }
    }

    setState(() {
      // Convert to SortOutCalendar
      _sortOutCalendar = SortOutCalendar(
          id: widget.calendar.id,
          name: widget.calendar.name,
          events: eventList);
      _isLoading = false;
    });
  }

  /// To get int value from SharedPreference.
  Future<int> _getIntFromSharedPref(
      String variableName, int defaultValue) async {
    final prefs = await SharedPreferences.getInstance();

    /// Get value from SharedPreferences
    final value = prefs.getInt(variableName);

    if (value == null) {
      return defaultValue;
    }
    return value;
  }
}
