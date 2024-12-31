import '../../model/question.dart';

abstract class QuestionState {}

class QuestionMoveSuccess extends QuestionState {
  int currentPage;
  List<Map<String,dynamic>> questionList;
  QuestionMoveSuccess(this.currentPage, this.questionList);
}

class QuestionMoveFailure extends QuestionState {
  String text;
  int currentPage;
  List<Map<String,dynamic>> questionList;
  QuestionMoveFailure(this.text, this.currentPage, this.questionList);
}

class QuestionAddSuccess extends QuestionState {
  String text;
  List<Map<String,dynamic>> questionList;
  QuestionAddSuccess(this.text, this.questionList);
}

class QuestionAddFailure extends QuestionState {
  String text;
  List<Map<String,dynamic>> questionList;
  QuestionAddFailure(this.text, this.questionList);
}

class Initial extends QuestionState {}