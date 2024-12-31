import '../../model/quiz.dart';

abstract class FavoriteState {}

class FavoriteStateWithQuiz extends FavoriteState {
  final Quiz quiz;
  FavoriteStateWithQuiz(this.quiz);
}

class FavoriteAddSuccess extends FavoriteStateWithQuiz {
  String text;
  FavoriteAddSuccess(this.text, Quiz quiz) : super(quiz);
}

class FavoriteAddFailure extends FavoriteState {
  String text;
  FavoriteAddFailure(this.text);
}

class FavoriteLoading extends FavoriteState {
  bool isLoading;
  FavoriteLoading(this.isLoading);
}

class FavoriteRemoveSuccess extends FavoriteStateWithQuiz {
  String text;
  FavoriteRemoveSuccess(this.text, Quiz quiz) : super(quiz);
}

class FavoriteRemoveFailure extends FavoriteState {
  String text;
  FavoriteRemoveFailure(this.text);
}

class Initial extends FavoriteState {}
