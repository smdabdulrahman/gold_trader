import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  Future<PackageInfo> package_info = PackageInfo.fromPlatform();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(246, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              FutureBuilder(
                future: package_info,
                builder: (context, body) {
                  if (body.hasData) {
                    return Text(
                      " App Version : ${body.data!.version}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }
                  return Text("Loading....");
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12),
                width: 350,
                child: Column(
                  spacing: 10,
                  children: [
                    Image.asset("assets/images/buyp.png", width: 150),
                    Text("158,S.M Complex, Tenkasi, Tamil Nadu 627811"),
                    Text("Website : www.buyp.in"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
