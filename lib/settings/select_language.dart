import 'package:flutter/material.dart';
import 'package:goldtrader/dashboard.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/model/Customise.dart';
import 'package:goldtrader/settings/select_state.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  String locale = "en";
  @override
  void initState() {
    super.initState();
    initLocale();
  }

  void initLocale() async {
    DatabaseHelper.instance.queryAllCustomise().then((value) {
      print("inint locale");
      print(value);
      setState(() {
        locale = value[0]["locale"];
      });
    });

    Translatehelper.translate("Continue").then((val) {
      setState(() {
        continueTxt = val.text;
      });
    });
  }

  String continueTxt = "Continue";

  List<Map<String, String>> available_languages = [
    {
      "flag": "assets/images/flags/us.png",
      "lang": "English",
      "lang_en": "English",
      "value": "en",
    },
    {
      "flag": "assets/images/flags/india.png",
      "lang": "தமிழ்",
      "lang_en": "Tamil",
      "value": "ta",
    },
    {
      "flag": "assets/images/flags/india.png",
      "lang": "മലയാളം",
      "lang_en": "Malayalam",
      "value": "ml",
    },
    {
      "flag": "assets/images/flags/india.png",
      "lang": "हिंदी",
      "lang_en": "Hindi",
      "value": "hi",
    },
    {
      "flag": "assets/images/flags/india.png",
      "lang": "తెలుగు",
      "lang_en": "Telugu",
      "value": "te",
    },
    {
      "flag": "assets/images/flags/india.png",
      "lang": "ಕನ್ನಡ",
      "lang_en": "Kannada",
      "value": "kn",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Padding(padding: EdgeInsets.all(25)),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Image.asset(
                      "assets/images/earth-globe.png",
                      width: 80,
                      color: Colors.amber,
                    ),
                    Text(
                      "Select Your Language",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Choose your preferred language to continue"),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(15)),
              Container(
                width: 350,
                height: MediaQuery.of(context).size.height * 0.55,
                child: SingleChildScrollView(
                  child: RadioGroup(
                    onChanged: (value) async {
                      DatabaseHelper.instance.updateLocale(value!);

                      setState(() {
                        locale = value;
                      });

                      Translatehelper.translate("Continue").then((val) {
                        setState(() {
                          continueTxt = val.text;
                        });
                      });
                    },
                    groupValue: locale,
                    child: Column(
                      children: [
                        ...List.generate(available_languages.length, (i) {
                          return RadioListTile(
                            radioScaleFactor: 1.4,
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: Colors.amber,
                            value: available_languages[i]["value"]!,
                            title: Container(
                              child: Row(
                                spacing: 20,
                                children: [
                                  Image.asset(
                                    available_languages[i]["flag"]!,
                                    width: 40,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        available_languages[i]["lang"]!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(available_languages[i]["lang_en"]!),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              ElevatedButton.icon(
                onPressed: () {
                  DatabaseHelper.instance.queryAllCustomise().then((val) {
                    if (val[0]["state"] == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (builder) {
                            return SelectState();
                          },
                        ),
                      );
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (builder) {
                            return Dashboard();
                          },
                        ),
                        (route) => false,
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
                  continueTxt,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
