import 'dart:io';

import 'package:goldtrader/helpers/FileHelper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Pdfhelper {
  static Future<void> check() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(child: pw.Text("Hello World")); // Center
        },
      ),
    );
    var pdfFile = File(Filehelper.dir.path + "/c.pdf");
    print(Filehelper.dir.path + "c.pdf");
    pdfFile.writeAsBytesSync(await pdf.save());
  }
}
