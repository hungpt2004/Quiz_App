class Question {
  final int? id;
  String? imageUrl;
  String content;
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  int correctAnswer;
  final int quizId;

  Question({
    this.id,
    this.imageUrl,
    required this.content,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.correctAnswer,
    required this.quizId,
  });

  // Chuyển đổi từ Map thành Question
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      imageUrl: map['image_url'],
      content: map['content'],
      answer1: map['answer1'],
      answer2: map['answer2'],
      answer3: map['answer3'],
      answer4: map['answer4'],
      correctAnswer: map['correct_answer'],
      quizId: map['quiz_id'],
    );
  }

  // Chuyển đổi Question thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_url': imageUrl ?? '',
      'content': content,
      'answer1': answer1,
      'answer2': answer2,
      'answer3': answer3,
      'answer4': answer4,
      'correct_answer': correctAnswer,
      'quiz_id': quizId,
    };
  }
}
