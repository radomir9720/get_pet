import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color backgroundColor;
  const CustomProgressIndicator({Key key, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: backgroundColor,
      ),
    );
  }
}
