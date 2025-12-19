import 'dart:io';

import 'package:goldtrader/helpers/PdfHelper.dart';
import 'package:goldtrader/helpers/SalesDbHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Filehelper {
  static late Directory dir;
  static void getPermissionAndCreateFolder() async {
    final extDir = await getExternalStorageDirectory();

    dir = Directory('${extDir!.path}');

    if (!dir.existsSync()) dir.createSync();
    Filehelper.deleteSalesWeekBefore();

    // Handle permission denied
    /*  throw Exception("Storage permission not granted"); */
  }

  static void deleteSalesWeekBefore() {
    DateTime now = DateTime.now();
    Filehelper.dir.listSync().forEach((p) {
      String folder_name = p.path.substring(p.path.lastIndexOf("/") + 1);
      String curr_bill_date = folder_name.substring(
        folder_name.lastIndexOf("_") + 1,
      );
      print(curr_bill_date);
      print(now.difference(DateTime.parse(curr_bill_date)).inDays);
      if (now.difference(DateTime.parse(curr_bill_date)).inDays > 6) {
        p.deleteSync(recursive: true);
        Salesdbhelper.deleteLastWeekBeforeSalesDB(curr_bill_date);
      }
    });
  }
}
