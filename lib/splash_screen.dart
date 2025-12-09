import 'package:flutter/material.dart';
import 'package:flutter_animated_splash/flutter_animated_splash.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/home.dart';
import 'package:goldtrader/redirect.dart';
import 'package:goldtrader/settings/select_language.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplash(
      type: Transition.rightToLeftWithFade,
      curve: Curves.easeInOut,
      navigator: Redirect(),
      durationInSeconds: 1,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/s1.png', width: 200),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.amber),
              child: Text(
                "Gold Trader",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
