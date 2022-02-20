import 'package:flutter/material.dart';
import 'package:schedule_when/presentation/screens/overrepaint.dart';

class Capturer extends StatelessWidget {
  final GlobalKey<OverRepaintBoundaryState>? overRepaintKey;
  final Widget? childToCapture;

  const Capturer({Key? key, this.overRepaintKey, this.childToCapture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: OverRepaintBoundary(
        key: overRepaintKey,
        child: RepaintBoundary(
          child: Column(children: [
            childToCapture!,
          ]),
        ),
      ),
    );
  }
}
