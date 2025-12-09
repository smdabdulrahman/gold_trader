import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/model/OldProduct.dart';
import 'package:goldtrader/model/SoldProducts.dart';

import 'package:sqflite/sqflite.dart';

class Oldproductdbhelper {
  /*  static Future<List<Map<String, dynamic>>> queryOldProducts() async {
    Database db = await DatabaseHelper.instance.db;
    return await db.query('old_products');
  } */
  static Future<List<OldProduct>> queryOldProducts(int sales_id) async {
    Database db = await DatabaseHelper.instance.db;
    List<Map<String, dynamic>> ls = await db.query(
      'old_products',
      where: 'sales_id=?',
      whereArgs: [sales_id],
    );
    List<OldProduct> ps = [];
    for (var element in ls) {
      ps.add(OldProduct.fromMap(element));
    }
    return ps;
  }

  static Future<int> insertOldProducts(OldProduct old_product) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert('old_products', old_product.toMap());
  }
}
