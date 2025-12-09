import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.amber,
              padding: EdgeInsets.all(5),
              child: Text(
                "Gold Trader",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              child: Column(
                children: [
                  Column(
                    children: [
                      Text("Select your language"),
                      DropdownMenuFormField(
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "en", label: "English"),
                          DropdownMenuEntry(value: "tn", label: "Tamil"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
