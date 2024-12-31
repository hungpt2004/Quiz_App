class Subject {
  final int? id;
  final String name;

  Subject({
    this.id,
    required this.name,
  });

  // Chuyển đổi từ Map thành Subject
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
    );
  }

  // Chuyển đổi Subject thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
