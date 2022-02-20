import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

/// Class for handling device clendar store to local file.
class DeviceCalendarStorage {
  /// Get local file path.
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// Get local file for saving device calendar list.
  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/dcalendars.json');
  }

  /// Write device calendars to local file.
  Future<File> writeDeviceCalendars(String jsonString) async {
    final file = await localFile;
    // write to file
    // debugPrint('write device calendars: $jsonString');
    return file.writeAsString(jsonString);
  }

  /// Read device calendars from local file.
  Future<String> readDeviceCalendars() async {
    try {
      final file = await localFile;
      var fileExist = await file.exists();
      if (fileExist) {
        // Read the fle.
        final contents = await file.readAsString();
        return contents;
      } else {
        await writeDeviceCalendars("[]");
        return "[]";
      }

      // final file = await localFile;
      // // Read the fle.
      // final contents = await file.readAsString();
      // return contents;
    } catch (e) {
      return e.toString();
    }
  }
}
