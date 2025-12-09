import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldtrader/helpers/FileHelper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:printing/printing.dart';
import 'package:image/image.dart';

class PrintHelper {
  static Future<void> askPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.locationWhenInUse, // Sometimes still required for scanning
    ].request();

    // Check individual statuses if needed
    print(statuses);
  }

  static Future<List<Uint8List>> convertPdfToImages(File pdfFile) async {
    final List<Uint8List> images = [];
    final Uint8List documentBytes = await pdfFile.readAsBytes();

    // The raster function processes the PDF pages into an image stream
    await for (var page in Printing.raster(
      await documentBytes,
      pages: [0],
      dpi: 175,
    )) {
      final imageBytes = await page
          .toPng(); // or page.toImage() for a Flutter Image object
      images.add(imageBytes);
    }
    return images;
  }

  static Future<void> print80mmBill(File pdf, String printer_name) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    if (await PrintBluetoothThermal.isPermissionBluetoothGranted) {
      if (await PrintBluetoothThermal.bluetoothEnabled) {
        String? printer_mac;

        //getting mac address of the printer
        (await PrintBluetoothThermal.pairedBluetooths).forEach((e) {
          if (e.name == printer_name) {
            printer_mac = e.macAdress;
          }
        });
        if (printer_mac == null) {
          print("Printer is not paired");
          return;
        }
        if (await PrintBluetoothThermal.connectionStatus) {
          print("connected printing..");
          // PrintBluetoothThermal.writeBytes(
          //File(Filehelper.dir.path + "/bill_no_19.pdf").readAsBytesSync(),
          // );

          Uint8List imgg = (await convertPdfToImages(pdf))[0];

          PrintBluetoothThermal.writeBytes(generator.image(decodeImage(imgg)!));
          PrintBluetoothThermal.writeBytes(generator.cut());
          // Add some line feeds (important)

          /*   PrintBluetoothThermal.writeString(
            printText: PrintTextSize(size: 2, text: "hello world\n"),
          ).then((val) {

            print(val);
          }); */
        } else {
          PrintBluetoothThermal.connect(macPrinterAddress: printer_mac!).then((
            val,
          ) async {
            if (val) {
              Uint8List imgg = (await convertPdfToImages(pdf))[0];

              PrintBluetoothThermal.writeBytes(
                generator.image(decodeImage(imgg)!),
              );
              PrintBluetoothThermal.writeBytes(generator.cut());
            }
          });
        }
      } else {
        print("bluetooth is not enabled");
      }
    } else {
      print("not granted");
      askPermission();
    }
  }
}
