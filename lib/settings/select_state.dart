import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/model/Customise.dart';
import 'package:goldtrader/settings/select_district.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectState extends StatefulWidget {
  const SelectState({super.key});

  @override
  State<SelectState> createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  Future<List<Map<String, String>>> fetchStateList() async {
    final response = await http.get(
      Uri.parse("https://india-location-hub.in/api/locations/states"),
    );
    if (response.statusCode == 200) {
      print("got a state list");
      Map<String, dynamic> res =
          jsonDecode(response.body) as Map<String, dynamic>;
      List ls = res["data"]["states"] as List;
      List<String> extracted = [];
      for (var e in ls) {
        extracted.add(e['name']);
      }
      print("send to a translater");
      return Translatehelper.translateListExtra(extracted);
    }
    throw Exception("Unable to load states data");
  }

  Future<List<String>> fetchTranslatedString() {
    return Translatehelper.translateList([
      "Select Your State",
      "Search",
      "Continue",
    ]);
  }

  @override
  void initState() {
    super.initState();
    futureStatesList = fetchStateList().then((value) {
      statesList = value;
      return value;
    });
    selectStatePageStrList = fetchTranslatedString();
  }

  List<Map<String, String>> statesList = [];
  late Future<List<Map<String, String>>> futureStatesList;
  String continueTxt = "Continue";
  String selectedState = "";
  late Future<List<String>> selectStatePageStrList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Container(
          child: Center(
            child: FutureBuilder(
              future: selectStatePageStrList,
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
                            List<Map<String, String>> tempStatesList = [];

                            for (var stateMap in statesList) {
                              if (stateMap["name"]!.startsWith(value)) {
                                tempStatesList.add(stateMap);
                              }
                            }
                            setState(() {
                              futureStatesList = (() async {
                                return tempStatesList;
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
                                selectedState = value!;
                              });
                            },
                            groupValue: selectedState,
                            child: FutureBuilder(
                              future: futureStatesList,
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
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      ElevatedButton.icon(
                        onPressed: () {
                          DatabaseHelper.instance
                              .updateState(selectedState)
                              .then((val) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (builder) {
                                      return SelectDistrict(
                                        state_name: selectedState,
                                      );
                                    },
                                  ),
                                );
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
