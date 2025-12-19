// ignore_for_file: non_constant_identifier_names

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldtrader/helpers/FileHelper.dart';
import 'package:goldtrader/sales_pages/bill_list.dart';
import 'package:goldtrader/sales_pages/bill_view.dart';
import 'package:goldtrader/helpers/CustomerDbHelper.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/OldProductDbHelper.dart';
import 'package:goldtrader/helpers/SalesDbHelper.dart';
import 'package:goldtrader/helpers/SoldProductsDbHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/model/Customer.dart';
import 'package:goldtrader/model/OldProduct.dart';
import 'package:goldtrader/model/Product.dart';
import 'package:goldtrader/model/Sales.dart';
import 'package:goldtrader/model/SoldProducts.dart';
import 'package:goldtrader/style.dart';
import 'package:intl/intl.dart';
import 'package:select_field/select_field.dart';
import 'package:sqflite/sqflite.dart';

class GoldEntryForm extends StatefulWidget {
  const GoldEntryForm({super.key});

  @override
  State<GoldEntryForm> createState() => _GoldEntryFormState();
}

class _GoldEntryFormState extends State<GoldEntryForm> {
  late Future<List<Map<String, dynamic>>> futureRates;
  late Future<List<Map<String, dynamic>>> futureProductsList;
  Map<String, String> entryFormTxts = {
    "Gold": "Gold",
    "Save": "Save",
    "Silver": "Silver",
    "Total Amount": "Total Amount",
    "Less": "Less",
    "Count": "Count",
    "GST Amount": "GST Amount",
    "Final amount": "Final Amount",
    "Old Gold Credit": "Old Gold Credit",
    "Amount to be paid": "Amount to be paid ",
    "Summary": "Summary",
    "Customer Details": "Customer Details",
    "Name": "Name",
    "Place": "Place",
    "Phone no": "Phone no",
    "Add Product": "Add Product",
    "Select Product": "Select Product",
    "Fixed amount": "Fixed amount",
    "Gram": "Gram",
    "GST": "GST",
    "Product List": "Product List",
    "Old Product List": "Old Product List",
    "Old Gold & Silver Entry": "Old Gold & Silver Entry",
    "Product Name": "Product Name",
    "Dust": "Dust",
    "Less Amount": "Less Amount",
    "Add": "Add",
    "No Products added": "No Products added",
    "Old Product List": "Old Product List",
    "Old Total Amount": "Old Total Amount",
  };
  double goldPrice = 0;
  double silverPrice = 0;
  Map<String, dynamic> fetchedProductsList = {};
  List<Map<String, dynamic>> addedProducts = [];
  List<Map<String, dynamic>> addedOldProducts = [];
  List<bool> _whichMetalIsSelected = [true, false];
  double total_amount = 0;
  int count = 0;
  double gst_amount = 0;
  int final_amount = 0;
  int old_final_amount = 0;
  TextEditingController cust_name = TextEditingController();
  TextEditingController cust_place = TextEditingController();
  TextEditingController cust_phone_no = TextEditingController();
  TextEditingController gram = TextEditingController();
  TextEditingController GST = TextEditingController();
  TextEditingController old_gram = TextEditingController();
  TextEditingController old_dust = TextEditingController();
  TextEditingController old_less_amount = TextEditingController();
  TextEditingController old_product_name = TextEditingController();
  TextEditingController product_controller = TextEditingController();
  bool isTranslated = false;
  final f = NumberFormat.decimalPattern('en_IN');
  int product_id = 0;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    futureRates = DatabaseHelper.instance.queryRates();
    futureProductsList = DatabaseHelper.instance.queryProducts();

