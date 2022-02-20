library globals;

import 'package:calendar_view/calendar_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/event.dart';

/// global中的設定主要作為預設設定值,
List groupedDeviceCalendars = [];

/// 其實不在globals中設定維護也可以的.
EventController<Event> eventController = EventController<Event>();

/// 並使用shared_preferences進行本地儲存.
/// 從手機行事曆下載的事件間隔天數.
int downloadDuration = 15;

/// 會議前加入前置時間.(The unit is minute)
int leadtime = 15;

/// 會議前加入前置時間.
bool isLeadtimeAdded = false;

/// SortOut Calendar上要顯示的起始時(hour)
int displayClockStart = 8;

/// SortOut Calendar上要顯示的結束時(hour)
int displayClockEnd = 20;

/// SortOut Calendar remark
String remark = 'My time was ocupied in the calendar';

/// Get int value from SharedPreference.
Future<int> getIntFromSharedPref(String variableName, int defaultValue) async {
  final prefs = await SharedPreferences.getInstance();

  /// Get value from SharedPreferences
  final value = prefs.getInt(variableName);
  return (value == null) ? defaultValue : value;
}

/// Get String value from SharedPreference.
Future<String> getStringFromSharedPref(
    String variableName, String defaultValue) async {
  final prefs = await SharedPreferences.getInstance();

  /// Get value from SharedPreferences
  final value = prefs.getString(variableName);
  return (value == null) ? defaultValue : value;
}
