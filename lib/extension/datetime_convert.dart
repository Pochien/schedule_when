import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
//
import 'package:timezone/timezone.dart';

class DateTimeConverter {
  Future<String> get timezone async {
    String _timezone = 'Etc/UTC';
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      debugPrint('Could not get the local timezone');
    }
    return _timezone;
  }

  Future<TZDateTime> convertTZDatetimeToDatetime(TZDateTime tzDatetime) async {
    String _timezone = await timezone;
    var date =
        DateTime(tzDatetime.year, tzDatetime.month, tzDatetime.day, 0, 0, 0);
    // allDay events on Android need to be at midnight UTC
    var returnDate = Platform.isAndroid
        ? TZDateTime.utc(tzDatetime.year, tzDatetime.month, tzDatetime.day,
            tzDatetime.hour, tzDatetime.minute, tzDatetime.second)
        : TZDateTime.from(
            date, timeZoneDatabase.locations[tzDatetime.location.name]!);
    var endTime = TimeOfDay(hour: returnDate.hour, minute: returnDate.minute);
    return _combineDateWithTime(returnDate, endTime, _timezone)!;
  }

  TZDateTime? _combineDateWithTime(
      TZDateTime? date, TimeOfDay? time, String timezone) {
    if (date == null) return null;

    debugPrint('timezone: $timezone');
    var currentLocation = timeZoneDatabase.locations[timezone];
    debugPrint('currentLocation: $currentLocation');

    final dateWithoutTime = TZDateTime.from(
        DateTime.parse(DateFormat('y-MM-dd 00:00:00').format(date)),
        currentLocation!);

    if (time == null) return dateWithoutTime;
    //if (Platform.isAndroid && _event?.allDay == true) return dateWithoutTime;

    return dateWithoutTime
        .add(Duration(hours: time.hour, minutes: time.minute));
  }
}
