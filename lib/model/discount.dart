class Discount {
  final int? id;
  final int rankId;
  final String name;
  final int value;

  Discount({
    this.id,
    required this.rankId,
    required this.name,
    required this.value,
  });

  // Chuyển đổi từ Map thành Discount
  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'],
      rankId: map['rank_id'],
      name: map['name'],
      value: map['value'],
    );
  }

  // Chuyển đổi Discount thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rank_id': rankId,
      'name': name,
      'value': value,
    };
  }
}
