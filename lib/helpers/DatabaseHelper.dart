import 'package:goldtrader/get_rate.dart';
import 'package:goldtrader/model/Product.dart';
import 'package:goldtrader/model/Rates.dart';
import 'package:goldtrader/model/Shop.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/Customise.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'goldtrader.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    //create customise table
    await db.execute('''
      CREATE TABLE customise(
        id INTEGER PRIMARY KEY ,
        locale TEXT,
        state TEXT,
        district TEXT
  
      )
    ''');

    //create shop details table
    await db.execute('''
      CREATE TABLE shop_details(
        id INTEGER PRIMARY KEY ,
        shop_name TEXT,
        mobile_num TEXT,
        addr_line1 TEXT,
        addr_line2 TEXT,
        printer_name TEXT,
        logo BLOB
      )
    ''');

    //create rates table
    await db.execute('''
      CREATE TABLE rates(
        id INTEGER PRIMARY KEY ,
        gold REAL,
        silver REAL,
        last_updated_time TEXT
      )
    ''');

    //create products table
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY ,
        product_name TEXT,
        fixed_price REAL,
        isGold INTEGER,
        IsSilver INTEGER
      )
    ''');

    //create customer_s table
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY ,
        name TEXT,
        place TEXT,
        phone_no INTEGER
      )
    ''');

    //create sales table
    await db.execute('''
      CREATE TABLE sales(
        id INTEGER PRIMARY KEY ,
        date_time TEXT,
        old_amount REAL,
        discount_amount REAL,
        final_amount INTEGER,
        customer_id INTEGER,
        count INTEGER,
        FOREIGN KEY(customer_id) REFERENCES customer(id) ON DELETE SET NULL
      )
    ''');

    //create sold products table
    await db.execute('''
      CREATE TABLE sold_products(
        id INTEGER PRIMARY KEY ,
        sales_id INTEGER,
        product_id INTEGER,
        gram REAL,
        gst REAL,
        total_amount REAL,
        final_amount INTEGER,
        FOREIGN KEY(sales_id) REFERENCES sales(id) ON DELETE CASCADE,
        FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    //create oldProducts table
    await db.execute('''
      CREATE TABLE old_products(
        id INTEGER PRIMARY KEY ,
        sales_id INTEGER,
        old_product_name TEXT,
        less_amount REAL,
        final_amount INTEGER,
        gram REAL,
        dust REAL,
        isGold INTEGER,
        isSilver INTEGER,
        FOREIGN KEY(sales_id) REFERENCES sales(id) ON DELETE CASCADE
        
      )
    ''');
  }

  Future<int> insertCustomise(Customise Customise) async {
    Database db = await instance.db;
    return await db.insert('customise', Customise.toMap());
  }

  Future<int> insertProduct(Product product) async {
    Database db = await instance.db;
    return await db.insert('products', product.toMap());
  }

  Future<int> insertShopDetails(Shop shop) async {
    Database db = await instance.db;
    return await db.insert('shop_details', shop.toMap());
  }

  Future<int> insertRates(Rates rates) async {
    Database db = await instance.db;
    return await db.insert('rates', rates.toMap());
  }

  Future<List<Map<String, dynamic>>> queryRates() async {
    Database db = await instance.db;
    return await db.query('rates');
  }

  Future<List<Map<String, dynamic>>> queryAllCustomise() async {
    Database db = await instance.db;
    return await db.query('customise');
  }

  Future<List<Map<String, dynamic>>> queryShopDetails() async {
    Database db = await instance.db;

    return await db.query('shop_details');
  }

  Future<List<Map<String, dynamic>>> queryProducts() async {
    Database db = await instance.db;

    return await db.query('products');
  }
  /*   Future<List<Map<String, dynamic>>> queryCustomise(int id) async {
    Database db = await instance.db;
    return await db.query('nova_Customises', where: 'id =?', whereArgs: [id]);
  } */

  Future<int> updateLocale(String locale) async {
    Database db = await instance.db;
    return await db.rawUpdate("UPDATE customise SET locale = ?", [locale]);
  }

  Future<int> updateState(String state) async {
    Database db = await instance.db;
    return await db.rawUpdate("UPDATE customise SET state = ?", [state]);
  }

  Future<int> updateDistrict(String district) async {
    Database db = await instance.db;
    return await db.rawUpdate("UPDATE customise SET district = ?", [district]);
  }

  Future<int> updateShopDetails(Shop shop) async {
    Database db = await instance.db;
    return await db.update(
      "shop_details",
      shop.toMap(),
      where: 'id = ?',
      whereArgs: [shop.id],
    );
  }

  Future<int> updateProduct(Product product) async {
    Database db = await instance.db;
    return await db.update(
      "products",
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> updateRates(Rates rates) async {
    Database db = await instance.db;
    return await db.update(
      "rates",
      rates.toMap(),
      where: 'id = ?',
      whereArgs: [rates.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    Database db = await instance.db;
    return await db.delete("products", where: 'id = ?', whereArgs: [id]);
  }
  /* Future<int> updateLocale(String locale) async {
    Database db = await instance.db;
    return await db.update(
      'customise',
      Customise.toMap(),
      where: 'id = ?',
      whereArgs: [Customise.id],
    );
  } */
  /*   Future<int> deleteCustomise(int id) async {
    Database db = await instance.db;
    return await db.delete('nova_Customises', where: 'id = ?', whereArgs: [id]);
  } */

  Future<void> initializeCustomises() async {
    if ((await queryAllCustomise()).isEmpty) {
      List<Customise> CustomisesToAdd = [
        Customise(locale: "en", state: null, district: null),
      ];

      for (Customise cust in CustomisesToAdd) {
        await insertCustomise(cust);
      }
    }
    await queryRates().then((val) async {
      return;
      DateTime last_updated_time = DateTime.now();
      if (!val.isEmpty) {
        last_updated_time = DateTime.tryParse(val[0]["last_updated_time"])!;
      }
      DateTime now = DateTime.now();
      if (val.isEmpty) {
        Map<String, double> rates = await GetRate.goldAndSilver();

        insertRates(
          Rates(
            gold: rates["gold"]!,
            silver: rates["silver"]!,
            last_updated_time: DateTime.now().toIso8601String(),
          ),
        ).then((val) {
          print(val);
        });
      } else if ((last_updated_time.day != now.day) ||
          (last_updated_time.month != now.month) ||
          (last_updated_time.year != now.year)) {
        print("new rate updated");
        Map<String, double> rates = await GetRate.goldAndSilver();
        if (rates["gold"] == 0) {
          print("Unable to update rates");
          return;
        }
        updateRates(
          Rates(
            id: 1,
            gold: rates['gold']!,
            silver: rates["silver"]!,
            last_updated_time: DateTime.now().toIso8601String(),
          ),
        );
      }
    });
  }
}
