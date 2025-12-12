// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldtrader/helpers/CustomerDbHelper.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/OldProductDbHelper.dart';
import 'package:goldtrader/helpers/PrintHelper.dart';
import 'package:goldtrader/helpers/SalesDbHelper.dart';
import 'package:goldtrader/helpers/SoldProductsDbHelper.dart';
import 'package:goldtrader/model/Customer.dart';
import 'package:goldtrader/model/OldProduct.dart';
import 'package:goldtrader/model/Product.dart';
import 'package:goldtrader/model/Sales.dart';
import 'package:goldtrader/model/SoldProducts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../helpers/FileHelper.dart';

class BillView extends StatefulWidget {
  const BillView({super.key, required this.sale_id});
  final int sale_id;
  @override
  State<BillView> createState() => _BillViewState();
}

class _BillViewState extends State<BillView> {
  late Future<Map<String, dynamic>> futureData;
  @override
  void initState() {
    super.initState();

    futureData = getAllData();
  }

  late String bill_path;
  Future<Map<String, dynamic>> getAllData() async {
    print("heloo");
    //get shop details
    Map<String, dynamic> shopData = (await DatabaseHelper.instance
        .queryShopDetails())[0];

    //get sales details
    Sales sale = await Salesdbhelper.querySale(widget.sale_id);

    //get customer details
    Customer customer = await Customerdbhelper.queryCustomer(sale.customer_id);

    //get sold products
    List<SoldProducts> sold_products = await Soldproductsdbhelper.queryProducts(
      sale.id!,
    );
    List<Map<String, dynamic>> products = await DatabaseHelper.instance
        .queryProducts();
    //get old sold products
    List<OldProduct> old_products = await Oldproductdbhelper.queryOldProducts(
      sale.id!,
    );
    print(customer.toMap());
    print(sale.toMap());
    print("Products length" + sold_products.length.toString());
    print("old Products length" + old_products.length.toString());

    return {
      "shop_details": shopData,
      "sales": sale,
      "customer": customer,
      "sold_products": sold_products,
      "old_products": old_products,
      "products": products,
    };
  }

  String roundAndFormat(double n) {
    double r = (n * 90).round() / 90; // 4 decimals → 2 decimals
    return f.format(r); // Indian format
  }

  Uint8List convertToThermalBW(Uint8List originalBytes) {
    // Decode
    img.Image? image = img.decodeImage(originalBytes);
    if (image == null) return originalBytes;

    // Convert to grayscale
    img.Image grayscale = img.grayscale(image);

    // Increase contrast for thermal printing
    img.Image contrasted = img.adjustColor(grayscale, contrast: 0.5);

    // Encode back to PNG/JPG
    return Uint8List.fromList(img.encodePng(contrasted));
  }

