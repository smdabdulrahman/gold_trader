import 'dart:io';

import 'package:goldtrader/helpers/PdfHelper.dart';
import 'package:goldtrader/helpers/SalesDbHelper.dart';
import 'package:permission_handler/permission_handler.dart';

class Filehelper {
  static late Directory dir;
  static void getPermissionAndCreateFolder() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      dir = Directory("/storage/emulated/0/GoldTrader");
      if (!dir.existsSync()) dir.createSync();
      Filehelper.deleteSalesWeekBefore();
    } else {
      // Handle permission denied
      throw Exception("Storage permission not granted");
    }
  }

  static void deleteSalesWeekBefore() {
    final weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thrusday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    String today = weekDays[DateTime.now().weekday - 1];
    String prev_week_date = DateTime.now()
        .subtract(Duration(days: 7))
        .toIso8601String()
        .substring(0, 10);
    Directory weekDir = Directory(
      Filehelper.dir.path + "/${today}_${prev_week_date}",
    );
    print(weekDir.path);
    if (weekDir.existsSync()) {
      weekDir.deleteSync(recursive: true);
      Salesdbhelper.deleteLastWeekBeforeSalesDB();
    }
  }
}
