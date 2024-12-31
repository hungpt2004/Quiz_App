import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc_state.dart';
import 'package:flutter_quiz_app/model/completed_quiz.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';

import '../../model/quiz.dart';
import '../../model/subject.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(Initial()){
    on<OnPressedAddQuiz>(_onAddQuiz);
    on<OnPressedRemoveQuiz>(_onRemoveQuiz);
    on<OnPressEnjoyQuiz>(_onJoinQuiz);
    on<OnPressChangedPage>(_onChangePage);
    on<OnPressedAddSubject>(_onAddSubject);
  }

  void _onAddQuiz(OnPressedAddQuiz event, Emitter<QuizState> emit) async {
    try {
      emit(QuizLoading(true));
      await DBHelper.instance.addNewQuiz(event.quiz, event.userId);
      emit(QuizAddSuccess('Add new quiz successfully'));
    } catch (e) {
      emit(QuizAddFailure(e.toString()));
      emit(QuizLoading(false));
    }
  }

  void _onRemoveQuiz(OnPressedRemoveQuiz event, Emitter<QuizState> emit) async {
    try {
      emit(QuizLoading(true));
      await DBHelper.instance.deleteQuizById(event.id);
      emit(QuizDeleteSuccess('Remove Quiz Success'));
    } catch (e) {
      emit(QuizDeleteFailure(e.toString()));
      emit(QuizLoading(false));
    }
  }

  void _onJoinQuiz(OnPressEnjoyQuiz event, Emitter<QuizState> emit) async {
     final completeList = await DBHelper.instance.getAllCompleteQuizByUserId(event.userId);
     print(completeList.toString());
     if(completeList == null) {
       return;
     } else {
       bool check = completeList.any((items) => items['quiz_id'] == event.quizId);
       //neu chua ton tai
       //nhung phai mua => tao nhung khong tao new paidAt
       if(!check){
         await DBHelper.instance.createNewCompleteQuiz(CompletedQuiz(userId: event.userId, quizId: event.quizId, paidAt: DateTime.now(), progress: 0), event.userId);
         print(CompletedQuiz(userId: event.userId, quizId: event.quizId, paidAt: DateTime.now(), progress: 0).toString());
         emit(EnjoyQuizSuccess(event.quizId));
       } else {
         emit(EnjoyQuizSuccess(event.quizId));
       }
     }
  }


  void _onAddSubject(OnPressedAddSubject event, Emitter<QuizState> emit) async {
    try {
      await DBHelper.instance.addNewSubject(event.subject);
      emit(QuizAddSubjectSuccess('Add new subject successfully'));
    } catch (e) {
      emit(QuizAddSubjectFailure(e.toString()));
    }
  }

  void _onChangePage(OnPressChangedPage event, Emitter<QuizState> emit) async {
    print('Page trong BLOC : ${event.currentPage}');
    emit(PageChangedSuccess(currentPage: event.currentPage));
  }


  static Future<void> quiz(BuildContext context, Quiz quiz, int userId) async {
    context.read<QuizBloc>().add(OnPressedAddQuiz(quiz: quiz, userId: userId));
  }

  static Future<void> removeQuiz(BuildContext context, int quizId) async {
    context.read<QuizBloc>().add(OnPressedRemoveQuiz(id: quizId));
  }

  static Future<void> enjoyQuiz(BuildContext context, int quizId, int userId) async {
    context.read<QuizBloc>().add(OnPressEnjoyQuiz(quizId: quizId, userId: userId));
  }

  static Future<void> changePage(BuildContext context, int currentPage) async {
    context.read<QuizBloc>().add(OnPressChangedPage(currentPage));
  }

  static Future<void> addSubject(BuildContext context, Subject subject) async {
    context.read<QuizBloc>().add(OnPressedAddSubject(subject));
  }

}