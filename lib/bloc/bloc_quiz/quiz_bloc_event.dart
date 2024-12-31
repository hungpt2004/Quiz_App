import '../../model/quiz.dart';
import '../../model/subject.dart';

abstract class QuizEvent {}

class OnPressedAddQuiz extends QuizEvent {
  Quiz quiz;
  int userId;
  OnPressedAddQuiz({required this.quiz, required this.userId});
}

class OnPressedUpdateQuiz extends QuizEvent {

}

class OnPressedAddSubject extends QuizEvent {
  Subject subject;
  OnPressedAddSubject(this.subject);
}

class OnPressedRemoveQuiz extends QuizEvent {
  int id;
  OnPressedRemoveQuiz({required this.id});
}

class OnPressUpdateQuiz extends QuizEvent {
  Quiz quiz;
  OnPressUpdateQuiz({required this.quiz});
}

class OnPressEnjoyQuiz extends QuizEvent {
  int quizId;
  int userId;
  OnPressEnjoyQuiz({required this.quizId, required this.userId});
}

class OnPressChangedPage extends QuizEvent {
  final int currentPage;
  OnPressChangedPage(this.currentPage);
}