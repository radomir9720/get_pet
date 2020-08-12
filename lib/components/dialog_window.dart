import 'package:flutter/material.dart';
import 'package:get_pet/global/constants.dart';

import 'custom_material_button.dart';

// class DialogWindow extends StatelessWidget {
//   DialogWindow({
//     @required this.showDialogText,
//     this.onPressedNeutralButton,
//     Key key,
//   }) : super(key: key);
//   final String showDialogText;
//   final Function onPressedNeutralButton;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black.withOpacity(0.1),
//       body: Padding(
//         padding: kStandardPadding,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             const SizedBox(),
//             Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(
//                   kMainElementsRadiusDouble,
//                 ),
//               ),
//               padding: kStandardPadding,
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     showDialogText,
//                     style: Theme.of(context).textTheme.headline6,
//                     textAlign: TextAlign.center,
//                   ),
//                   Divider(
//                     color: Theme.of(context).dividerColor,
//                   ),
//                   const SizedBox(
//                     height: 10.0,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       CustomMaterialButton(
//                         color: Theme.of(context).accentColor,
//                         onPressed: () {
//                           if (onPressedNeutralButton != null) {
//                             onPressedNeutralButton();
//                           }
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Понятно'),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DialogWindow extends StatelessWidget {
  final String showDialogText;
  final String detailText;
  final Function onPressedPositiveButton;
  final String positiveButtonText;
  final Function onPressedNegativeButton;
  final String negativeButtonText;
  final Function onPressedNeutralButton;
  final String neutralButtonText;

  DialogWindow({
    @required this.showDialogText,
    this.detailText,
    this.onPressedPositiveButton,
    this.positiveButtonText = 'Хорошо',
    this.onPressedNegativeButton,
    this.negativeButtonText = 'Нет',
    this.onPressedNeutralButton,
    this.neutralButtonText = 'Понятно',
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CustomMaterialButton> getDialogWindowButtons() {
      List<CustomMaterialButton> buttonList = [];
      if (onPressedNeutralButton != null ||
          (onPressedPositiveButton == null &&
              onPressedNegativeButton == null)) {
        buttonList.add(
          CustomMaterialButton(
            padding: kStandardPaddingDouble / 2,
            child: Text(
              neutralButtonText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            color: Theme.of(context).accentColor,
            onPressed:
                onPressedNeutralButton ?? () => Navigator.of(context).pop(),
          ),
        );
      }
      if (onPressedNegativeButton != null) {
        buttonList.add(
          CustomMaterialButton(
            padding: kStandardPaddingDouble / 2,
            child: Text(
              negativeButtonText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            color: Theme.of(context).errorColor,
            onPressed: onPressedNegativeButton,
          ),
        );
      }
      if (onPressedPositiveButton != null) {
        buttonList.add(
          CustomMaterialButton(
            padding: kStandardPaddingDouble / 2,
            child: Text(
              positiveButtonText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            color: kSuccessColor,
            onPressed: onPressedPositiveButton,
          ),
        );
      }
      return buttonList;
    }

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.1),
      body: Padding(
        padding: kStandardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(kMainElementsRadiusDouble)),
              padding: kStandardPadding,
              child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    showDialogText,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),
                  detailText != null
                      ? Text(
                          detailText,
                          // style: prefs.getMainTextStyle(),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: kStandardPaddingDouble,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: getDialogWindowButtons()
                        .map((e) => Flexible(
                              fit: FlexFit.loose,
                              child: e,
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
