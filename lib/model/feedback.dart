class Feedback {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;  // Thay đổi từ String thành DateTime
  final int userId;
  final int quizId;

  Feedback({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,  // Cập nhật giá trị kiểu DateTime
    required this.userId,
    required this.quizId,
  });

  // Chuyển đổi từ Map thành Feedback
  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),  // Chuyển từ String thành DateTime
      userId: map['user_id'],
      quizId: map['quiz_id'],
    );
  }

  // Chuyển đổi Feedback thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),  // Chuyển từ DateTime thành String
      'user_id': userId,
      'quiz_id': quizId,
    };
  }
}
