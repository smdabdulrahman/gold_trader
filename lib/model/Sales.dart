class Sales {
  final int? id;
  final String date_time;
  final double old_amount;
  final double discount_amount;
  final int final_amount;
  final int customer_id;
  final int count;

  Sales({
    this.id,
    required this.date_time,
    required this.old_amount,
    required this.discount_amount,
    required this.final_amount,
    required this.customer_id,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time': date_time,
      'old_amount': old_amount,
      'discount_amount': discount_amount,
      'final_amount': final_amount,
      'customer_id': customer_id,
      'count': count,
    };
  }

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      id: map['id'],
      date_time: map['date_time'],
      old_amount: map['old_amount'],
      discount_amount: map['discount_amount'],
      final_amount: map['final_amount'],
      customer_id: map['customer_id'],
      count: map['count'],
    );
  }
}
