import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/dashboard.dart';
import 'package:goldtrader/model/Shop.dart';

class ShopDetailView extends StatefulWidget {
  const ShopDetailView({super.key, required this.shopData});
  final Map<String, dynamic> shopData;
  @override
  State<ShopDetailView> createState() => _ShopDetailViewState();
}

class _ShopDetailViewState extends State<ShopDetailView> {
  late Future<List<String>> futureTranslatedString;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureTranslatedString = fetchTranslatedString();
  }

  Future<List<String>> fetchTranslatedString() {
    return Translatehelper.translateList([
      "Shop Details",
      "Shop Name",
      "Phone Number",
      "Address Line 1",
      "Address Line 2",
      "Printer name",
      "Update & Continue",
    ]);
  }

  File? file;
  Uint8List? fileBytes;
  @override
  Widget build(BuildContext context) {
    TextEditingController shop_name = TextEditingController(
      text: widget.shopData["shop_name"],
    );
    TextEditingController phone_num = TextEditingController(
      text: widget.shopData["mobile_num"],
    );
    TextEditingController addr_line1 = TextEditingController(
      text: widget.shopData["addr_line1"],
    );
    TextEditingController addr_line2 = TextEditingController(
      text: widget.shopData["addr_line2"],
    );
    TextEditingController printer_name = TextEditingController(
      text: widget.shopData["printer_name"],
    );
    if (fileBytes == null) fileBytes = widget.shopData["logo"];
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        title: Text("Shop Details"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureTranslatedString,
          builder: (context, body) {
            if (body.hasData) {
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                dialogTitle: "Select a logo",
                                type: FileType.image,
                              );

                          if (result != null) {
                            print("file selected");
                            file = File(result.files.single.path!);
                            setState(() {
                              print("s1");
                              if (kIsWeb) {
                                fileBytes = result.files.first.bytes;
                              } else {
                                print("set");
                                fileBytes = file!.readAsBytesSync();
                              }

                              print(file);
                            });
                          } else {
                            // User canceled the picker
                          }
                        },

                        /*  style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[800],
                        ), */
                        child: fileBytes == null
                            ? Icon(Icons.camera_alt_outlined, size: 70)
                            : ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(5),
                                child: Image.memory(fileBytes!, width: 70),
                              ),
                      ),

                      Form(
                        key: _formKey,
                        child: Center(
                          child: Column(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    Text(body.data![1]),
                                    TextFormField(
                                      controller: shop_name,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.store_outlined),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    Text(body.data![2]),
                                    TextFormField(
                                      controller: phone_num,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.phone_android),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    Text(body.data![3]),
                                    TextFormField(
                                      controller: addr_line1,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),

                                        isDense: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    Text(body.data![4]),
                                    TextFormField(
                                      controller: addr_line2,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    Text(body.data![5]),
                                    TextFormField(
                                      controller: printer_name,

                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /*     Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    icon: Icon(
                                      Icons.file_upload,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      FilePickerResult? result = await FilePicker
                                          .platform
                                          .pickFiles(
                                            dialogTitle: "Select a logo",
                                            type: FileType.image,
                                          );
                                      setState(() {
                                        fileBytes = result!.files.first.bytes;
                                      });
                                  
                                      if (result != null) {
                                        setState(() {
                                          file = File(result.files.single.path!);
                                  
                                          print(file);
                                        });
                                      } else {
                                        // User canceled the picker
                                      }
                                    },
                                    label: Text(
                                      body.data![5],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber[800],
                                    ),
                                  ),
                                  if (fileBytes != null)
                                    Image.memory(fileBytes!, width: 30),
                                ],
                              ), */
                              ElevatedButton.icon(
                                onPressed: () {
                                  print("Done file reading..");
                                  DatabaseHelper.instance
                                      .updateShopDetails(
                                        Shop(
                                          id: 1,
                                          shop_name: shop_name.text,
                                          mobile_num: phone_num.text,
                                          addr_line1: addr_line1.text,
                                          addr_line2: addr_line2.text,
                                          logo: fileBytes!,
                                          printer_name: printer_name.text,
                                        ),
                                      )
                                      .then((val) {
                                        print(val);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) {
                                              return Dashboard();
                                            },
                                          ),
                                        );
                                      });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.amber,
                                  ),
                                  minimumSize: WidgetStatePropertyAll(
                                    Size(350, 50),
                                  ),
                                  iconColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  iconSize: WidgetStatePropertyAll(23),
                                ),
                                icon: Icon(Icons.done),

                                label: Text(
                                  body.data![6],
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
                    ],
                  ),
                ),
              );
            }
            return Center(child: Image.asset("assets/images/spinner.gif"));
          },
        ),
      ),
    );
  }
}
