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

  static Future<List<Map<String, dynamic>>> querySales() async {
    Database db = await DatabaseHelper.instance.db;
    return await db.query('sales');
  }

  static Future<int> insertSale(Sales sales) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert('sales', sales.toMap());
  }
}