    Translatehelper.translateListMap(entryFormTxts).then((val) {
      setState(() {
        entryFormTxts = val;
        isTranslated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(246, 255, 255, 255),

      appBar: AppBar(
        title: Text(
          "Gold Estimation",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.amber[400],

        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sell_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) {
                    return BillList();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!isTranslated)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Image.asset("assets/images/spinner.gif", scale: 2),
                    ),
                  ),
                if (isTranslated)
                  Column(
                    children: [
                      Padding(padding: EdgeInsets.all(4)),
                      //rates
                      metalRates(),
                      /*       firstSection(), */

                      //customer details
                      customerDetails(),

                      //product entry
                      addProduct(),
                      Padding(padding: EdgeInsets.all(2)),

                      Container(
                        width: 350,

                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 0.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 6),
                              child: Text(
                                entryFormTxts["Product List"]!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (addedProducts.isEmpty)
                              Center(
                                child: Text(
                                  entryFormTxts["No Products added"]!,
                                ),
                              ),
                            if (addedProducts.isNotEmpty)
                              ...List.generate(addedProducts.length, (i) {
                                TextStyle txtstyle = TextStyle(
                                  color: Colors.black,
                                );
                                return Container(
                                  width: 350,
                                  height: 85,
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(4),

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border(
                                      left: BorderSide(
                                        width: 8,
                                        color:
                                            addedProducts[i]["product"]["isGold"] ==
                                                1
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      right: BorderSide(
                                        width: 0.5,
                                        color:
                                            addedProducts[i]["product"]["isGold"] ==
                                                1
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      top: BorderSide(
                                        width: 0.5,
                                        color:
                                            addedProducts[i]["product"]["isGold"] ==
                                                1
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      bottom: BorderSide(
                                        width: 0.5,
                                        color:
                                            addedProducts[i]["product"]["isGold"] ==
                                                1
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: 5,
                                            children: [
                                              Text(
                                                addedProducts[i]["product"]["product_name"],

                                                style: txtstyle,
                                              ),
                                              Row(
                                                spacing: 10,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        entryFormTxts["Gram"]!,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        addedProducts[i]["gram"] +
                                                            "g",
                                                        style: txtstyle,
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(Icons.stop, size: 8),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        entryFormTxts["GST"]!,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        addedProducts[i]["GST"] +
                                                            "%",
                                                        style: txtstyle,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(),
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    entryFormTxts["Fixed amount"]!,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹ " +
                                                        roundAndFormat(
                                                          addedProducts[i]["product"]["fixed_price"],
                                                        ),
                                                    style: txtstyle,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    entryFormTxts["Final amount"]!,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹ " +
                                                        f.format(
                                                          addedProducts[i]["final_amount"],
                                                        ),

                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.08,

                                        height: 85,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              count -= 1;
                                              total_amount -=
                                                  addedProducts[i]["total_amount"];
                                              gst_amount -=
                                                  addedProducts[i]["gst_amount"];
                                              final_amount -=
                                                  addedProducts[i]["final_amount"]
                                                      as int;
                                              addedProducts.removeAt(i);
                                            });
                                          },
                                          style: IconButton.styleFrom(
                                            padding: EdgeInsets.all(2),
                                          ),
                                          icon: Icon(
                                            Icons.delete_outline_outlined,
                                            color: Colors.red[800],
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            Padding(padding: EdgeInsets.all(4)),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(6)),
                      //old gold entry
                      oldMetalEntry(),
                      Padding(padding: EdgeInsets.all(2)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 0.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(4),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 6),
                              child: Text(
                                entryFormTxts["Old Product List"]!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (addedOldProducts.isEmpty)
                              Center(
                                child: Text(
                                  entryFormTxts["No Products added"]!,
                                ),
                              ),

                            if (addedOldProducts.isNotEmpty)
                              ...List.generate(addedOldProducts.length, (i) {
                                TextStyle txtstyle = TextStyle(
                                  color: Colors.black,
                                );
                                return Container(
                                  width: 350,
                                  height: 85,

                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      left: BorderSide(
                                        width: 8,
                                        color: addedOldProducts[i]["isGold"]
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      right: BorderSide(
                                        width: 0.5,
                                        color: addedOldProducts[i]["isGold"]
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      top: BorderSide(
                                        width: 0.5,
                                        color: addedOldProducts[i]["isGold"]
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      bottom: BorderSide(
                                        width: 0.5,
                                        color: addedOldProducts[i]["isGold"]
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.4,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: 5,
                                            children: [
                                              Text(
                                                addedOldProducts[i]["product_name"],
                                                style: txtstyle,
                                              ),
                                              Row(
                                                spacing: 10,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        entryFormTxts["Gram"]!,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        addedOldProducts[i]["gram"] +
                                                            "g",
                                                        style: txtstyle,
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(Icons.stop, size: 8),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        entryFormTxts["Dust"]!,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        addedOldProducts[i]["dust"] +
                                                            "g",
                                                        style: txtstyle,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(),
                                      Padding(padding: EdgeInsets.all(8)),
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    entryFormTxts["Less Amount"]!,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹ " +
                                                        f.format(
                                                          addedOldProducts[i]["less_amount"],
                                                        ),
                                                    style: txtstyle,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    entryFormTxts["Final amount"]!,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹ " +
                                                        f.format(
                                                          addedOldProducts[i]["final_amount"],
                                                        ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.08,

                                        height: 85,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              old_final_amount =
                                                  old_final_amount -
                                                          addedOldProducts[i]["final_amount"]
                                                      as int;
                                              addedOldProducts.removeAt(i);
                                            });
                                          },
                                          style: IconButton.styleFrom(
                                            padding: EdgeInsets.all(2),
                                          ),
                                          icon: Icon(
                                            Icons.delete_outline_outlined,
                                            color: Colors.red[800],
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            Padding(padding: EdgeInsets.all(3)),
                          ],
                        ),
                      ),
                      if (addedOldProducts.isNotEmpty ||
                          addedProducts.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(12),
                          width: 350,
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entryFormTxts["Summary"]!,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(4)),
                              Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Column(
                                    spacing: 6,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entryFormTxts["Total Amount"]!,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        entryFormTxts["GST Amount"]!,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        entryFormTxts["Final amount"]!,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        entryFormTxts["Old Gold Credit"]!,
                                        style: TextStyle(fontSize: 14),
                                      ),

                                      Text(
                                        entryFormTxts["Amount to be paid"]!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    spacing: 6,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "₹" + roundAndFormat(total_amount),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        "₹" + roundAndFormat(gst_amount),
                                        style: TextStyle(fontSize: 14),
                                      ),

                                      Text(
                                        "₹" + f.format(final_amount),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        "₹" + f.format(old_final_amount),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        "₹" +
                                            f.format(
                                              final_amount - old_final_amount,
                                            ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (addedOldProducts.isNotEmpty ||
                          addedProducts.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                            //save customer
                            saveSale();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(350, 50),
                            backgroundColor: Colors.amber,
                          ),
                          child: Text(
                            entryFormTxts["Save"]!,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      Padding(padding: EdgeInsets.all(4)),
                    ],
                  ),
              ],
            ),
          ),
        ),
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

  void saveSale() {
    if (cust_name.text == "" ||
        cust_place.text == "" ||
        cust_phone_no.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Complete Customer Details",
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(label: "Ok", onPressed: () {}),
          backgroundColor: Colors.red[800],
        ),
      );
      return;
    }
    //save customer
    Customerdbhelper.insertCustomer(
      Customer(
        name: cust_name.text,
        place: cust_place.text,
        phone_no: int.parse(cust_phone_no.text),
      ),
    ).then((customer_id) {
      //add sale
      Salesdbhelper.insertSale(
        Sales(
          date_time: DateTime.now().toIso8601String(),
          old_amount: old_final_amount.toDouble(),
          discount_amount: 0,
          final_amount: final_amount,
          customer_id: customer_id,
          count: count,
        ),
      ).then((sales_id) async {
        //add products
        print("Total no of addedProducts" + addedProducts.length.toString());
        for (var product in addedProducts) {
          await Soldproductsdbhelper.insertProducts(
            SoldProducts(
              sales_id: sales_id,
              product_id: product["product"]["id"],
              gram: double.parse(product["gram"]),
              gst: double.parse(product["GST"]),
              total_amount: product["total_amount"],
              final_amount: product["final_amount"],
            ),
          );
        }
        //add old products
        print("Total no of addedProducts" + addedOldProducts.length.toString());
        for (var oldProduct in addedOldProducts) {
          await Oldproductdbhelper.insertOldProducts(
            OldProduct(
              sales_id: sales_id,
              old_product_name: oldProduct["product_name"],
              less_amount: oldProduct["less_amount"],
              final_amount: oldProduct["final_amount"],
              gram: double.parse(oldProduct["gram"]),
              dust: double.parse(oldProduct["dust"]),
              isGold: oldProduct["isGold"] ? 1 : 0,
              isSilver: oldProduct["isGold"] ? 0 : 1,
            ),
          );
        }
        setState(() {
          addedProducts.clear();
          addedOldProducts.clear();
          total_amount = 0;
          final_amount = 0;
          gst_amount = 0;
          old_final_amount = 0;
        });
        sendSuccessMsg(sales_id);
      });
    });

    cust_name.clear();
    cust_place.clear();

    cust_phone_no.clear();
    product_controller.clear();
    gram.clear();
    GST.clear();
    old_gram.clear();
    old_dust.clear();
    old_less_amount.clear();

    old_product_name.clear();
  }

  void sendSuccessMsg(int sales_id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (builder) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.check_circle_outlined,
            color: Colors.green,
            size: 50,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text("Successfully Saved", style: TextStyle(fontSize: 16)),
          content: Text("Your file has been saved in the GoldTrader Folder"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (builder) {
                      return BillView(sale_id: sales_id);
                    },
                  ),
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Container oldMetalEntry() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),

      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            entryFormTxts["Old Gold & Silver Entry"]!,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(6),
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.15,
                    maxHeight: 32,
                    minHeight: 32,
                  ),
                  children: [
                    Text(
                      entryFormTxts["Gold"]!,
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      entryFormTxts["Silver"]!,
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                  isSelected: _whichMetalIsSelected,
                  onPressed: (index) {
                    setState(() {
                      _whichMetalIsSelected[index] = true;
                      if (index == 1) {
                        _whichMetalIsSelected[0] = false;
                      } else {
                        _whichMetalIsSelected[1] = false;
                      }
                    });
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: old_product_name,

                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                      hintText: entryFormTxts["Product Name"]!,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),

                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: old_gram,
                    validator: (value) {
                      if (value == "" || value!.isEmpty) {
                        return "enter gram";
                      }
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),
                      hintText: entryFormTxts["Gram"]!,
                      prefixIcon: Icon(Icons.toll),
                      prefixIconConstraints: BoxConstraints(minWidth: 28),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),

                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: old_dust,

                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),
                      hintText: entryFormTxts["Dust"]!,
                      prefixIcon: Icon(Icons.cleaning_services, size: 15),
                      prefixIconConstraints: BoxConstraints(minWidth: 20),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),

                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: old_less_amount,

                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      hintText: entryFormTxts["Less"]!,
                      prefixIcon: Icon(Icons.currency_rupee, size: 15),
                      prefixIconConstraints: BoxConstraints(minWidth: 22),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),

                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () {
                      if (old_product_name.text == "" ||
                          old_dust.text == "" ||
                          old_gram.text == "" ||
                          old_less_amount.text == "") {
                        showErrorSnackBar("Complete old gold & silver details");
                        return;
                      }
                      int calc_final_amount() {
                        double old_gram_val = double.parse(old_gram.text);

                        double less_amount_val = double.parse(
                          old_less_amount.text,
                        );
                        double metal_price = _whichMetalIsSelected[0]
                            ? goldPrice
                            : silverPrice;
                        return ((metal_price - less_amount_val) * old_gram_val)
                            .toInt();
                      }

                      int temp_final_amount = calc_final_amount();
                      setState(() {
                        addedOldProducts.add({
                          "product_name": old_product_name.text,
                          "isGold": _whichMetalIsSelected[0],
                          "gram": old_gram.text,
                          "dust": old_dust.text,
                          "less_amount": double.tryParse(old_less_amount.text),
                          "final_amount": temp_final_amount,
                        });
                        old_final_amount += temp_final_amount;
                      });
                      old_gram.clear();
                      old_less_amount.clear();
                      old_dust.clear();
                      old_product_name.clear();

                      print(addedOldProducts);
                    },
                    child: Text(
                      entryFormTxts["Add"]!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container addProduct() {
    TextEditingController dummy = TextEditingController();
    final _addProductFormKey = GlobalKey<FormState>();
    final _dropDownKey = GlobalKey<FormFieldState>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entryFormTxts["Add Product"]!,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.all(4)),

          //gold or silver toggle button
          Form(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(6),
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.15,
                    maxHeight: 32,
                    minHeight: 32,
                  ),
                  children: [
                    Text(
                      entryFormTxts["Gold"]!,
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      entryFormTxts["Silver"]!,
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                  isSelected: _whichMetalIsSelected,
                  onPressed: (index) {
                    setState(() {
                      //futureProductsList = DatabaseHelper.instance
                      // .queryProducts();
                      product_controller.clear();
                      product_id = 0;
                      _whichMetalIsSelected[index] = true;
                      if (index == 1) {
                        _whichMetalIsSelected[0] = false;
                      } else {
                        _whichMetalIsSelected[1] = false;
                      }
                    });
                  },
                ),

                //product selection
                FutureBuilder(
                  future: futureProductsList,
                  builder: (builder, body) {
                    print("reendering...");
                    if (body.hasData) {
                      List<Map<String, dynamic>> currList = [];
                      for (var ele in body.data!) {
                        fetchedProductsList[ele["id"].toString()] = ele;
                        if (_whichMetalIsSelected[0] && ele["isGold"] == 1) {
                          currList.add(ele);
                        } else if (_whichMetalIsSelected[1] &&
                            ele["IsSilver"] == 1) {
                          currList.add(ele);
                        }
                      }

                      /*   return Container(
                        width: 150,
                        child: DropdownSearch(
                          popupProps: PopupProps.menu(
                            fit: FlexFit.loose,
                            showSearchBox: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              product_id = value!.$2;
                            });
                          },
                          compareFn: (item1, item2) => item1.$1 == item2.$2,
                          items: (f, cs) => [
                            ...List.generate(currList.length, (i) {
                              return (
                                currList[i]["product_name"] +
                                    "    ₹" +
                                    currList[i]["fixed_price"].toString(),
                                currList[i]["id"],
                              );
                            }),
                          ],
                        ),
                      ); */
                      List<Option> options = currList.map((e) {
                        return Option(label: e["product_name"], value: e["id"]);
                      }).toList();
                      if (options.isEmpty)
                        options.add(
                          Option(label: "No products were added", value: 0),
                        );
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 32,
                        child: SelectField(
                          key: ValueKey(_whichMetalIsSelected.toString()),
                          options: options,
                          textAlignVertical: TextAlignVertical.center,
                          textController: product_controller,
                          searchOptions: SearchOptions(
                            filterBy: (option, query) {
                              return option.label.toLowerCase().startsWith(
                                query.toLowerCase(),
                              );
                            },
                          ),
                          onOptionSelected: (option) {
                            if (option.label != "No products were added")
                              product_controller.text = option.label;
                            setState(() {
                              product_id = option.value;
                            });
                          },
                          onSaved: (value) {},
                          inputStyle: TextStyle(fontSize: 12),
                          inputDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 221, 220, 220),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(8),
                            hint: Text(
                              entryFormTxts["Product Name"]!,
                              style: TextStyle(fontSize: 12),
                            ),
                            hintStyle: TextStyle(fontSize: 6),

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),

                            isDense: true,
                          ),
                          menuDecoration: MenuDecoration(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),

                            separatorBuilder: (context, index) {
                              return SizedBox(height: 0);
                            },
                            buttonStyle: ButtonStyle(),
                            backgroundDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            height: 200,
                          ),
                        ),
                      );
                    } else {
                      return Text("loading..");
                    }
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: gram,
                    validator: (value) {
                      if (value == "" || value!.isEmpty) {
                        return "enter gram";
                      }
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      hint: Text(
                        entryFormTxts["Gram"]!,
                        style: TextStyle(fontSize: 12),
                      ),
                      hintStyle: TextStyle(fontSize: 6),
                      prefixIcon: Icon(Icons.toll),
                      prefixIconConstraints: BoxConstraints(minWidth: 25),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),

                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: 140,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 12),
                    controller: GST,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == "" || value!.isEmpty) {
                        return "enter gst";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),
                      hint: Text(
                        entryFormTxts["GST"]!,
                        style: TextStyle(fontSize: 12),
                      ),

                      suffixIcon: Icon(Icons.percent),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),

                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () {
                      if (GST.text == "") {
                        GST.text = "0";
                      }

                      if (product_id == 0 || gram.text == "") {
                        showErrorSnackBar("Complete Product Details");
                        return;
                      }
                      /*  if (!_addProductFormKey.currentState!.validate()) {
                        return;
                      } */

                      double calc_total_amount() {
                        double temp_gram = double.parse(gram.text);
                        double temp_amount =
                            temp_gram *
                            (_whichMetalIsSelected[0]
                                ? goldPrice
                                : silverPrice);

                        return temp_amount +
                            fetchedProductsList[product_id
                                .toString()]["fixed_price"];
                      }

                      double product_tot_amount = calc_total_amount();

                      double product_gst_amount =
                          (double.tryParse(GST.text)! / 100) *
                          product_tot_amount;
                      int product_final_amount =
                          product_gst_amount.toInt() +
                          product_tot_amount.toInt();

                      setState(() {
                        addedProducts.add({
                          "product": fetchedProductsList[product_id.toString()],
                          "gram": gram.text,
                          "GST": GST.text,
                          "total_amount": product_tot_amount,
                          "gst_amount": product_gst_amount,
                          "final_amount": product_final_amount,
                        });
                        total_amount += product_tot_amount;

                        gst_amount += product_gst_amount;
                        count += 1;
                        final_amount += product_final_amount;
                      });
                      gram.clear();
                      GST.clear();

                      dummy.clear();
                      product_controller.clear();
                    },
                    child: Text(
                      entryFormTxts["Add"]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Form customerDetails() {
    return Form(
      child: Container(
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 0.5),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.center,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entryFormTxts["Customer Details"]!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: cust_name,
                    style: TextStyle(fontSize: 12),

                    textAlignVertical: TextAlignVertical.center,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(4),
                      hintText: entryFormTxts["Name"]!,
                      fillColor: Colors.grey[50],
                      hintStyle: TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),

                      border: OutlineInputBorder(),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 25,
                        minHeight: 32,
                      ),

                      prefixIcon: Icon(Icons.person_2_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),

                      isDense: true,
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: cust_phone_no,
                    style: TextStyle(fontSize: 12),

                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(4),
                      hintText: entryFormTxts["Phone no"]!,
                      hintStyle: TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),
                      fillColor: Colors.grey[50],

                      border: OutlineInputBorder(),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 22,
                        minHeight: 32,
                      ),

                      prefixIcon: Icon(Icons.phone),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.circular(5),
                      ),

                      isDense: true,
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 32,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 12),
                    controller: cust_place,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 12),
                      fillColor: Colors.grey[50],

                      contentPadding: EdgeInsets.all(4),
                      border: OutlineInputBorder(),
                      hintText: entryFormTxts["Place"]!,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 221, 220, 220),
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 25,
                        minHeight: 32,
                      ),

                      prefixIcon: Icon(Icons.location_city_rounded),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),

                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container firstSection() {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      height: 70,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text("Total Amount : ₹" + roundAndFormat(total_amount)),
              Text("Count : $count"),
            ],
          ),
          VerticalDivider(width: 1, color: Colors.grey, thickness: 1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text("GST Amount : ₹" + roundAndFormat(gst_amount)),
              Text("Final Amount : ₹" + f.format(final_amount)),
            ],
          ),
        ],
      ),
    );
  }

  String roundAndFormat(double n) {
    double r = (n * 100).round() / 100; // 4 decimals → 2 decimals
    return f.format(r); // Indian format
  }

  FutureBuilder<List<Map<String, dynamic>>> metalRates() {
    return FutureBuilder(
      future: futureRates,
      builder: (builder, body) {
        if (body.hasData) {
          goldPrice = body.data![0]["gold"];
          silverPrice = body.data![0]["silver"];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                alignment: Alignment.center,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entryFormTxts["Gold"]!),
                    Text(
                      "₹" + roundAndFormat(body.data![0]["gold"]) + "/g",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(3),
                alignment: Alignment.center,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entryFormTxts["Silver"]!),
                    Text(
                      "₹" + roundAndFormat(body.data![0]["silver"]) + "/g",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text("Loading...");
        }
      },
    );
  }
}
