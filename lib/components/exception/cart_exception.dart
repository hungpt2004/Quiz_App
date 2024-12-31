class CartAlreadyExistException implements Exception {
  final String msg;
  CartAlreadyExistException({required this.msg});
}

class QuizAlreadyExistException implements Exception {
  final String msg;
  QuizAlreadyExistException({required this.msg});
}