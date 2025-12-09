class Customise {
  final int? id;
  final String? locale;
  final String? state;
  final String? district;

  Customise({this.id, this.locale, this.state, this.district});

  Map<String, dynamic> toMap() {
    return {'id': id, 'locale': locale, 'state': state, 'district': district};
  }

  factory Customise.fromMap(Map<String, dynamic> map) {
    return Customise(
      id: map['id'],
      locale: map['locale'],
      state: map['state'],
      district: map['district'],
    );
  }
}
