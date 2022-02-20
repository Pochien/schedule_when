import 'package:flutter/material.dart';
//
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:schedule_when/extension/app_colors.dart';
import 'package:schedule_when/extension/constants.dart';
import 'package:schedule_when/model/event.dart';
import 'package:uuid/uuid.dart';

import 'datetime_selector.dart';
import 'custom_button.dart';

class CreateEventWidget extends StatefulWidget {
  final void Function(CalendarEventData<Event>)? onEventCreate;

  const CreateEventWidget({
    Key? key,
    this.onEventCreate,
  }) : super(key: key);

  @override
  _CreateEventWidgetState createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  late DateTime _date;

  DateTime? _startTime;

  DateTime? _endTime;

  late FocusNode _dateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  /// TextEditing controller
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();

    //
    _dateNode = FocusNode();

    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
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
              /// Check date
              // debugPrint("Add event date: ${date.toLocal()}");
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
                    DateTime endTime = DateFormat('yyyy/MM/dd hh:mm aaa').parse(
                        "${_date.year}/${_date.month}/${_date.day} ${_endTimeController.text}");
                    // Check startTime
                    // debugPrint("endtime: ${endTime.toLocal()}");
                    setState(() {
                      _endTime = endTime;
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
          CustomButton(
            onTap: _createEvent,
            title: "Add Event",
          ),
        ],
      ),
    );
  }

  /// Create event.
  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<Event>(
      eventId: const Uuid().v4(),
      date: DateTime(_date.year, _date.month, _date.day),
      color: AppColors.newEventTileColor,
      startTime: DateTime(_date.year, _date.month, _date.day, _startTime!.hour,
          _startTime!.minute),
      endTime: DateTime(
          _date.year, _date.month, _date.day, _endTime!.hour, _endTime!.minute),
      endDate: DateTime(_date.year, _date.month, _date.day),
      title: "",
      event: const Event(title: ""),
    );

    /// callback event.
    widget.onEventCreate?.call(event);
    _resetForm();
  }

  void _resetForm() {
    _form.currentState?.reset();
    _dateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
  }
}