  Future<void> saveAsPdf(
    BuildContext context,
    Map<String, dynamic> shop_details,
    Sales sale,
    DateTime sales_date_time,
    Customer customer,
    List<SoldProducts> sold_products,
    Map<int, dynamic> products,
    int total_amount,
    int total_gst_amount,
    int total_final_amount,
    List<OldProduct> old_products,
  ) async {
    final pdf = pw.Document();

    final logo = pw.MemoryImage(convertToThermalBW(shop_details["logo"]));
    final buyp_logo = pw.MemoryImage(
      convertToThermalBW(
        (await rootBundle.load("assets/images/buyp.png")).buffer.asUint8List(),
      ),
    );

    // 📏 80mm thermal printer page format
    final pageFormat = PdfPageFormat(80 * PdfPageFormat.mm, double.infinity);

    final Poppins_base = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Regular.ttf"),
    );
    final Poppins_bold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Bold.ttf"),
    );
    final Poppins_semibold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Medium.ttf"),
    );
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        theme: pw.ThemeData.withFont(
          base: Poppins_semibold,
          bold: Poppins_bold,
        ),
        margin: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 9),
        build: (pw.Context context) {
          pw.Container dotted_line() => pw.Container(
            height: 1,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: PdfColors.black,
                  width: 1,
                  style: pw.BorderStyle(pattern: [3, 3]), // 3 on, 3 off
                ),
              ),
            ),
          );
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ---------------- SHOP DETAILS ----------------
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Image(logo, width: 50),
                    pw.Text(
                      shop_details["shop_name"],
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "${shop_details["addr_line1"]}, ${shop_details["addr_line2"]}",
                      style: pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text(
                      "Mobile: ${shop_details["mobile_num"]}",
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 3),
              dotted_line(),
              pw.SizedBox(height: 3),
              // ---------------- BILL + CUSTOMER DETAILS ----------------
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    width: pageFormat.availableWidth,
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: pageFormat.availableWidth * 0.5,
                          child: pw.Text(
                            "Bill: ${sale.id}",
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                        pw.Container(
                          width: pageFormat.availableWidth * 0.5,
                          child: pw.Text(
                            "Cust Name: ${customer.name}",
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: pageFormat.availableWidth,
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: pageFormat.availableWidth * 0.5,
                          child: pw.Text(
                            "Date: ${sales_date_time.toString().substring(0, 11)}",
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                        pw.Container(
                          width: pageFormat.availableWidth * 0.5,
                          child: pw.Text(
                            "Phone : ${customer.phone_no}",
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: pageFormat.availableWidth,
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: pageFormat.availableWidth * 0.5,
                          child: pw.Text(
                            "Time: ${sale.date_time.substring(11, 19)}",
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                        pw.Container(
                          width: pageFormat.availableWidth * 0.5,
                          child: pw.Text(
                            "Place: ${customer.place}",
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 6),
              dotted_line(),

              // ---------------- PRODUCTS LIST ----------------
              /*  pw.Text(
                "Products",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ), */
              pw.SizedBox(height: 3),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,

                children: [
                  pw.Container(
                    width: 70,
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      "Product",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),

                  pw.Container(
                    width: 40,
                    alignment: pw.Alignment.centerRight,

                    child: pw.Text(
                      "Gram",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  pw.Container(
                    width: 50,

                    alignment: pw.Alignment.centerRight,

                    child: pw.Text(
                      "Fixed",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),

                  pw.Container(
                    width: 60,
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      "Total",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              dotted_line(),
              ...sold_products.map((p) {
                return pw.Column(
                  children: [
                    pw.SizedBox(height: 3),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 70,
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            products[p.product_id]["product_name"] +
                                (products[p.product_id]["isGold"] == 1
                                    ? " (G)"
                                    : " (S)"),
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),

                        pw.Container(
                          width: 40,
                          alignment: pw.Alignment.centerRight,

                          child: pw.Text(
                            "${p.gram.toStringAsFixed(2)}",
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                        pw.Container(
                          width: 50,
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            (products[p.product_id]["fixed_price"])
                                .toStringAsFixed(2),
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                        pw.Container(
                          width: 60,
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            "${f.format(p.total_amount.toInt())}",
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              pw.SizedBox(height: 6),
              dotted_line(),
              pw.SizedBox(height: 6),
              // ---------------- TOTALS ----------------
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    width: 150,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Total Amount",
                          style: pw.TextStyle(fontSize: 9),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text("GST Amount", style: pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 50,
                    alignment: pw.Alignment.centerRight,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          "₹${f.format(total_amount)}",
                          style: pw.TextStyle(fontSize: 9),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "₹${f.format(total_gst_amount)}",
                          style: pw.TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (old_products.isNotEmpty) ...[
                pw.SizedBox(height: 6),
                dotted_line(),
                pw.SizedBox(height: 6),

                // ---------------- OLD PRODUCTS ----------------
                pw.Text(
                  "Old Gold & Silver",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
                pw.SizedBox(height: 4),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 70,
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Product",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),

                    pw.Container(
                      width: 50,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        "Gram",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 50,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        "Dust",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 50,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        "Total",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                dotted_line(),

                ...old_products.map((p) {
                  return pw.Column(
                    children: [
                      pw.SizedBox(height: 3),

                      pw.Row(
                        children: [
                          pw.Container(
                            width: 70,
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              p.old_product_name +
                                  (p.isGold == 1 ? "(G)" : "(S)"),
                              style: pw.TextStyle(fontSize: 9),
                            ),
                          ),

                          pw.Container(
                            width: 50,
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              "${p.gram.toStringAsFixed(2)}",
                              style: pw.TextStyle(fontSize: 9),
                            ),
                          ),
                          pw.Container(
                            width: 50,
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              (p.dust).toStringAsFixed(2),
                              style: pw.TextStyle(fontSize: 9),
                            ),
                          ),
                          pw.Container(
                            width: 50,
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              "${f.format(p.final_amount.toInt())}",
                              style: pw.TextStyle(fontSize: 9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
                pw.SizedBox(height: 6),
                dotted_line(),
                pw.SizedBox(height: 6),
              ],
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    width: 150,
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Final Amount",
                          style: pw.TextStyle(fontSize: 9),
                        ),
                        pw.Text(
                          "Old Product Total",
                          style: pw.TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 50,
                    alignment: pw.Alignment.centerRight,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          "₹${f.format(total_final_amount)}",
                          style: pw.TextStyle(fontSize: 9),
                        ),
                        pw.Text(
                          "₹${f.format(sale.old_amount)}",
                          style: pw.TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 6),
              dotted_line(),
              pw.SizedBox(height: 3),
              // ---------------- GRAND TOTAL ----------------
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "TOTAL",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "₹${f.format(sale.final_amount - sale.old_amount)}",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 3),
              dotted_line(),
              pw.SizedBox(height: 20),
              pw.Center(child: pw.Text("*** Thank You ***")),
              pw.SizedBox(height: 6),
              pw.Center(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Powered by ", style: pw.TextStyle(fontSize: 12)),
                    pw.Text("BUYP", style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    final weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thrusday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    String weekDay = weekDays[DateTime.parse(sale.date_time).weekday - 1];
    Directory file_dir = Directory(
      Filehelper.dir.path +
          "/" +
          weekDay +
          "_" +
          sale.date_time.substring(0, 10),
    );
    if (!file_dir.existsSync()) file_dir.createSync();

    var pdfFile = File(
      file_dir.path + "/bill_no_" + widget.sale_id.toString() + ".pdf",
    );

    pdfFile.writeAsBytesSync(await pdf.save());

    print("file saved");
  }

  final f = NumberFormat.decimalPattern("en_IN");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: Text("Bill"),
        actions: [
          IconButton(
            onPressed: () {
              final params = ShareParams(
                text: "Share Bill",
                files: [XFile(bill_path)],
              );
              SharePlus.instance.share(params);
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureData,
          builder: (context, body) {
            if (body.hasData) {
              Map<String, dynamic> data = body.data!;
              Map<String, dynamic> shop_details = data["shop_details"];
              Sales sale = data["sales"];
              Customer customer = data["customer"];
              int total_gst_amount = 0;
              int total_final_amount = 0;
              int total_amount = 0;

              List<OldProduct> old_products = data["old_products"];
              List<Map<String, dynamic>> temp_products = data["products"];
              Map<int, dynamic> products = {};
              for (var product in temp_products) {
                products[product["id"]] = product;
              }
              List<SoldProducts> sold_products = data["sold_products"];
              for (var sold in sold_products) {
                int gst_amount = ((sold.gst / 100) * sold.total_amount).toInt();
                total_gst_amount += gst_amount;
                total_amount += (sold.total_amount).toInt();
              }
              total_final_amount = total_amount + total_gst_amount;
              DateTime sales_date_time = DateTime.parse(sale.date_time);
              final weekDays = [
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thrusday",
                "Friday",
                "Saturday",
                "Sunday",
              ];
              String weekDay =
                  weekDays[DateTime.parse(sale.date_time).weekday - 1];
              Directory file_dir = Directory(
                Filehelper.dir.path +
                    "/" +
                    weekDay +
                    "_" +
                    sale.date_time.substring(0, 10),
              );

              bill_path =
                  file_dir.path +
                  "/bill_no_" +
                  widget.sale_id.toString() +
                  ".pdf";

              return billView(
                context,
                shop_details,
                sale,
                sales_date_time,
                customer,
                sold_products,
                products,
                total_amount,
                total_gst_amount,
                total_final_amount,
                old_products,
              );
            }
            return Center(child: Image.asset("assets/images/spinner.gif"));
          },
        ),
      ),
    );
  }

  Center billView(
    BuildContext context,
    Map<String, dynamic> shop_details,
    Sales sale,
    DateTime sales_date_time,
    Customer customer,
    List<SoldProducts> sold_products,
    Map<int, dynamic> products,
    int total_amount,
    int total_gst_amount,
    int total_final_amount,
    List<OldProduct> old_products,
  ) {
    saveAsPdf(
      context,
      shop_details,
      sale,
      sales_date_time,
      customer,
      sold_products,
      products,
      total_amount,
      total_gst_amount,
      total_final_amount,
      old_products,
    );
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              spacing: 9,
              children: [
                //shop details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.memory(shop_details["logo"], width: 50),
                    Text(
                      shop_details["shop_name"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      shop_details["addr_line1"] +
                          "," +
                          shop_details["addr_line2"],
                    ),
                    Text("Mobile : " + shop_details["mobile_num"]),
                  ],
                ),
                DottedLine(),
                //bill detail and customer detail
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bill No : " + sale.id.toString()),
                        Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          "Date : " +
                              (sales_date_time.day.toString()) +
                              "-" +
                              (sales_date_time.month.toString()) +
                              "-" +
                              (sales_date_time.year.toString()),
                        ),
                        Text(
                          "Time : " +
                              sales_date_time.hour.toString() +
                              " : " +
                              (sales_date_time.minute.toString()) +
                              " : " +
                              sales_date_time.second.toString(),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : " + customer.name),
                          Text("Mobile : " + customer.phone_no.toString()),
                          Text("Place : " + customer.place),
                        ],
                      ),
                    ),
                  ],
                ),
                DottedLine(),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            "Product",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            "Type",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            "Gram",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(sold_products.length, (i) {
                      return Column(
                        spacing: 5,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  products[sold_products[i]
                                      .product_id]["product_name"],
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text(
                                  products[sold_products[i]
                                              .product_id]["isGold"] ==
                                          1
                                      ? "Gold"
                                      : "Silver",
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Text(sold_products[i].gram.toString()),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  "₹" +
                                      f.format(
                                        sold_products[i].total_amount.toInt(),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                DottedLine(),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Amount"),
                          Text("GST Amount"),
                          Text("Final Amount"),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 8,
                        children: [
                          Text("₹" + f.format(total_amount)),
                          Text("₹" + f.format(total_gst_amount)),
                          Text("₹" + f.format(total_final_amount)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (old_products.isNotEmpty) DottedLine(),
                if (old_products.isNotEmpty)
                  Column(
                    spacing: 9,
                    children: [
                      Text(
                        "Old Gold & Silver",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              "Product",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              "Type",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              "Gram",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(old_products.length, (i) {
                        return Column(
                          spacing: 5,
                          children: [
                            DottedLine(),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(old_products[i].old_product_name),
                                ),

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Text(
                                    old_products[i].isGold == 1
                                        ? "Gold"
                                        : "Silver",
                                  ),
                                ),

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Text(old_products[i].gram.toString()),
                                ),

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Text(
                                    "₹" +
                                        f.format(old_products[i].final_amount),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                if (old_products.isNotEmpty) DottedLine(),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text("Old Product Total"),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text("₹" + f.format(sale.old_amount)),
                    ),
                  ],
                ),
                DottedLine(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Grand Total",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹" + f.format(sale.final_amount - sale.old_amount),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () async {
                    PrintHelper.print80mmBill(
                      File(bill_path),
                      shop_details["printer_name"],
                      context,
                    );
                    saveAsPdf(
                      context,
                      shop_details,
                      sale,
                      sales_date_time,
                      customer,
                      sold_products,
                      products,
                      total_amount,
                      total_gst_amount,
                      total_final_amount,
                      old_products,
                    );
                  },
                  icon: Icon(Icons.print, color: Colors.white),
                  label: Text(
                    "Print",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
