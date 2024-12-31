class CompletedQuiz {
  final int userId;
  final int quizId;
  final int? score;
  final DateTime? completedAt; // Thay đổi từ String thành DateTime
  final DateTime? paidAt; // Thay đổi từ String thành DateTime
  int progress;
  int numberCorrect;
  final String status; // Trạng thái lock hoặc unlock

  CompletedQuiz({
    required this.userId,
    required this.quizId,
    this.score = 0,
    this.completedAt, // Kiểu DateTime
    this.paidAt, // Kiểu DateTime
    this.progress = 0,
    this.numberCorrect = 0,
    this.status = 'lock', // Mặc định là 'lock'
  });

  // Chuyển đổi từ Map thành CompletedQuiz
  factory CompletedQuiz.fromMap(Map<String, dynamic> map) {
    return CompletedQuiz(
      userId: map['user_id'],
      quizId: map['quiz_id'],
      score: map['score'],
      completedAt: map['completed_at'] != null
          ? DateTime.tryParse(map['completed_at'])
          : null, // Chuyển từ String thành DateTime
      paidAt: map['paid_at'] != null
          ? DateTime.tryParse(map['paid_at'])
          : null, // Chuyển từ String thành DateTime
      progress: map['progress'],
      numberCorrect: map['number_correct'],
      status: map['status'] ?? 'lock', // Giá trị mặc định là 'lock'
    );
  }

  // Chuyển đổi CompletedQuiz thành Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'quiz_id': quizId,
      'score': score,
      'completed_at': completedAt?.toIso8601String(), // Chuyển từ DateTime thành String
      'paid_at': paidAt?.toIso8601String(), // Chuyển từ DateTime thành String
      'progress':progress ?? 0,
      'number_correct':numberCorrect,
      'status': status, // Thêm cột status
    };
  }

  @override
  String toString() {
    return 'CompletedQuiz{userId: $userId, quizId: $quizId, score: $score, completedAt: $completedAt, paidAt: $paidAt, progress: $progress, status: $status}';
  }

}
