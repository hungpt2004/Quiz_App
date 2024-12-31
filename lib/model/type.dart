class Type {
  int id;
  String name;

  Type({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name':name
    };
  }

  factory Type.fromMap(Map<String, dynamic> map) {
    return Type(id: map['id'], name: map['name']);
  }

}