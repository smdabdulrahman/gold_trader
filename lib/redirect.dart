import 'package:flutter/material.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/dashboard.dart';
import 'package:goldtrader/settings/select_language.dart';
import 'package:goldtrader/shop_pages/shop_details_form.dart';

class Redirect extends StatefulWidget {
  const Redirect({super.key});

  @override
  State<Redirect> createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.queryShopDetails().then((val) {
      if (val.isEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (builder) {
              return SelectLanguage();
            },
          ),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (builder) {
              return Dashboard();
            },
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),

      body: Center(child: Image.asset("assets/images/spinner.gif", width: 80)),
    );
  }
}
