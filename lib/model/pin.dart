class Pin {
  int? id;
  int userId;
  DateTime? createdAt;
  DateTime? expiredAt;
  String pinCode;

  Pin({this.id, required this.userId, required this.pinCode,this.createdAt,this.expiredAt});


  Map<String, dynamic> toMap(){
    return {
      'user_id':userId,
      'created_at':DateTime.now().toIso8601String(),
      'expired_at':DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
      'pin':pinCode
    };
  }

  factory Pin.fromMap(Map<String,dynamic> map) {
    return Pin(id: map['id'], userId: map['user_id'], pinCode: map['pin'], createdAt: DateTime.parse(map['created_at']), expiredAt: DateTime.parse(map['expired_at']));
  }

}