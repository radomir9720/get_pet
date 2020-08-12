import 'dart:convert';

import 'package:image_picker/image_picker.dart';

Future<String> imageToBase64(PickedFile image) async {
  List<int> bytes = await image.readAsBytes();
  return base64Encode(bytes).toString();
}
