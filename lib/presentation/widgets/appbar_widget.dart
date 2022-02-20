import 'package:flutter/material.dart';
//
import 'package:schedule_when/themes/default_theme.dart';

class IC4AppBar extends StatelessWidget {
  final String title;

  const IC4AppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black54),
      ),
      backgroundColor: DefalutTheme.viewBGColor,
    );
  }
}
