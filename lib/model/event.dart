import 'package:flutter/foundation.dart';

@immutable
class Event {
  final String? eventId;
  final String title;

  const Event({this.eventId, this.title = "Title"});

  @override
  bool operator ==(Object other) => other is Event && title == other.title;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  @override
  String toString() => title;
}
