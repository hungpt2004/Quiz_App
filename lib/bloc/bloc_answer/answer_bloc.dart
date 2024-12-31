import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_answer/answer_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_answer/answer_bloc_state.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';

import '../../model/question.dart';

class AnswerBloc extends Bloc<AnswerEvent, AnswerState> {

  AnswerBloc() : super(Initial()){
    on<OnPressedSelectAnswer>(_onSelectAnswer);
    on<OnPressSubmitAnswer>(_onSubmitQuiz);
  }

  static int currentQuestionIndex = 0;
  static int score = 0;
  static Map<int, int> selectedAnswered = {};
  static Map<int, int> correctAnswerCount = {};

  void _onSelectAnswer(OnPressedSelectAnswer event, Emitter<AnswerState> emit) async {
    try {
      //Tinh diem dua tren cau tra loi
      print('Cau hoi hien tai: $currentQuestionIndex');
      print('Cau tra loi dung: ${event.question['correct_answer']}');
      score += calculateScore(event.selectAnswer, event.question['correct_answer'],event.questionId, event.quizId);

      selectedAnswered[event.questionId] = event.selectAnswer;
      print('CURRENT INDEX QUESTION : ${currentQuestionIndex}');
      print('TONG SO CAU TRA LOI DUNG ${correctAnswerCount[event.quizId]}');
      //Kiem tra het cau hoi hay chua
      if(currentQuestionIndex > event.totalQuestion){
        currentQuestionIndex = 0; // Reset lại chỉ số câu hỏi
        score = 0; // Reset lại điểm
        selectedAnswered.clear(); // Xóa danh sách câu trả lời đã chọn nếu cần
        correctAnswerCount[event.quizId] = 0;
        emit(AnsweredAllQuestion('All question answered. You can now submit your answers',selectedAnswered,event.questionId));
      } else {
        emit(AnswerSelectedSuccess('Answer selected successfully',selectedAnswered,event.questionId));
      }
    } catch (e) {
      emit(AnswerSelectedFailure(e.toString()));
    }
  }

  void _onSubmitQuiz(OnPressSubmitAnswer event, Emitter<AnswerState> emit) async {
    try {
      await DBHelper.instance.updateCompleteQuiz(score, event.userId, event.quizId, DateTime.now());
      await DBHelper.instance.updateUserTotalScore(event.totalScore!, event.userId);
      emit(AnswerSubmitSuccess('Submit success', score));
    } catch (e) {
      emit(AnswerSubmitFailure(e.toString()));
    }
  }

  int calculateScore(int selectedAnswer, int correctAnswer, int questionId, int quizId) {
    int previousAnswer = selectedAnswered[questionId] ?? -1; // Lấy đáp án cũ (-1 nếu chưa có)
    int deltaScore = 0;

    // Nếu có đáp án cũ
    if (previousAnswer != -1) {
      if (previousAnswer == correctAnswer) {
        deltaScore -= 20;
        correctAnswerCount[quizId] = (correctAnswerCount[quizId] ?? 0) - 1;
        currentQuestionIndex--;
      }
    }

    // Cộng điểm nếu đáp án mới đúng
    if (selectedAnswer == correctAnswer) {
      deltaScore += 20;
      correctAnswerCount[quizId] = (correctAnswerCount[quizId] ?? 0) + 1;
      currentQuestionIndex++;
    }

    return deltaScore;
  }

  static Future<void> selectAnswer(BuildContext context, int selectedAnswer, int questionId, int totalQuestion,int quizId, Map<String,dynamic> question) async {
    context.read<AnswerBloc>().add(OnPressedSelectAnswer(questionId, selectedAnswer, totalQuestion,quizId, question));
  }

  static Future<void> submitAnswer(BuildContext context, int userId, int quizId, int score, int totalScore) async {
    context.read<AnswerBloc>().add(OnPressSubmitAnswer(userId,quizId,score, totalScore));
  }

}