class Cart {
  final int? id;
  final int userId;

  Cart({
    this.id,
    required this.userId,
  });

  // Tạo một Cart từ Map (thường dùng khi lấy dữ liệu từ DB)
  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'],
      userId: map['user_id'],
    );
  }

  // Chuyển Cart thành Map (thường dùng khi lưu vào DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
    };
  }
}
