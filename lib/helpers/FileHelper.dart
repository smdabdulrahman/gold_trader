import 'dart:io';

import 'package:goldtrader/helpers/PdfHelper.dart';
import 'package:permission_handler/permission_handler.dart';

class Filehelper {
  static late Directory dir;
  static void getPermissionAndCreateFolder() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      dir = Directory("/storage/emulated/0/GoldTrader");
      if (!dir.existsSync()) dir.createSync();
      Pdfhelper.check();
    } else {
      // Handle permission denied
      throw Exception("Storage permission not granted");
    }
  }
}
