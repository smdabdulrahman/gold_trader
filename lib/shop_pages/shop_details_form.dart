import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/dashboard.dart';
import 'package:goldtrader/model/Shop.dart';

class ShopDetailsForm extends StatefulWidget {
  const ShopDetailsForm({super.key});

  @override
  State<ShopDetailsForm> createState() => _ShopDetailsFormState();
}

class _ShopDetailsFormState extends State<ShopDetailsForm> {
  late Future<List<String>> futureTranslatedString;
  final _formKey = GlobalKey<FormState>();
  TextEditingController shop_name = TextEditingController();
  TextEditingController phone_num = TextEditingController();
  TextEditingController addr_line1 = TextEditingController();
  TextEditingController addr_line2 = TextEditingController();
  TextEditingController printer_name = TextEditingController();
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
      "Submit & Continue",
    ]);
  }

  void showErrorSnackBar(String txt, BuildContext context) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt, style: TextStyle(color: Colors.white)),
        action: SnackBarAction(label: "OK", onPressed: () {}),
        backgroundColor: Colors.red[800],
      ),
    );
  }

  File? file;
  Uint8List? fileBytes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: FutureBuilder(
          future: futureTranslatedString,
          builder: (context, body) {
            if (body.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
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
                            file = File(result.files.single.path!);
                            setState(() {
                              if (kIsWeb) {
                                fileBytes = result.files.first.bytes;
                              } else {
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
                            : Image.memory(fileBytes!, width: 70),
                      ),
                      Text(body.data![0], style: TextStyle(fontSize: 30)),
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter shop name";
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter address line 1";
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                                  if (_formKey.currentState!.validate() &&
                                      fileBytes != null) {
                                    DatabaseHelper.instance
                                        .insertShopDetails(
                                          Shop(
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
                                        });
                                  }
                                  if (fileBytes == null) {
                                    showErrorSnackBar("Upload Logo", context);
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
              );
            }
            return Center(child: Image.asset("assets/images/spinner.gif"));
          },
        ),
      ),
    );
  }
}
