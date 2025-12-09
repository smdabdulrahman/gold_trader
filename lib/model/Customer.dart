class Customer {
  final int? id;
  final String name;
  final String place;
  final int phone_no;

  Customer({
    this.id,
    required this.name,
    required this.place,
    required this.phone_no,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'place': place, 'phone_no': phone_no};
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      place: map['place'],
      phone_no: map['phone_no'],
    );
  }
}
