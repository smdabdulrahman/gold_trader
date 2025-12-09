import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/model/Customise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class Translatehelper {
  static Future<Translation> translate(String txt) async {
    final translator = GoogleTranslator();
    List<Map<String, dynamic>> customise = await DatabaseHelper.instance
        .queryAllCustomise();

    final locale = customise[0]["locale"];

    return translator.translate(txt, from: 'en', to: locale!);
  }

  static Future<List<String>> translateList(List<String> ls) async {
    final translator = GoogleTranslator();
    List<Map<String, dynamic>> customise = await DatabaseHelper.instance
        .queryAllCustomise();

    final locale = customise[0]["locale"];

    if (locale == "en") return ls;

    List<String> translatedStrs = [];
    for (var txt in ls) {
      Translation translation = await translator.translate(
        txt,
        from: 'en',
        to: locale!,
      );
      translatedStrs.add(translation.text);
    }
    return translatedStrs;
  }

  static Future<Map<String, String>> translateListMap(
    Map<String, String> ls,
  ) async {
    final translator = GoogleTranslator();
    List<Map<String, dynamic>> customise = await DatabaseHelper.instance
        .queryAllCustomise();

    final locale = customise[0]["locale"];
    print(locale);
    if (locale == "en") return ls;
    Map<String, String> translatedStrs = {};
    for (var entry in ls.entries) {
      Translation translation = await translator.translate(
        entry.value,
        from: 'en',
        to: locale!,
      );
      translatedStrs[entry.key] = translation.text;
    }
    print(translatedStrs);
    return translatedStrs;
  }

  static Future<List<Map<String, String>>> translateListExtra(
    List<String> ls,
  ) async {
    final translator = GoogleTranslator();
    List<Map<String, dynamic>> customise = await DatabaseHelper.instance
        .queryAllCustomise();

    final locale = customise[0]["locale"];

    List<Map<String, String>> translatedStrs = [];
    if (locale == "en") {
      for (var txt in ls) {
        translatedStrs.add({"name": txt, "value": txt});
      }
      return translatedStrs;
    }

    for (var txt in ls) {
      Translation translation = await translator.translate(
        txt,
        from: 'en',
        to: locale!,
      );
      translatedStrs.add({"name": translation.text, "value": txt});
    }
    return translatedStrs;
  }
}
