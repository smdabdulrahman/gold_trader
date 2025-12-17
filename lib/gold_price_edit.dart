import 'package:flutter/material.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/dashboard.dart';
import 'package:goldtrader/model/Rates.dart';
import 'package:intl/intl.dart';
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
    final f = NumberFormat.decimalPattern('en_IN');
    String roundAndFormat(double n) {
      double r = (n * 100).round() / 100; // 4 decimals → 2 decimals
      return f.format(r); // Indian format
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(246, 255, 255, 255),
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
                      /*    Column(
                        spacing: 20,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            width: 150,
                            height: 155,
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
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: goldRate,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,

                                          focusedBorder: InputBorder.none,
                                        ),
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
                            height: 155,
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
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: silverRate,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,

                                          focusedBorder: InputBorder.none,
                                        ),
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
                      ), */
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
