import 'dart:convert';

import 'package:http/http.dart' as http;

class GetRate {
  static Future<Map<String, double>> goldAndSilver() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              "https://goldrate.buypapps.com/Gold-Rate-List/?format=json",
            ),
          )
          .timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        List<dynamic> res = jsonDecode(response.body) as List<dynamic>;
        double goldRate = double.parse(res[0]["gold_22k"]);
        double silverRate = double.parse(res[0]["silver_1g"]);

        return {"gold": goldRate, "silver": silverRate};
      }
      return {"gold": 0, "silver": 0};
    } catch (e) {
      print(e);
      return {"gold": 0, "silver": 0};
    }
  }
}
