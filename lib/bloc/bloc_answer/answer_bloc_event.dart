import '../../model/question.dart';

abstract class AnswerEvent {}

class OnPressedSelectAnswer extends AnswerEvent {
  final int questionId;
  final int selectAnswer;
  final int totalQuestion;
  final int quizId;
  final Map<String,dynamic> question;
  OnPressedSelectAnswer(this.questionId, this.selectAnswer, this.totalQuestion,this.quizId, this.question);
}

class OnPressSubmitAnswer extends AnswerEvent {
  final int quizId;
  final int score;
  final int userId;
  final int? totalScore;
  OnPressSubmitAnswer(this.quizId, this.score, this.userId, this.totalScore);
}