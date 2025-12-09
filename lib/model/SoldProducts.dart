class SoldProducts {
  final int? id;
  final int sales_id;
  final int product_id;
  final double gram;
  final double gst;
  final double total_amount;
  final int final_amount;

  SoldProducts({
    this.id,
    required this.sales_id,
    required this.product_id,
    required this.gram,
    required this.gst,
    required this.total_amount,
    required this.final_amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sales_id': sales_id,
      'product_id': product_id,
      'gram': gram,
      'gst': gst,

      'total_amount': total_amount,
      'final_amount': final_amount,
    };
  }

  factory SoldProducts.fromMap(Map<String, dynamic> map) {
    return SoldProducts(
      id: map['id'],
      sales_id: map['sales_id'],
      product_id: map['product_id'],
      gram: map['gram'],
      gst: map['gst'],
      total_amount: map['total_amount'],
      final_amount: map['final_amount'],
    );
  }
}
