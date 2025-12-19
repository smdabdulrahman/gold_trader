import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldtrader/get_rate.dart';
import 'package:goldtrader/sales_pages/bill_view.dart';
import 'package:goldtrader/sales_pages/gold_entry_form.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/settings/select_language.dart';
import 'package:goldtrader/gold_price_edit.dart';
import 'package:goldtrader/settings.dart';
import 'package:goldtrader/shop_pages/shop_detail_view.dart';
import 'package:goldtrader/shop_pages/shop_details_form.dart';
import 'package:goldtrader/update_page.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> ls = [
    "Welcome",
    "Settings",
    "Gold Price",
    "Sale Entry",
    "Shop Details",
  ];
  late Future<List<String>> futureDashboardStr = Translatehelper.translateList(
    ls,
  );

  final f = NumberFormat.decimalPattern('en_IN');
  String roundAndFormat(double n) {
    double r = (n * 100).round() / 100; // 4 decimals → 2 decimals
    return f.format(r); // Indian format
  }

  Map<String, dynamic>? shopData;
  Map<String, dynamic>? customiseData;
  double? goldRate = 0;
  double? silverRate = 0;
  @override
  void initState() {
    super.initState();
    print("kk");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // perform post-frame initialization here
      DatabaseHelper.instance.updatedGoldRate(context).then((val) {
        DatabaseHelper.instance.queryRates().then((val) {
          setState(() {
            if (val.isEmpty) {
              goldRate = 0;
              silverRate = 0;
            } else {
              goldRate = val.first["gold"];

              silverRate = val.first["silver"];
            }

            print(val);
          });
        });
      });

      //showSuccessSnackBar("d", context);
    });
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
  }

  final LinearGradient goldGradient = const LinearGradient(
    colors: [Color(0xFFE7C76F), Color(0xFFD4AF37), Color(0xFFB28A2B)],
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
  );
  void showSuccessSnackBar(String txt, BuildContext context) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt, style: TextStyle(color: Colors.white)),
        action: SnackBarAction(label: "OK", onPressed: () {}),
        backgroundColor: Colors.green[800],
      ),
    );
  }

  void showErrorSnackBar(String txt) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt, style: TextStyle(color: Colors.white)),
        action: SnackBarAction(label: "OK", onPressed: () {}),
        backgroundColor: Colors.red[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureDashboardStr,
      builder: (context, body) {
        if (body.hasData) {
          return Scaffold(
            backgroundColor: Color.fromARGB(246, 255, 255, 255),

            body: SafeArea(
              child: Container(
                child: Column(
                  spacing: 20,
                  children: [
                    if (shopData != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 18.0,
                          left: 18,
                          right: 18,
                          bottom: 2,
                        ),
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

                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
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
                              Icon(
                                Icons.share_location_outlined,
                                color: Colors.amber,
                              ),
                              Text(
                                customiseData!["district"] +
                                    ", " +
                                    customiseData!["state"],
                              ),
                            ],
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          alignment: Alignment.center,
                          width: 150,
                          height: 105,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 5,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Gold",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image.asset(
                                    opacity: AlwaysStoppedAnimation(.8),
                                    "assets/images/coins.png",
                                    width: 50,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("₹ "),
                                  ),
                                  Text(
                                    roundAndFormat(goldRate!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    " /g",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          alignment: Alignment.center,
                          width: 150,
                          height: 105,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 5,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Silver",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image.asset(
                                    opacity: AlwaysStoppedAnimation(.8),
                                    "assets/images/silver_coin.png",
                                    width: 45,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("₹ "),
                                  ),
                                  Text(
                                    roundAndFormat(silverRate!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    " /g",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                            ],
                          ),
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
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 20,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Quick Actions",
                                style: TextStyle(
                                  fontSize: 20,

                                  fontWeight: FontWeight.bold,
                                ),
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Container(
                                    width: 120,
                                    height: 120,

                                    child: Column(
                                      spacing: 10,
                                      children: [
                                        Padding(padding: EdgeInsets.all(1)),
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
                                            "assets/images/cogwheel.png",
                                            width: 40,
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    child: Column(
                                      spacing: 10,
                                      children: [
                                        Padding(padding: EdgeInsets.all(1)),
                                        Text(
                                          body.data![2],
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/images/gold.png",
                                            width: 40,
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    child: Column(
                                      spacing: 10,
                                      children: [
                                        Padding(padding: EdgeInsets.all(1)),
                                        Text(
                                          body.data![3],
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/images/checklist.png",
                                            width: 40,
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    child: Column(
                                      spacing: 10,
                                      children: [
                                        Padding(padding: EdgeInsets.all(1)),
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
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/images/store.png",
                                            width: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (builder) {
                                        return UpdatePage();
                                      },
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    6,
                                    28,
                                    53,
                                  ),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 80,

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/images/rocket.png",
                                          width: 40,
                                        ),
                                      ),

                                      Text(
                                        "Upgrade Version",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_outward_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Color(0xffffffff),
          body: SafeArea(
            child: Center(child: Image.asset("assets/images/spinner.gif")),
          ),
        );
      },
    );
  }
}
