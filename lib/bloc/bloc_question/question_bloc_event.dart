import '../../model/question.dart';

abstract class QuestionEvent {}

class OnPressedMoveQuestion extends QuestionEvent {
  int currentIndex;
  int quizId;
  OnPressedMoveQuestion(this.currentIndex, this.quizId);
}

class OnPressedAddQuestion extends QuestionEvent {
  Question question;
  int quizId;
  int userId;
  OnPressedAddQuestion(this.question, this.userId, this.quizId);
}