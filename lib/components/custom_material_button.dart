import 'package:flutter/material.dart';
import 'package:get_pet/global/constants.dart';

class CustomMaterialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final BorderRadius borderRadius;
  final dynamic padding;
  CustomMaterialButton({
    Key key,
    @required this.onPressed,
    this.child,
    this.color,
    this.borderRadius,
    this.padding,
  })  : assert(
          padding == null ||
              (padding.runtimeType == double ||
                  padding.runtimeType == EdgeInsets ||
                  padding.runtimeType == int),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? kCardBorderRadius,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 0,
      height: 0,
      padding: ((padding != null &&
                  (padding.runtimeType == double ||
                      padding.runtimeType == int)) ||
              padding == null)
          ? EdgeInsets.all(padding?.toDouble() ?? kStandardPaddingDouble)
          : padding,
      onPressed: onPressed,
      child: child,
      color: color,
      elevation: 0,
      highlightElevation: 0,
    );
  }
}
