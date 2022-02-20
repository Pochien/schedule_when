import 'dart:convert';
import 'package:flutter/material.dart';
//
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:schedule_when/extension/app_colors.dart';
import 'package:schedule_when/extension/constants.dart';
import 'package:schedule_when/extension/event_storage.dart';
import 'package:schedule_when/model/event.dart';
import 'package:schedule_when/globals.dart' as globals;
import 'package:schedule_when/model/sortout_event.dart';

import 'datetime_selector.dart';
import 'custom_button.dart';

class UpdateEventWidget extends StatefulWidget {
  final void Function(CalendarEventData<Event>)? onEventUpdate;
  final List<CalendarEventData<Event>> events;
  final DateTime date;

  const UpdateEventWidget({
    Key? key,
    this.onEventUpdate,
    required this.events,
    required this.date,
  }) : super(key: key);

  @override
  _UpdateEventWidgetState createState() => _UpdateEventWidgetState();
}

class _UpdateEventWidgetState extends State<UpdateEventWidget> {
  late DateTime _date;

  DateTime? _startTime;

  DateTime? _endTime;

  late FocusNode _dateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();

    _dateNode = FocusNode();

    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();

    /// check events
    // debugPrint("events: ${widget.events}");
  }

  @override
  void dispose() {
    _dateNode.dispose();

    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Event Info Initialize.
    if (widget.events.isNotEmpty) {
      _dateController.text =
          "${widget.events[0].date.day}/${widget.events[0].date.month}/${widget.events[0].date.year}";
      _startTimeController.text =
          DateFormat('hh:mm a').format(widget.events[0].startTime!);
      _endTimeController.text =
          DateFormat('hh:mm a').format(widget.events[0].endTime!);
    }

    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 15,
          ),
          // Date
          DateTimeSelectorFormField(
            controller: _dateController,
            decoration: AppConstants.inputDecoration.copyWith(
              labelText: "Select Date",
            ),
            validator: (value) {
              if (value == null || value == "") return "Please select date.";

              return null;
            },
            textStyle: const TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            onSave: (date) {
              // debugPrint("date: ${date.toLocal()}");
              setState(() {
                _date = date;
              });
            },
            type: DateTimeSelectionType.date,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              // Start Time
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _startTimeController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Start Time",
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please select start time.";
                    }

                    return null;
                  },
                  // onSave: (date) => _startTime = date,
                  onSave: (date) {
                    DateTime startTime = DateFormat('yyyy/MM/dd hh:mm aaa').parse(
                        "${_date.year}/${_date.month}/${_date.day} ${_startTimeController.text}");
                    // Check startTime
                    // debugPrint("starttime: ${startTime.toLocal()}");
                    setState(() {
                      _startTime = startTime;
                    });
                  },
                  textStyle: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
              const SizedBox(width: 20.0),
              // End Time
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _endTimeController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "End Time",
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please select end time.";
                    }

                    return null;
                  },
                  // onSave: (date) => _endTime = date,
                  onSave: (date) {
                    setState(() {
                      DateTime endTime = DateFormat('yyyy/MM/dd hh:mm aaa').parse(
                          "${_date.year}/${_date.month}/${_date.day} ${_endTimeController.text}");
                      // Check startTime
                      // debugPrint("starttime: ${endTime.toLocal()}");
                      setState(() {
                        _endTime = endTime;
                      });
                    });
                  },

                  textStyle: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 30,
          ),
          // Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                onTap: _updateEvent,
                title: "Update",
              ),
              const SizedBox(width: 20),
              CustomButton(
                onTap: _deleteEvent,
                title: "Delete",
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Update event.
  void _updateEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    EventStorage eventStorage = EventStorage();

    /// DateTime check
    // debugPrint(
    //     "_startTime: ${_startTime!.toLocal()}, _endTime: ${_endTime!.toLocal()}");

    /// udpate event
    final event = CalendarEventData<Event>(
      eventId: widget.events[0].eventId,
      date: DateTime(_date.year, _date.month, _date.day),
      // endDate: DateTime(_date.year, _date.month, _date.day),
      color: AppColors.updatedEventTileColor,
      startTime: DateTime(_date.year, _date.month, _date.day, _startTime!.hour,
          _startTime!.minute),
      endTime: DateTime(
          _date.year, _date.month, _date.day, _endTime!.hour, _endTime!.minute),
      title: "",
      event: const Event(title: ""),
    );

    // 讀取Event local events.json file.
    eventStorage.readCalendarEvents().then((value) {
      var events = jsonDecode(value) as List;
      List<SortOutEvent> eventList =
          events.map((t) => SortOutEvent.fromJson(t)).toList();

      SortOutEvent updatedEvent = SortOutEvent(
        id: event.eventId,
        date: DateTime(event.date.year, event.date.month, event.date.day),
        startTime: DateTime(event.date.year, event.date.month, event.date.day,
            event.startTime!.hour, event.startTime!.minute),
        endTime: DateTime(event.date.year, event.date.month, event.date.day,
            event.endTime!.hour, event.endTime!.minute),
        color: event.color,
      );

      var index = eventList.indexWhere((item) => item.id == event.eventId);

      if (index < 0) return;
      eventList[eventList.indexWhere((item) => item.id == event.eventId)] =
          updatedEvent;

      /// Update events to local events.json file.
      var jsonEvents = jsonEncode(eventList.map((e) => e.toMap()).toList());
      // debugPrint("updating jsonEvents in update(): $jsonEvents");
      eventStorage.writeCalendarEvents(jsonEvents);
    }).whenComplete(() {
      globals.eventController.remove(widget.events[0]);
      globals.eventController.add(event);
    });

    /// Callback
    widget.onEventUpdate?.call(event);
    // Navigator.of(context).pop();
  }

  /// Delete Event
  void _deleteEvent() {
    EventStorage eventStorage = EventStorage();

    // 讀取Event local events.json file.
    eventStorage.readCalendarEvents().then((value) {
      var events = jsonDecode(value) as List;
      List<SortOutEvent> eventList =
          events.map((t) => SortOutEvent.fromJson(t)).toList();

      eventList.removeWhere((item) => item.id == widget.events[0].eventId);

      /// Update events to local events.json file.
      var jsonEvents = jsonEncode(eventList.map((e) => e.toMap()).toList());
      // debugPrint("updating jsonEvents in delete(): $jsonEvents");
      eventStorage.writeCalendarEvents(jsonEvents);
    }).whenComplete(() {
      globals.eventController.remove(widget.events[0]);
    });

    /// Callback
    widget.onEventUpdate?.call(widget.events[0]);
    // Navigator.of(context).pop();
  }
}
