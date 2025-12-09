import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/model/Customer.dart';

import 'package:sqflite/sqflite.dart';

class Customerdbhelper {
  static Future<List<Map<String, dynamic>>> queryCustomers() async {
    Database db = await DatabaseHelper.instance.db;
    return await db.query('customers');
  }

  static Future<Customer> queryCustomer(int id) async {
    Database db = await DatabaseHelper.instance.db;
    return Customer.fromMap(
      (await db.query('customers', where: "id=?", whereArgs: [id]))[0],
    );
  }

  static Future<int> insertCustomer(Customer customer) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert('customers', customer.toMap());
  }
}
