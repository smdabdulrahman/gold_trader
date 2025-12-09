import 'package:flutter/material.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/product_list.dart';
import 'package:goldtrader/settings/select_district.dart';
import 'package:goldtrader/settings/select_language.dart';
import 'package:goldtrader/settings/select_state.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<List<String>>? futureSettingsStr;
  Map<String, dynamic>? customiseData;
  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.queryAllCustomise().then((val) {
      setState(() {
        customiseData = val[0];
      });
    });
    List<String> ls = [
      "Settings",
      "Change Language",

      "Change State",

      "Change District",

      "Products List",
    ];
    futureSettingsStr = Translatehelper.translateList(ls);
  }

  Map<String, String> langs = {
    "en": "English",
    "ta": "தமிழ்",
    "ml": "മലയാളം",
    "hi": "हिंदी",
    "te": "తెలుగు",
    "kn": "ಕನ್ನಡ",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: futureSettingsStr,
          builder: (builder, body) {
            if (body.hasData) {
              return Column(
                children: [
                  Padding(padding: EdgeInsets.all(4)),
                  Text(body.data![0], style: TextStyle(fontSize: 25)),
                  Container(
                    padding: EdgeInsets.all(20),

                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(color: Colors.grey[50]),

                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (builder) {
                                    return SelectLanguage();
                                  },
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.language_outlined,
                                      size: 30,
                                      color: Colors.amber,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          body.data![1],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        if (customiseData != null)
                                          Text(
                                            langs[customiseData!["locale"]]!,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_right_sharp, size: 30),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.grey[50],
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (builder) {
                                    return SelectState();
                                  },
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.location_city_rounded,
                                      size: 30,
                                      color: Colors.amber,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          body.data![2],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        if (customiseData != null)
                                          Text(customiseData!["state"]),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_right_sharp, size: 30),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.grey[50],
                          child: InkWell(
                            onTap: () {
                              DatabaseHelper.instance.queryAllCustomise().then((
                                val,
                              ) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (builder) {
                                      return SelectDistrict(
                                        state_name: val[0]["state"],
                                      );
                                    },
                                  ),
                                );
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.holiday_village,
                                      size: 30,
                                      color: Colors.amber,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          body.data![3],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(customiseData!["district"]),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_right_sharp, size: 30),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.grey[50],
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (builder) {
                                    return ProductList();
                                  },
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.list_alt_outlined,
                                      size: 30,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      body.data![4],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_right_sharp, size: 30),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Image.asset("assets/images/spinner.gif"));
            }
          },
        ),
      ),
    );
  }
}
