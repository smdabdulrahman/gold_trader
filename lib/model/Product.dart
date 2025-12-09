class Product {
  final int? id;
  final String product_name;
  final double fixed_price;
  final int isGold;
  final int isSilver;

  Product({
    this.id,
    required this.product_name,
    required this.fixed_price,
    required this.isGold,
    required this.isSilver,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_name': product_name,
      'fixed_price': fixed_price,
      'isGold': isGold,
      'isSilver': isSilver,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      product_name: map['product_name'],
      fixed_price: map['fixed_price'],
      isGold: map['isGold'],
      isSilver: map['isSilver'],
    );
  }
}
