import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

/// Class for handling events store to local file.
class EventStorage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/events.json');
  }

  Future<File> writeCalendarEvents(String jsonString) async {
    final file = await localFile;
    // write to file
    // debugPrint('write contents: $jsonString');
    return file.writeAsString(jsonString);
  }

  Future<String> readCalendarEvents() async {
    try {
      final file = await localFile;
      var fileExist = await file.exists();
      if (fileExist) {
        // Read the fle.
        final contents = await file.readAsString();
        return contents;
      } else {
        await writeCalendarEvents("[]");
        return "[]";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
