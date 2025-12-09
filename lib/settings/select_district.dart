import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/dashboard.dart';
import 'package:goldtrader/shop_pages/shop_details_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectDistrict extends StatefulWidget {
  const SelectDistrict({super.key, required this.state_name});
  final String state_name;
  @override
  State<SelectDistrict> createState() => _SelectDistrictState();
}

class _SelectDistrictState extends State<SelectDistrict> {
  Future<List<Map<String, String>>> fetchDistrictList() async {
    final response = await http.get(
      Uri.parse(
        "https://india-location-hub.in/api/locations/districts",
      ).replace(queryParameters: {"state": widget.state_name}),
    );
    if (response.statusCode == 200) {
      print("got a district list");
      Map<String, dynamic> res =
          jsonDecode(response.body) as Map<String, dynamic>;
      List ls = res["data"]["districts"] as List;
      List<String> extracted = [];
      for (var e in ls) {
        extracted.add(e['name']);
      }
      print("send to translator");
      return Translatehelper.translateListExtra(extracted);
    }
    throw Exception("Unable to load districts data");
  }

  Future<List<String>> fetchTranslatedString() {
    return Translatehelper.translateList([
      "Select Your district",
      "Search",
      "Continue",
    ]);
  }

  @override
  void initState() {
    super.initState();
    futuredistrictsList = fetchDistrictList().then((value) {
      districtsList = value;
      return value;
    });
    selectdistrictPageStrList = fetchTranslatedString();
  }

  List<Map<String, String>> districtsList = [];
  late Future<List<Map<String, String>>> futuredistrictsList;
  String continueTxt = "Continue";
  String selecteddistrict = "";
  late Future<List<String>> selectdistrictPageStrList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Container(
          child: Center(
            child: FutureBuilder(
              future: selectdistrictPageStrList,
              builder: (context, texts) {
                if (texts.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(8)),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          texts.data![0],
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Container(
                        width: 350,
                        padding: EdgeInsets.all(6),
                        child: TextField(
                          onChanged: (value) {
                            value = value.toUpperCase();
                            List<Map<String, String>> tempdistrictsList = [];

                            for (var districtMap in districtsList) {
                              if (districtMap["name"]!.toUpperCase().startsWith(
                                value,
                              )) {
                                tempdistrictsList.add(districtMap);
                              }
                            }
                            setState(() {
                              futuredistrictsList = (() async {
                                return tempdistrictsList;
                              })();
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                            hint: Text(texts.data![1]),
                          ),
                        ),
                      ),
                      Container(
                        width: 350,
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: SingleChildScrollView(
                          child: RadioGroup(
                            onChanged: (value) async {
                              setState(() {
                                selecteddistrict = value!;
                              });
                            },
                            groupValue: selecteddistrict,
                            child: FutureBuilder(
                              future: futuredistrictsList,
                              builder: (context, body) {
                                if (body.hasData) {
                                  return Column(
                                    children: [
                                      ...List.generate(body.data!.length, (i) {
                                        return RadioListTile(
                                          radioScaleFactor: 1.4,
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          activeColor: Colors.amber,
                                          value:
                                              body.data![i]["value"]! as String,
                                          title: Text(body.data![i]["name"]!),
                                        );
                                      }),
                                    ],
                                  );
                                }
                                return Image.asset(
                                  "assets/images/spinner.gif",
                                  scale: 2,
                                );
                                ;
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      ElevatedButton.icon(
                        onPressed: () {
                          DatabaseHelper.instance.updateDistrict(
                            selecteddistrict,
                          );
                          DatabaseHelper.instance.queryShopDetails().then((
                            val,
                          ) {
                            if (val.isEmpty) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (builder) {
                                    return ShopDetailsForm();
                                  },
                                ),
                              );
                            } else {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (builder) {
                                    return Dashboard();
                                  },
                                ),
                              );
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.amber),
                          minimumSize: WidgetStatePropertyAll(Size(350, 50)),
                          iconColor: WidgetStatePropertyAll(Colors.white),
                          iconSize: WidgetStatePropertyAll(23),
                        ),
                        icon: Icon(Icons.arrow_circle_right_outlined),
                        iconAlignment: IconAlignment.end,
                        label: Text(
                          texts.data![2],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Text("Loading..");
              },
            ),
          ),
        ),
      ),
    );
  }
}
