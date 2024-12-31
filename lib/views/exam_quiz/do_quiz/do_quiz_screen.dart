import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_answer/answer_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_answer/answer_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_question/question_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_question/question_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc_state.dart';
import 'package:flutter_quiz_app/components/appbar/appbar_field.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../bloc/bloc_auth/auth_bloc.dart';
import '../../../model/user.dart';

class DoQuizScreen extends StatefulWidget {
  const DoQuizScreen({super.key, required this.quizId});

  final int quizId;

  @override
  State<DoQuizScreen> createState() => _DoQuizScreenState();
}

class _DoQuizScreenState extends State<DoQuizScreen> {
  final _pageController = PageController();
  final textStyle = TextStyleCustom();
  User? user = UserManager().currentUser;


  _submit() async {
    await DBHelper.instance.updateCompleteQuiz(AnswerBloc.score, user!.id!, widget.quizId, DateTime.now());
    await DBHelper.instance.updateUserTotalScore((user!.totalScore! + AnswerBloc.score), user!.id!);
    await DBHelper.instance.updateRankByScore(AnswerBloc.score, user!.id!);
    await DBHelper.instance.updateStatusDid(widget.quizId, user!.id!);
    await DBHelper.instance.updateNumberCorrectAnswer(AnswerBloc.correctAnswerCount[widget.quizId]!, user!.id!, widget.quizId);
  }

