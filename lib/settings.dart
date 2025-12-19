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
    return FutureBuilder(
      future: futureSettingsStr,
      builder: (builder, body) {
        if (body.hasData) {
          return Scaffold(
            backgroundColor: Color.fromARGB(246, 255, 255, 255),
            appBar: AppBar(
              title: Text(
                body.data![0],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              backgroundColor: Colors.amber[400],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(4)),

                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 68,
                          padding: EdgeInsets.symmetric(horizontal: 10),

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
                                      size: 25,
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        if (customiseData != null)
                                          Text(
                                            langs[customiseData!["locale"]]!,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 68,
                          padding: EdgeInsets.symmetric(horizontal: 10),

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
                                      size: 22,
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        if (customiseData != null)
                                          Text(
                                            customiseData!["state"],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 68,
                          padding: EdgeInsets.symmetric(horizontal: 10),

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
                                      size: 22,
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          customiseData!["district"],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 68,
                          padding: EdgeInsets.symmetric(horizontal: 10),

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
                                      size: 22,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      body.data![4],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Color(0xffffffff),
            body: SafeArea(
              child: Center(child: Image.asset("assets/images/spinner.gif")),
            ),
          );
        }
      },
    );
  }
}
