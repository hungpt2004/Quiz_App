class Quiz {
  final int? id;
  final String description;
  final String title;
  final int isPaid; // Đảm bảo isPaid luôn là kiểu int
  final int? price; // Có thể là null nếu không có giá trị
  final int userId;
  final int subjectId;
  final int typeId;
  final DateTime createdAt;
  final String url;
  final int isFavorite; // Đảm bảo isFavorite luôn là kiểu int

  Quiz({
    this.id,
    required this.description,
    required this.title,
    this.isPaid = 0,
    this.price,
    required this.userId,
    required this.subjectId,
    required this.typeId,
    required this.createdAt,
    required this.url,
    this.isFavorite = 0, // Giá trị mặc định
  });

  // Chuyển đổi từ Map thành Quiz
  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'],
      description: map['description'] ?? '',
      title: map['title'] ?? '',
      isPaid: map['is_paid'] ?? 0,
      price: map['price'], // Không cần gán mặc định nếu giá trị có thể là null
      userId: map['user_id'] ?? 0, // Gán giá trị mặc định để tránh null
      subjectId: map['subject_id'] ?? 0, // Gán giá trị mặc định để tránh null
      typeId: map['type_id'] ?? 0, // Gán giá trị mặc định để tránh null
      createdAt: DateTime.tryParse(map['created_at']) ?? DateTime.now(), // Xử lý trường hợp lỗi khi parse
      url: map['url'] ?? '', // Gán giá trị mặc định
      isFavorite: map['isFavorite'] ?? 0, // Giá trị mặc định
    );
  }

  // Chuyển đổi Quiz thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'title': title,
      'is_paid': isPaid,
      'price': price,
      'user_id': userId,
      'subject_id': subjectId,
      'type_id': typeId,
      'created_at': createdAt.toIso8601String(),
      'url': url,
      'isFavorite': isFavorite,
    };
  }
}
