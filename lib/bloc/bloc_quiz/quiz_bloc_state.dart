abstract class QuizState {}

class QuizAddSuccess extends QuizState {
  String success;
  QuizAddSuccess(this.success);
}

class QuizAddSubjectSuccess extends QuizState {
  String success;
  QuizAddSubjectSuccess(this.success);
}

class QuizAddSubjectFailure extends QuizState {
  String error;
  QuizAddSubjectFailure(this.error);
}

class QuizDeleteSuccess extends QuizState {
  String successMessage;
  QuizDeleteSuccess(this.successMessage);
}

class QuizDeleteFailure extends QuizState {
  String errorMessage;
  QuizDeleteFailure(this.errorMessage);
}

class QuizAddFailure extends QuizState {
  String error;
  QuizAddFailure(this.error);
}

class QuizLoading extends QuizState {
  bool isLoading;
  QuizLoading(this.isLoading);
}

class EnjoyQuizSuccess extends QuizState {
  int quizId;
  EnjoyQuizSuccess(this.quizId);
}

class PageChangedSuccess extends QuizState {
  final int currentPage;
  PageChangedSuccess({required this.currentPage});
}


class Initial extends QuizState {}
