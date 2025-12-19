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
      "Bluetooth Printer name",
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
      backgroundColor: Color.fromARGB(246, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        title: Text("Shop Details"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureTranslatedString,
          builder: (context, body) {
            if (body.hasData) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
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
                                  borderRadius: BorderRadiusGeometry.circular(
                                    5,
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      Text(
                                        body.data![1],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextFormField(
                                        style: TextStyle(fontSize: 12),
                                        controller: shop_name,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter shop name";
                                          }
                                          return null;
                                        },
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                255,
                                                221,
                                                220,
                                                220,
                                              ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.all(8),
                                          hintStyle: TextStyle(fontSize: 6),
                                          prefixIcon: Icon(Icons.store),
                                          prefixIconConstraints: BoxConstraints(
                                            minWidth: 25,
                                          ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      Text(
                                        body.data![2],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: phone_num,
                                        style: TextStyle(fontSize: 12),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter phone number";
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                255,
                                                221,
                                                220,
                                                220,
                                              ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.all(8),
                                          hintStyle: TextStyle(fontSize: 6),
                                          prefixIcon: Icon(Icons.phone),
                                          prefixIconConstraints: BoxConstraints(
                                            minWidth: 25,
                                          ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      Text(body.data![3]),
                                      TextFormField(
                                        controller: addr_line1,
                                        maxLines: 3,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter address line 1";
                                          }
                                          return null;
                                        },
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                255,
                                                221,
                                                220,
                                                220,
                                              ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.all(8),
                                          hintStyle: TextStyle(fontSize: 6),

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      Text(body.data![4]),
                                      TextFormField(
                                        controller: addr_line2,
                                        maxLines: 3,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter address line 2";
                                          }
                                          return null;
                                        },
                                        textInputAction: TextInputAction.next,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      Text(body.data![5]),
                                      TextFormField(
                                        controller: printer_name,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter bluetooth printer name ";
                                          }
                                          return null;
                                        },
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
                                    if (_formKey.currentState!.validate()) {
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
                                    }
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
