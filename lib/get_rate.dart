import 'dart:convert';

import 'package:http/http.dart' as http;

class GetRate {
  static String API_KEY = "QGU1L9DCLXPZNTPSGXC0751PSGXC0";
  static Future<Map<String, double>> goldAndSilver() async {
    final response = await http.get(
      Uri.parse(
        "https://api.metals.dev/v1/metal/authority?api_key=QGU1L9DCLXPZNTPSGXC0751PSGXC0&authority=mcx&currency=INR&unit=g",
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> res =
          jsonDecode(response.body) as Map<String, dynamic>;
      print(res["rates"]["mcx_silver"]);
      return {
        "gold": res["rates"]["mcx_gold"],
        "silver": res["rates"]["mcx_silver"],
      };
    }
    return {"gold": 4, "silver": 3};
  }
}
