class CartItem {
  final int cartId;
  final int quizId;
  final int quantity;

  CartItem({
    required this.cartId,
    required this.quizId,
    required this.quantity,
  });

  // Tạo một CartItem từ Map (thường dùng khi lấy dữ liệu từ DB)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cartId: map['cart_id'],
      quizId: map['quiz_id'],
      quantity: map['quantity'],
    );
  }

  // Chuyển CartItem thành Map (thường dùng khi lưu vào DB)
  Map<String, dynamic> toMap() {
    return {
      'cart_id': cartId,
      'quiz_id': quizId,
      'quantity': quantity,
    };
  }
}
