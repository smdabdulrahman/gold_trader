import 'package:flutter/material.dart';
import 'package:goldtrader/bill_view.dart';
import 'package:goldtrader/helpers/SalesDbHelper.dart';
import 'package:goldtrader/model/Customer.dart';
import 'package:goldtrader/model/Sales.dart';
import 'package:intl/intl.dart';

class BillList extends StatefulWidget {
  const BillList({super.key});

  @override
  State<BillList> createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  Future<List<Sales>> sales_list = Salesdbhelper.querySales();
  final f = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 246, 248, 251),
      appBar: AppBar(
        title: Text("Weekly Sales", style: TextStyle(fontSize: 18)),
      ),
      body: SafeArea(
        child: Expanded(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: sales_list,
              builder: (context, body) {
                if (body.hasData) {
                  List<Sales> records = body.data!;
                  records.sort((a, b) => b.id!.compareTo(a.id!));
                  final weekDays = [
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thrusday",
                    "Friday",
                    "Saturday",
                    "Sunday",
                  ];
                  int? sale_day;
                  int? prev_day;
                  return Column(
                    children: [
                      ...List.generate(records.length, (i) {
                        if (sale_day != null) prev_day = sale_day;
                        sale_day = DateTime.parse(records[i].date_time).weekday;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (prev_day == null || prev_day != sale_day)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 25.0,

                                  vertical: 5,
                                ),
                                child: Text(
                                  weekDays[sale_day! - 1] +
                                      " (" +
                                      records[i].date_time.toString().substring(
                                        0,
                                        10,
                                      ) +
                                      ") ",

                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 25.0,

                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (builder) {
                                        return BillView(
                                          sale_id: records[i].id!,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.amber,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),

                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              Text(
                                                "Bill No",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                "Amount",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                "Time ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 70,
                                            child: VerticalDivider(
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              Text(
                                                "${records[i].id}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Text(
                                                "₹ ${f.format(records[i].final_amount - records[i].old_amount)}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Text(
                                                "${records[i].date_time.toString().substring(11, 19)}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  );
                }
                return Text("No Sales Record Found!");
              },
            ),
          ),
        ),
      ),
    );
  }
}
