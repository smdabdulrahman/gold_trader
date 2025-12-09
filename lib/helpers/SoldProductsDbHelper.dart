import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/model/Product.dart';
import 'package:goldtrader/model/SoldProducts.dart';

import 'package:sqflite/sqflite.dart';

class Soldproductsdbhelper {
  static Future<List<SoldProducts>> queryProducts(int id) async {
    Database db = await DatabaseHelper.instance.db;
    List<Map<String, dynamic>> ls = await db.query(
      'sold_products',
      where: "sales_id=?",
      whereArgs: [id],
    );

    List<SoldProducts> products = [];
    for (var element in ls) {
      products.add(SoldProducts.fromMap(element));
    }
    return products;
  }

  static Future<int> insertProducts(SoldProducts sold_products) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert('sold_products', sold_products.toMap());
  }
}
