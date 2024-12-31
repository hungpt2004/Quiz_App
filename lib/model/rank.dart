class Rank {
  final int? id;
  final String name;
  final int minScore;

  Rank({
    this.id,
    required this.name,
    required this.minScore,
  });

  // Chuyển đổi từ Map thành Rank
  factory Rank.fromMap(Map<String, dynamic> map) {
    return Rank(
      id: map['id'],
      name: map['name'],
      minScore: map['min_score'],
    );
  }

  // Chuyển đổi Rank thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'min_score': minScore,
    };
  }
}
