import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/model/Sales.dart';
import 'package:sqflite/sqflite.dart';

class Salesdbhelper {
  static Future<Sales> querySale(int id) async {
    Database db = await DatabaseHelper.instance.db;
    return Sales.fromMap(
      (await db.query('sales', where: "id=?", whereArgs: [id]))[0],
    );
  }

  static Future<List<Sales>> querySales() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map<String, dynamic>> ls = await db.query('sales');
    List<Sales> ls_sales = [];
    for (var element in ls) {
      ls_sales.add(Sales.fromMap(element));
    }

    return ls_sales;
  }

  static Future<void> deleteLastWeekBeforeSalesDB(String last_week_date) async {
    /*  String last_week_date = DateTime.now()
        .subtract(Duration(days: 7))
        .toString()
        .substring(0, 10); */
    print(last_week_date);
    Database db = await DatabaseHelper.instance.db;
    db
        .delete(
          "sales",
          where: "date_time LIKE?",
          whereArgs: ["${last_week_date}%"],
        )
        .then((val) {
          print("Last Week Sales is deleted " + last_week_date);
          print(val);
        });
  }

  static Future<int> insertSale(Sales sales) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert('sales', sales.toMap());
  }
}
