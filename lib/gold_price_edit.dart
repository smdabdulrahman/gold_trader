import 'package:flutter/material.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/dashboard.dart';
import 'package:goldtrader/model/Rates.dart';
import 'package:sqflite/sqlite_api.dart';

class GoldPriceEdit extends StatefulWidget {
  const GoldPriceEdit({
    super.key,
    required this.goldRate,
    required this.silverRate,
  });
  final double goldRate;
  final double silverRate;

  @override
  State<GoldPriceEdit> createState() => _GoldPriceEditState();
}

class _GoldPriceEditState extends State<GoldPriceEdit> {
  late Future<List<String>> futureRateEditStr;
  @override
  void initState() {
    super.initState();
    List<String> ls = [
      "Edit Rates",
      "Gold Rate",
      "Silver Rate",
      "OK",

      "Rates Successfully Changed",
      "Save Changes",
    ];
    futureRateEditStr = Translatehelper.translateList(ls);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController goldRate = TextEditingController(
      text: widget.goldRate.toString(),
    );
    TextEditingController silverRate = TextEditingController(
      text: widget.silverRate.toString(),
    );

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(backgroundColor: Colors.amber[400]),
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: futureRateEditStr,
            builder: (builder, body) {
              if (body.hasData) {
                return Container(
                  width: 250,
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    spacing: 20,

                    children: [
                      Text(body.data![0], style: TextStyle(fontSize: 25)),
                      Container(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(body.data![1]),
                            TextFormField(
                              controller: goldRate,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(body.data![2]),
                            TextFormField(
                              controller: silverRate,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          DatabaseHelper.instance
                              .updateRates(
                                Rates(
                                  id: 1,
                                  gold: double.parse(goldRate.text),
                                  silver: double.parse(silverRate.text),
                                  last_updated_time: DateTime.now()
                                      .toIso8601String(),
                                ),
                              )
                              .then((val) {
                                showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (builder) {
                                                  return Dashboard();
                                                },
                                              ),
                                              (route) => false,
                                            );
                                          },
                                          child: Text(body.data![3]),
                                        ),
                                      ],
                                      content: Text(body.data![4]),
                                    );
                                  },
                                );
                              });
                        },
                        label: Text(
                          body.data![5],
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(Icons.save_sharp, color: Colors.white),
                      ),
                    ],
                  ),
                );
              } else {
                return Image.asset("assets/images/spinner.gif");
              }
            },
          ),
        ),
      ),
    );
  }
}
