import 'dart:convert';

import 'package:http/http.dart' as http;

class GetRate {
  static String API_KEY = "QGU1L9DCLXPZNTPSGXC0751PSGXC0";
  static Future<Map<String, double>> goldAndSilver() async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.10.162:8006/Gold-Rate-List/"))
          .timeout(Duration(seconds: 4));
      print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic> res =
            jsonDecode(response.body) as Map<String, dynamic>;
        double goldRate = 0;
        double silverRate = 0;
        print(res["data"].length);

        for (var ele in res["data"]) {
          if (goldRate != 0 && silverRate != 0) break;
          // print(ele);
          if (ele["Type"] == "Gold" && ele["carat"] == 22) {
            print(ele["rate"]);
            goldRate = double.parse(ele["rate"]);
          } else if (ele["Type"] == "Silver") {
            print(ele["rate"]);
            silverRate = double.parse(ele["rate"]);
          }
        }
        return {"gold": goldRate, "silver": silverRate};
      }
      return {"gold": 0, "silver": 3};
    } catch (e) {
      return {"gold": 0, "silver": 3};
    }
  }
}
