import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_question/question_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_question/question_bloc_state.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';

import '../../model/question.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(Initial()) {
    on<OnPressedMoveQuestion>(_onChangePage);
    on<OnPressedAddQuestion>(_onAddQuestion);
  }

  void _onChangePage(OnPressedMoveQuestion event, Emitter<QuestionState> emit) async {
    final questionList = await DBHelper.instance.getQuestionListByQuizId(event.quizId);

    if (event.currentIndex < 0 || event.currentIndex >= questionList.length) {
      // Phát trạng thái thất bại kèm thông tin về trạng thái hiện tại
      emit(QuestionMoveFailure(
        'Invalid page index.',
        event.currentIndex < 0 ? 0 : questionList.length - 1, // Giữ chỉ số hợp lệ
        questionList,
      ));
    } else {
      emit(QuestionMoveSuccess(event.currentIndex, questionList));
    }
  }


  void _onAddQuestion(OnPressedAddQuestion event, Emitter<QuestionState> emit) async {
    try {
      await DBHelper.instance.addNewQuestion(event.question, event.quizId, event.userId);
      final questionList = await DBHelper.instance.getQuestionListByQuizId(event.quizId);
      emit(QuestionAddSuccess('Add successfully', questionList));
    } catch (e) {
      final questionList = await DBHelper.instance.getQuestionListByQuizId(event.quizId);
      emit(QuestionAddFailure(e.toString(), questionList));
    }
  }

  static Future<void> changePage(BuildContext context, int index, int quizId) async {
    context.read<QuestionBloc>().add(OnPressedMoveQuestion(index, quizId));
  }

  static Future<void> addQuestion(BuildContext context, Question question, int quizId, int userId) async {
    context.read<QuestionBloc>().add(OnPressedAddQuestion(question,quizId,userId));
  }

}