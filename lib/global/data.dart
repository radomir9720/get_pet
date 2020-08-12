import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Data {
  Directory appDocDir;

  // Boxes:
  Box _mainBox;

  // Models
  // OptionsBoxModel _optionsBoxModel;

  // Boxes getters
  Box get mainBox => _mainBox;

  // Models getters
  // OptionsBoxModel get optionsBoxModel => _optionsBoxModel;

  Future<void> _initBoxes() async {
    // Boxes
    _mainBox = await openBox('mainBox');
    // _optionsBox = await openBox('optionsBox');

    // Models
    // _optionsBoxModel = OptionsBoxModel.fromMap(_optionsBox.toMap());
  }

  Future<Box> openBox(String key) async => await Hive.openBox(key);

  Future<void> _initAppDocDir() async =>
      appDocDir = await getApplicationDocumentsDirectory();

  // void changeValue(DataEvent dataEvent, dynamic value) {
  //   if (dataEvent == DataEvent.registration) {
  //     // _optionsBoxModel.showTranslations = value;
  //     _mainBox.put(_getKeyFromEnum(dataEvent), value);
  //   }
  // }

  // static String _getKeyFromEnum(DataEvent dataEvent) =>
  //     dataEvent.toString().split('.').last;

  Future<Data> init() async {
    await _initAppDocDir();
    Hive.init(appDocDir.path);
    await _initBoxes();
    return this;
  }
}

// enum DataEvent { registration }
