import 'package:flutter/material.dart';
//
import 'package:schedule_when/extension/extension.dart';
import 'package:schedule_when/presentation/widgets/create_event_widget.dart';
import 'package:schedule_when/themes/default_theme.dart';

class CreateEventPage extends StatefulWidget {
  final bool withDuration;

  const CreateEventPage({Key? key, this.withDuration = false})
      : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
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
          'Create New Event',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: DefalutTheme.viewBGColor,
        foregroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CreateEventWidget(
          onEventCreate: context.pop,
        ),
      ),
    );
  }
}
