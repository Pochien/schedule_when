import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// App所定義的行事曆類別.
class SortOutCalendar {
  String? id;
  String? name;
  List<SortOutEvent>? events;

  SortOutCalendar({this.id, this.name, this.events = const []});

  /// Json序列化為物件.
  factory SortOutCalendar.fromJson(Map<String, dynamic> parsedJson) {
    // debugPrint("parsedJson:\n${json.encode(parsedJson)}");
    var _events = json.decode(parsedJson['events']) as List;
    List<SortOutEvent> _eventList =
        _events.map((t) => SortOutEvent.fromJson(t)).toList();

    return SortOutCalendar(
        id: parsedJson['id'], name: parsedJson['name'], events: _eventList);
  }

  Map<String, dynamic> toMap() {
    var jsonEvents = jsonEncode(events?.map((e) => e.toMap()).toList());
    return {'id': id, 'name': name, 'events': jsonEvents};
  }
}

/// SortOutEvent
class SortOutEvent {
  String? id;
  String? title;
  String? description;
  Color? color;
  DateTime? date;
  DateTime? startTime;
  DateTime? endTime;

  SortOutEvent(
      {this.id,
      this.title = "",
      this.description = "",
      this.color = Colors.grey,
      this.date,
      this.startTime,
      this.endTime});

  /// User de-serialization from Json to object.
  factory SortOutEvent.fromJson(Map<String, dynamic> parsedJson) {
    return SortOutEvent(
        id: parsedJson['id'].toString(),
        title: parsedJson['title'].toString(),
        description: parsedJson['description'].toString(),
        color: colorFromHex(parsedJson['color'].toString()),
        date: DateTime.parse(parsedJson['date']),
        startTime: DateTime.parse(parsedJson['startTime']),
        endTime: DateTime.parse(parsedJson['endTime']));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'color': colorToHex(color!),
      'date': date!.toIso8601String(),
      'startTime': startTime!.toIso8601String(),
      'endTime': endTime!.toIso8601String(),
    };
  }
}
