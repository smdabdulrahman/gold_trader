import 'package:flutter/services.dart';

class Shop {
  final int? id;
  final String shop_name;
  final String mobile_num;
  final String addr_line1;
  final String addr_line2;
  final Uint8List logo;
  final String printer_name;

  Shop({
    this.id,
    required this.shop_name,
    required this.mobile_num,
    required this.addr_line1,
    required this.addr_line2,
    required this.logo,
    required this.printer_name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shop_name': shop_name,
      'mobile_num': mobile_num,
      'addr_line1': addr_line1,
      'addr_line2': addr_line2,
      'logo': logo,
      'printer_name': printer_name,
    };
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'],
      shop_name: map['shop_name'],
      mobile_num: map['mobile_num'],
      addr_line1: map['addr_line1'],
      addr_line2: map['addr_line2'],
      logo: map['logo'] as Uint8List,
      printer_name: map['printer_name'],
    );
  }
}
