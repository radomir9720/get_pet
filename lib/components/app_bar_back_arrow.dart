import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class AppBarBackArrow extends StatelessWidget {
  const AppBarBackArrow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // padding: EdgeInsets.zero,
      icon: const Icon(
        LineAwesomeIcons.arrow_left,
        size: 30,
        // Icons.arrow_back,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
