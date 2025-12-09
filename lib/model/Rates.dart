class Rates {
  final int? id;
  final double gold;
  final double silver;
  final String last_updated_time;
  Rates({
    this.id,
    required this.gold,
    required this.silver,
    required this.last_updated_time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gold': gold,
      'silver': silver,
      'last_updated_time': last_updated_time,
    };
  }

  factory Rates.fromMap(Map<String, dynamic> map) {
    return Rates(
      id: map['id'],
      gold: map['gold'],
      silver: map['silver'],
      last_updated_time: map['last_updated_time'],
    );
  }
}
