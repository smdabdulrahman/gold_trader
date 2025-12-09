class OldProduct {
  final int? id;
  final int sales_id;
  final String old_product_name;
  final double less_amount;
  final int final_amount;
  final double gram;
  final double dust;
  final int isGold;
  final int isSilver;

  OldProduct({
    this.id,
    required this.sales_id,
    required this.old_product_name,
    required this.less_amount,
    required this.final_amount,
    required this.gram,
    required this.dust,
    required this.isGold,
    required this.isSilver,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sales_id': sales_id,
      'old_product_name': old_product_name,
      'less_amount': less_amount,
      'final_amount': final_amount,
      'gram': gram,
      'dust': dust,
      'isGold': isGold,
      'isSilver': isSilver,
    };
  }

  factory OldProduct.fromMap(Map<String, dynamic> map) {
    return OldProduct(
      id: map['id'],
      sales_id: map['sales_id'],
      old_product_name: map['old_product_name'],
      less_amount: map['less_amount'],
      final_amount: map['final_amount'],
      gram: map['gram'],
      dust: map['dust'],
      isGold: map['isGold'],
      isSilver: map['isSilver'],
    );
  }
}
