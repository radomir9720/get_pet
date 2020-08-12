import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_pet/global/constants.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextInputField extends StatefulWidget {
  TextInputField({
    this.hintText,
    this.obscure = false,
    this.autoFocus = false,
    @required this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.errorText,
    this.checkIfIsValid,
    this.focusNode,
    Key key,
    this.prefixIcon,
    this.suffixIcon,
    this.maskTextInputFormatter,
    this.obligatory = false,
  }) : super(key: key);

  final String hintText;
  final bool obscure;
  final bool autoFocus;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function onChanged;
  final String errorText;
  final Function checkIfIsValid;
  final FocusNode focusNode;
  final Icon prefixIcon;
  final Widget suffixIcon;
  final MaskTextInputFormatter maskTextInputFormatter;
  final bool obligatory;

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool _isValid = true;

  @override
  void initState() {
    if (widget.controller != null && widget.errorText != null) {
      widget.controller.addListener(() {
        _isValid = widget.checkIfIsValid(widget.controller) ? true : false;
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: kStandardMargin,
          child: Container(
            // margin: kStandardMargin,
            padding: EdgeInsets.all(kStandardPaddingDouble / 3),
            decoration: BoxDecoration(
              borderRadius: kCardBorderRadius,
              color: kAccentColorLigh,
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  focusNode: widget.focusNode,
                  key: widget.key,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                  controller: widget.controller,
                  autofocus: widget.autoFocus,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  obscureText: widget.obscure,
                  inputFormatters: widget.maskTextInputFormatter == null
                      ? null
                      : [widget.maskTextInputFormatter],
                  // style: prefs.getMainTextStyle(),
                  // cursorColor: prefs.getThemeAccentColor(),
                  decoration: InputDecoration(
                      prefixIcon: widget.prefixIcon,
                      suffixIcon: widget.suffixIcon ??
                          (widget.prefixIcon != null ? const SizedBox() : null),
                      // helperText: _isValid ? null : widget.errorText,
                      helperMaxLines: 3,
                      // helperStyle: TextStyle(
                      //     // color: Theme.of(context).errorColor,
                      //     fontWeight: FontWeight.w500),
                      hintText: widget.hintText,
                      // contentPadding: EdgeInsets.zero,
                      border: InputBorder.none
                      // enabledBorder: OutlineInputBorder(
                      //   borderRadius: kCardBorderRadius,
                      //   borderSide: BorderSide(
                      //       color: _isValid
                      //           ? Theme.of(context).accentColor
                      //           : Theme.of(context).errorColor,
                      //       width: 2.0),
                      // ),
                      // focusedBorder: OutlineInputBorder(
                      //   borderRadius: kCardBorderRadius,
                      //   borderSide: BorderSide(
                      //       color: _isValid
                      //           ? Theme.of(context).accentColor
                      //           : Theme.of(context).errorColor,
                      //       width: 2.0),
                      // ),
                      // hintStyle: TextStyle(
                      //   color: Colors.grey,
                      // ),
                      ),
                ),
                !_isValid
                    ? Text(
                        widget.errorText,
                        style: TextStyle(
                            color: Theme.of(context).errorColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        widget.obligatory
            ? Positioned(
                top: kStandardPaddingDouble + 10,
                right: kStandardPaddingDouble + 10,
                child: Tooltip(
                  message: 'Обязательное поле',
                  child: Icon(
                    LineAwesomeIcons.asterisk,
                    size: 11,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