  _alertComplete(int totalQuestion) {
    final correctAnswerCount = AnswerBloc.correctAnswerCount[widget.quizId] ?? 0;
    final percent = correctAnswerCount / totalQuestion;
    final percentString = (percent * 100).toStringAsFixed(2); // Chuyển thành chuỗi và giới hạn 2 chữ số thập phân
    final twoDigits = percentString.split('.')[0]; // Lấy phần nguyên (2 chữ số đầu)

    //Alert finish
    showGeneralDialog(
      //Nhan ra ngoai de dong
      barrierDismissible: true,
      barrierLabel: 'DIALOG',
      context: context,
      transitionDuration: const Duration(milliseconds: 300), // Thời gian hiệu ứng
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60), color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Positioned.fill(child: Lottie.asset('assets/animation/success.json',width: double.infinity)),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: CircularPercentIndicator(
                              animation: true,
                              curve: Curves.fastOutSlowIn,
                              animateToInitialPercent: true,
                              radius: 90,
                              lineWidth: 25,
                              percent: percent.clamp(0.0, 1.0),
                              progressBorderColor: Colors.deepPurpleAccent,
                              backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
                              progressColor: Colors.deepPurpleAccent,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text('$twoDigits%',style: textStyle.questionTextStyle(FontWeight.w500, Colors.black),),
                            ),
                          ),
                        ),
                        const BoxHeight(h: 10),
                        Material(color: fullColor,child: Text('Your answer : $correctAnswerCount / $totalQuestion',style: textStyle.questionTextStyle(FontWeight.w500, Colors.black),)),
                        const BoxHeight(h: 10),
                        if(correctAnswerCount < totalQuestion~/2)
                          Material(color: fullColor,child: Text('You need to practice more 😢',style: textStyle.questionTextStyle(FontWeight.w500, Colors.black),)),
                        if(correctAnswerCount > totalQuestion~/2)
                          Material(color: fullColor,child: Text('Just a little bit more 💪',style: textStyle.questionTextStyle(FontWeight.w500, Colors.black),)),
                        if(correctAnswerCount == totalQuestion)
                          Material(color: fullColor,child: Text('Congrats, keep pushing! 🙌💥',style: textStyle.questionTextStyle(FontWeight.w500, Colors.black),)),
                        if(correctAnswerCount == 1)
                          Material(color: fullColor,child: Text('Progress has been made! 💪✨',style: textStyle.questionTextStyle(FontWeight.w500, Colors.black),)),
                        const BoxHeight(h: 20),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
          child: child,
        );
      },
    );
    DBHelper.instance.updateCompleteQuizProgress(int.parse(twoDigits), user!.id!, widget.quizId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom.appbarBackBtn(textStyle, context),
        body: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is EnjoyQuizSuccess) {
              print('QUIZ ID : ${state.quizId}');
              return FutureBuilder(
                future: DBHelper.instance.getQuestionListByQuizId(state.quizId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('Error');
                  }
                  final questionList = snapshot.data!;
                  return Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: PageView.builder(
                            // physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (index) {
                              Future.delayed(const Duration(milliseconds: 50),
                                  () {
                                QuestionBloc.changePage(context, index, widget.quizId);
                              });
                            },
                            itemCount: questionList.length,
                            itemBuilder: (context, index) {
                              print('TONG SO QUESTION CUA LIST NAY : ${questionList.length}');
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: _bodyOfPageView(
                                    questionList[index], questionList.length),
                              );
                            }),
                      ),
                      _btn(questionList.length,)
                    ],
                  );
                },
              );
            }
            return const Center(child: Text('No question'));
          },
        ));
  }

  Widget _bodyOfPageView(Map<String, dynamic> question, int length) {
    return Column(
      children: [
        Card(
          color: fullColor,
          elevation: 10,
          child: Container(
            width: StyleSize(context).screenWidth,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          question['content'],
                          textAlign: TextAlign.center,
                          style: textStyle.questionTextStyle(
                              FontWeight.w700, Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _cardAnswer(question['answer1'], 1, question['id'], length,
                        question),
                    _cardAnswer(question['answer2'], 2, question['id'], length,
                        question),
                    _cardAnswer(question['answer3'], 3, question['id'], length,
                        question),
                    _cardAnswer(question['answer4'], 4, question['id'], length,
                        question),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardAnswer(String answer, int index, int questionId, int totalQuestion, Map<String, dynamic> question) {
    return BlocBuilder<AnswerBloc, AnswerState>(
      builder: (context, state) {
        bool isSelected = false;

        // Check if the answer is selected
        if (state is AnswerSelectedSuccess &&
            state.selectedAnswer.containsKey(questionId) &&
            state.selectedAnswer[questionId] == index) {
          isSelected = true;
        }

        if (state is AnsweredAllQuestion) {
          if (state.selectedAnswer.containsKey(questionId) &&
              state.selectedAnswer[questionId] == index) {
            isSelected = true; // Câu trả lời đã chọn vẫn sẽ được giữ
          }
        }


        print('State hien tai : $state');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RadioListTile<int>(
            dense: false,
            toggleable: false,
            value:
                index, // the value of the radio button (corresponds to the index of the answer)
            groupValue: isSelected
                ? index
                : null, // controls which radio button is selected
            onChanged:  (int? value) async {
              if (value != null) {
                // Gọi phương thức chọn câu trả lời nếu câu trả lời chưa được hoàn thành
                await AnswerBloc.selectAnswer(context, value, questionId, totalQuestion,question['quiz_id'],question);
                // print('Answer selected: $value');
              }
            },
            title: Text(
              answer,
              style: textStyle.contentTextStyle(
                  FontWeight.w600, isSelected ? primaryColor : Colors.black),
            ),
            tileColor: isSelected
                ? primaryColor
                : Colors.white, // sets the background color when selected
            activeColor: isSelected
                ? primaryColor
                : Colors.black, // sets the color when active
            selected: isSelected, // indicates whether the answer is selected
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        );
      },
    );
  }

  Widget _btn(int length) {
    return BlocBuilder<QuestionBloc, QuestionState>(
      builder: (context, state) {
        int currentPage = 0;
        if (state is QuestionMoveSuccess) {
          print('Page trong bloc : ${state.currentPage}');
          currentPage = state.currentPage;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (currentPage > 0)
                ButtonField(
                  text: 'Back',
                  function: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              if (currentPage == length - 1) // Only show 'Submit' button on the last page
                ButtonField(
                  text: 'Submit',
                  function: () async {
                    await _submit();
                    await _alertComplete(length);
                    print('DA HOAN THANH');
                    //reset
                    // go to success certificate
                  },
                ),
              if (currentPage < length - 1)
                ButtonField(
                  text: 'Next',
                  function: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
            ],
          );
        } else if (state is QuestionMoveFailure) {
          currentPage = state.currentPage;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (currentPage > 0)
                ButtonField(
                  text: 'Back',
                  function: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              if (currentPage == length - 1) // Only show 'Submit' button on the last page
                ButtonField(
                  text: 'Submit',
                  function: () async {
                    await _submit();
                    await _alertComplete(length);
                    print('DA HOAN THANH');
                    //reset
                    // go to success certificate
                  },
                ),
              if (currentPage < length - 1)
                ButtonField(
                  text: 'Next',
                  function: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
            ],
          );
        }
        return Container();
      },
    );
  }

}
