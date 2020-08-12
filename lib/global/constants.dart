import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// ======================= Data ======================= \\
// const String kHiveMainBoxKey = 'kHiveMainBoxKey';
// const String kHiveUserBoxKey = 'kHiveUserBoxKey';
// const String kHiveChatMessagesBoxKey = 'kHiveChatMessagesBoxKey';
// const String kHiveCounterBoxKey = 'kHiveCounterBoxKey';
// При инициализации страницы чата первоначально подгрузяться последние [kInitialStateLoadMessagesCnt] сообщений.
// const int kInitialStateLoadMessagesCnt = 20;
// При необходимости(если пользователь пролистает эти сообщения), подгрузяться еще [kLoadMessagesCnt] сообщений.
// const int kLoadMessagesCnt = 20;

// ======================= Models ======================= \\
const kLightThemeKey = 'kLightThemeKey';
const kDarkThemeKey = 'kDarkThemeKey';

// ======================= Design ======================= \\
const double kMainElementsRadiusDouble = 25;
const double kStandardPaddingDouble = 20.0;
const EdgeInsets kStandardPadding = EdgeInsets.all(kStandardPaddingDouble);
const EdgeInsets kStandardMargin = EdgeInsets.only(
  left: kStandardPaddingDouble,
  top: kStandardPaddingDouble,
  right: kStandardPaddingDouble,
);
const double kCardBorderRadiusDouble = 15.0;
BorderRadius kCardBorderRadius = BorderRadius.circular(kCardBorderRadiusDouble);
const RoundedRectangleBorder kAppBarShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    bottomRight: Radius.circular(
      kMainElementsRadiusDouble,
    ),
  ),
);

Color kSuccessColor = Colors.green[700];
Color kInactiveColor = Colors.white.withOpacity(0.8);
Color kAccentColorLigh = Colors.orange[50];

// ======================= Network ======================= \\
// Map<String, dynamic> kRequestHeaders = {'Content-type': 'application/json'};

// ======================= Other ======================= \\

RegExp kLoginRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9-_\.]{5,20}$');
RegExp kEmailRegExp = RegExp(r'^[-\w.]+@([A-z0-9][-A-z0-9]+\.)+[A-z]{2,4}$');
RegExp kPassRegExp = RegExp(r'^(?=.*[0-9a-z]).{6,20}');
RegExp kDefaultTextFieldRegExp = RegExp(r'^(.){1,100}$');
RegExp kOptionalTextFieldRegExp = RegExp(r'^(.){0,100}$');

MaskTextInputFormatter kPhoneInputFormatter = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##', filter: {'#': RegExp(r'[0-9]')});

const Map<int, Map<String, String>> months = {
  1: {'fullDeclination': 'января', 'short': 'янв'},
  2: {'fullDeclination': 'февраля', 'short': 'фев'},
  3: {'fullDeclination': 'марта', 'short': 'мар'},
  4: {'fullDeclination': 'апреля', 'short': 'апр'},
  5: {'fullDeclination': 'мая', 'short': 'май'},
  6: {'fullDeclination': 'июня', 'short': 'июнь'},
  7: {'fullDeclination': 'июля', 'short': 'июль'},
  8: {'fullDeclination': 'августа', 'short': 'авг'},
  9: {'fullDeclination': 'сентября', 'short': 'сен'},
  10: {'fullDeclination': 'октября', 'short': 'окт'},
  11: {'fullDeclination': 'ноября', 'short': 'ноя'},
  12: {'fullDeclination': 'декабря', 'short': 'дек'},
};
