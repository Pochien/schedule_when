import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_when/extension/app_colors.dart';
import 'package:schedule_when/extension/constants.dart';
//
import 'package:schedule_when/globals.dart' as globals;
import 'package:schedule_when/model/app_settings.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey();

  /// TextEdit Controller
  final TextEditingController _durationCtlr = TextEditingController();
  final TextEditingController _leadtimeCtlr = TextEditingController();
  final TextEditingController _clockStartCtlr = TextEditingController();
  final TextEditingController _clockEndCtlr = TextEditingController();
  final TextEditingController _remarkCtlr = TextEditingController();

  /// Variables from globals
  // ignore: unused_field
  int _duration = globals.downloadDuration;
  // ignore: unused_field
  // int _leadtime = globals.leadtime;
  // ignore: unused_field
  int _clockStart = globals.displayClockStart;
  // ignore: unused_field
  int _clockEnd = globals.displayClockEnd;
  // ignore: unused_field
  String _remark = globals.remark;

  @override
  void initState() {
    super.initState();

    /// Add listener for TextEditingController
    _durationCtlr.addListener(_printLatestValue);
    _leadtimeCtlr.addListener(_printLatestValue);
    _clockStartCtlr.addListener(_printLatestValue);
    _clockEndCtlr.addListener(_printLatestValue);
    _remarkCtlr.addListener(_printLatestValue);

    /// Get data from SharedPreference.
    _getAppSettingsFromSharedPref(AppSettings()).then((value) {
      _durationCtlr.text = value.duration.toString();
      _leadtimeCtlr.text = value.leadtime.toString();
      _clockStartCtlr.text = value.clockStart.toString();
      _clockEndCtlr.text = value.clockEnd.toString();
      _remarkCtlr.text = value.remark;
    });
  }

  @override
  void dispose() {
    _durationCtlr.dispose();
    _leadtimeCtlr.dispose();
    _clockStartCtlr.dispose();
    _clockEndCtlr.dispose();
    _remarkCtlr.dispose();

    super.dispose();
  }

  void _printLatestValue() {
    // debugPrint('Input value: ${_remarkCtlr.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black54),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _setAppSettingsToSharedPref(AppSettings(
                  duration: int.parse(_durationCtlr.text),
                  leadtime: int.parse(_leadtimeCtlr.text),
                  clockStart: int.parse(_clockStartCtlr.text),
                  clockEnd: int.parse(_clockEndCtlr.text),
                  remark: _remarkCtlr.text));
            },
          )
        ],
        backgroundColor: const Color.fromRGBO(250, 248, 240, 1),
        foregroundColor: AppColors.appBarIconColor,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                // Duration
                TextFormField(
                  controller: _durationCtlr,
                  decoration: AppConstants.inputDecoration.copyWith(
                      labelText: "Duration (Day)",
                      hintText: "Enter calendar duration"),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSaved: (value) => _duration =
                      (value?.isEmpty ?? globals.downloadDuration) as int,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "You have to fill the calendar duration.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 15,
                ),
                // Leadtime(暫時未提供)
                // TextFormField(
                //   controller: _leadtimeCtlr,
                //   decoration: AppConstants.inputDecoration.copyWith(
                //       labelText: "Leadtime (Minute)",
                //       hintText: "Enter event leadtime"),
                //   style: const TextStyle(
                //     color: AppColors.black,
                //     fontSize: 17.0,
                //   ),
                //   onSaved: (value) =>
                //       _leadtime = (value?.isEmpty ?? globals.leadtime) as int,
                //   validator: (value) {
                //     if (value == null || value == "") {
                //       return "You have to fill your event leadtime.";
                //     }
                //     return null;
                //   },
                //   keyboardType: TextInputType.text,
                //   textInputAction: TextInputAction.next,
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Clock Start
                TextFormField(
                  controller: _clockStartCtlr,
                  decoration: AppConstants.inputDecoration.copyWith(
                      labelText: "Start Clock (Hour)",
                      hintText: "Enter start clock"),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSaved: (value) => _clockStart =
                      (value?.isEmpty ?? globals.displayClockStart) as int,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "You have to fill the start clock.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 15,
                ),

                /// End clock
                TextFormField(
                  controller: _clockEndCtlr,
                  decoration: AppConstants.inputDecoration.copyWith(
                      labelText: "End Clock (Hour)",
                      hintText: "Enter end clock"),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSaved: (value) => _clockEnd =
                      (value?.isEmpty ?? globals.displayClockEnd) as int,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "You have to fill the end clock.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 15,
                ),

                /// Remark
                TextFormField(
                  controller: _remarkCtlr,
                  decoration: AppConstants.inputDecoration.copyWith(
                      labelText: "Remark", hintText: "Enter screen remark"),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSaved: (value) => _remark = value?.trim() ?? globals.remark,
                  validator: (value) {
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  /// Get AppSettings value from SharedPreference.
  Future<AppSettings> _getAppSettingsFromSharedPref(
      AppSettings defaultSettings) async {
    final prefs = await SharedPreferences.getInstance();
    int _duration = prefs.getInt("Duration") ?? defaultSettings.duration;
    int _leadtime = prefs.getInt("Leadtime") ?? defaultSettings.leadtime;
    int _clockStart = prefs.getInt("ClockStart") ?? defaultSettings.clockStart;
    int _clockEnd = prefs.getInt("ClockEnd") ?? defaultSettings.clockEnd;
    String _remark = prefs.getString("Remark") ?? defaultSettings.remark;

    return AppSettings(
        duration: _duration,
        leadtime: _leadtime,
        clockStart: _clockStart,
        clockEnd: _clockEnd,
        remark: _remark);
  }

  /// Set app settings value to SharedPreference.
  Future<void> _setAppSettingsToSharedPref(AppSettings newAppSettings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('Duration', newAppSettings.duration);
    await prefs.setInt('Leadtime', newAppSettings.leadtime);
    await prefs.setInt('ClockStart', newAppSettings.clockStart);
    await prefs.setInt('ClockEnd', newAppSettings.clockEnd);
    await prefs.setString('Remark', newAppSettings.remark);

    /// Set global variables
    globals.downloadDuration = newAppSettings.duration;
    globals.leadtime = newAppSettings.leadtime;
    globals.displayClockStart = newAppSettings.clockStart;
    globals.displayClockEnd = newAppSettings.clockEnd;
    globals.remark = newAppSettings.remark;
  }
}
