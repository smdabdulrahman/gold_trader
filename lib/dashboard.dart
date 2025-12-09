import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goldtrader/bill_view.dart';
import 'package:goldtrader/gold_entry_form.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/settings/select_language.dart';
import 'package:goldtrader/gold_price_edit.dart';
import 'package:goldtrader/settings.dart';
import 'package:goldtrader/shop_pages/shop_detail_view.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<String>> futureDashboardStr;

  final f = NumberFormat.decimalPattern('en_IN');
  String roundAndFormat(double n) {
    double r = (n * 100).round() / 100; // 4 decimals → 2 decimals
    return f.format(r); // Indian format
  }

  Map<String, dynamic>? shopData;
  Map<String, dynamic>? customiseData;
  double? goldRate;
  double? silverRate;
  @override
  void initState() {
    super.initState();
    List<String> ls = [
      "Welcome",
      "Settings",
      "Gold Price",
      "Gold Entry Form",
      "Shop Details",
    ];
    futureDashboardStr = Translatehelper.translateList(ls);
    DatabaseHelper.instance.queryShopDetails().then((res) {
      setState(() {
        shopData = res.first;
      });
    });
    DatabaseHelper.instance.queryAllCustomise().then((val) {
      setState(() {
        customiseData = val.first;
      });
    });
    DatabaseHelper.instance.queryRates().then((val) {
      setState(() {
        goldRate = val.first["gold"];

        silverRate = val.first["silver"];
        print(val);
      });
    });
  }

  final LinearGradient goldGradient = const LinearGradient(
    colors: [Color(0xFFE7C76F), Color(0xFFD4AF37), Color(0xFFB28A2B)],
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),

      body: SafeArea(
        child: FutureBuilder(
          future: futureDashboardStr,
          builder: (context, body) {
            if (body.hasData) {
              return Container(
                child: Column(
                  spacing: 20,
                  children: [
                    if (shopData != null)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  body.data![0] +
                                      ",\n" +
                                      shopData!["shop_name"] +
                                      "👋",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),

                            ClipOval(
                              child: Image.memory(shopData!["logo"], width: 55),
                            ),
                          ],
                        ),
                      ),
                    if (customiseData != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Padding(padding: EdgeInsets.all(10)),
                              Icon(Icons.my_location, color: Colors.amber),
                              Text(
                                customiseData!["district"] +
                                    ",\n" +
                                    customiseData!["state"],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                spacing: 10,
                                children: [
                                  Image.asset(
                                    "assets/images/profit.gif",
                                    width: 35,
                                  ),
                                  Text(
                                    "₹ " + roundAndFormat(goldRate!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                spacing: 10,
                                children: [
                                  Image.asset(
                                    "assets/images/silver.png",
                                    width: 35,
                                  ),
                                  Text(
                                    "₹ " + roundAndFormat(silverRate!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    //Dashboard Text
                    // Text(body.data![0], style: TextStyle(fontSize: 25)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        /*   height: MediaQuery.of(context).size.height * 0.7, */
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          gradient: goldGradient,
                        ),
                        child: Column(
                          spacing: 20,
                          children: [
                            Text(
                              "Quick Actions",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //Customise Setting button
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (builder) {
                                          return Settings();
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Container(
                                    width: 125,
                                    height: 130,

                                    child: Column(
                                      children: [
                                        Padding(padding: EdgeInsets.all(10)),

                                        Text(
                                          body.data![1],
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/images/customisation.png",
                                            width: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //Gold price button
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (builder) {
                                          return GoldPriceEdit(
                                            goldRate: goldRate!,
                                            silverRate: silverRate!,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Container(
                                    width: 125,
                                    height: 130,
                                    child: Column(
                                      children: [
                                        Padding(padding: EdgeInsets.all(10)),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            body.data![2],
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/images/gold.png",
                                            width: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //Gold entry form
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (builder) {
                                          return GoldEntryForm();
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Container(
                                    width: 125,
                                    height: 130,
                                    child: Column(
                                      children: [
                                        Padding(padding: EdgeInsets.all(10)),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            body.data![3],
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/images/checklist.png",
                                            width: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (builder) {
                                          return ShopDetailView(
                                            shopData: shopData!,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Container(
                                    width: 125,
                                    height: 130,
                                    child: Column(
                                      children: [
                                        Padding(padding: EdgeInsets.all(10)),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            body.data![4],
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/images/shop.png",
                                            width: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Image.asset("assets/images/spinner.gif"));
          },
        ),
      ),
    );
  }
}
