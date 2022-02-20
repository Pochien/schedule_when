import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
//
import 'package:schedule_when/extension/extension.dart';
import 'package:schedule_when/model/event.dart';
import 'package:schedule_when/presentation/widgets/update_event_widget.dart';
import 'package:schedule_when/themes/default_theme.dart';

class UpdateEventPage extends StatefulWidget {
  final bool withDuration;
  final List<CalendarEventData<Event>> events;
  final DateTime date;

  const UpdateEventPage({
    Key? key,
    required this.events,
    required this.date,
    this.withDuration = false,
  }) : super(key: key);

  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Event',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: DefalutTheme.viewBGColor,
        foregroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: UpdateEventWidget(
          onEventUpdate: context.pop,
          events: widget.events,
          date: widget.date,
        ),
      ),
    );
  }
}
