import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/FileHelper.dart';
import 'package:goldtrader/helpers/SalesDbHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/redirect.dart';

import 'package:goldtrader/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  //initSharedPreferences();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    //databaseFactory = databaseFactoryFfi;
  }
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeCustomises();
  Filehelper.getPermissionAndCreateFolder();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold Trader',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ta'),
        Locale('ml'),
        Locale('hi'),
        Locale('te'),
        Locale('kn'),
        Locale('ja'),
        Locale('es'),
        Locale('zh'),
      ],
      locale: Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
        fontFamily: "Poppins",
      ),
      home: Redirect(),
    );
  }
}
