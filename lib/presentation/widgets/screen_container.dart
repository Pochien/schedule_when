import 'package:flutter/material.dart';
import 'package:schedule_when/globals.dart' as globals;

class ScreenContainer extends StatefulWidget {
  final double childHeight;
  final Widget childToScreen;
  const ScreenContainer(
      {Key? key, required this.childHeight, required this.childToScreen})
      : super(key: key);

  @override
  _ScreenContainerState createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  // late String _remark = "";

  // @override
  // void initState() {
  //   super.initState();

  //   _remark = globals.remark;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sort Out When',
      home: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: widget.childHeight,
                    child: widget.childToScreen,
                  ),
                  Text(
                    // ignore: unnecessary_null_comparison
                    (globals.remark == null)
                        ? "My schedule here."
                        : globals.remark,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              // Container(
              //   color: Colors.yellow,
              //   height: 720,
              //   width: 400,
              //   child: const Text("test"),
              // ),
              // Container(
              //   color: Colors.red,
              //   height: 720,
              //   width: 400,
              //   child: const Text("test"),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
