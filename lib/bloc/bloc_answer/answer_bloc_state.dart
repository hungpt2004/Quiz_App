abstract class AnswerState {}

class AnswerSelectedSuccess extends AnswerState {
  String text;
  final Map<int,int> selectedAnswer;
  final int questionId;
  AnswerSelectedSuccess(this.text, this.selectedAnswer, this.questionId);
}

class AnswerSelectedFailure extends AnswerState {
  String text;
  AnswerSelectedFailure(this.text);
}

class AnswerSubmitSuccess extends AnswerState {
  String text;
  int score;
  AnswerSubmitSuccess(this.text, this.score);
}

class AnswerSubmitFailure extends AnswerState {
  String text;
  AnswerSubmitFailure(this.text);
}

class AnsweredAllQuestion extends AnswerState {
  String text;
  final Map<int,int> selectedAnswer;
  final int questionId;
  AnsweredAllQuestion(this.text, this.selectedAnswer, this.questionId);
}

class Initial extends AnswerState {}