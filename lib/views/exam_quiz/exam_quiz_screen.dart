import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_own_quiz/ownquiz_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_own_quiz/ownquiz_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc_state.dart';
import 'package:flutter_quiz_app/components/appbar/custom_progressbar.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/button/button_icon.dart';
import 'package:flutter_quiz_app/components/snackbar/not_yet_noti.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/network_image.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../model/quiz.dart';
import '../../model/user.dart';

class ExamQuizScreen extends StatefulWidget {
  const ExamQuizScreen({super.key});

  @override
  State<ExamQuizScreen> createState() => _ExamQuizScreenState();
}

class _ExamQuizScreenState extends State<ExamQuizScreen> {
  final textStyle = TextStyleCustom();
  final networkImage = NetworkImageWidget();
  User? user = UserManager().currentUser;


  @override
  void initState() {
    print('TEN USER HIEN TAI ${user!.name}');
    OwnQuizBloc.loadingQuiz(context, user!.id!);
    super.initState();
  }

  _showModalSheetDelete(Map<String, dynamic> quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Delete',
          textAlign: TextAlign.center,
          style: textStyle.subTitleTextStyle(FontWeight.w700, Colors.black),
        ),
        content: Text(
          'Are you sure to delete Quiz ${quiz['id']}',
          textAlign: TextAlign.center,
          style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
        ),
        alignment: Alignment.center,
        elevation: 15,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonField(
                  text: 'Cancel',
                  function: () {
                    Navigator.pop(context);
                  }),
              ButtonField(
                  text: 'Delete',
                  function: () async {
                    await DBHelper.instance.deleteQuizById(quiz['id']);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.pop(context);
                    });
                  })
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: fullColor, body: _body(textStyle));
  }

  Widget _body(TextStyleCustom textStyle) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const BoxHeight(h: 50),

            // A D D -- Q U I Z
            _addQuizForm(),

            // P R O G R E S S  -- Q U I Z
            const BoxHeight(h: 30),
            textStyle.titleRow(textStyle, 'History Quiz'),
            _processingQuiz(networkImage),

            // M Y -- Q U I Z -- C R U D
            const BoxHeight(h: 30),
            textStyle.titleRow(textStyle, 'My Quiz'),
            _myQuiz(networkImage)
          ],
        ),
      ),
    );
  }

  Widget _addQuizForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonIcon(
            text: 'Question',
            icon: Icons.question_answer,
            function: () {
              Navigator.pushNamed(context, '/addQuestion');
            }),
        const BoxWidth(w: 10),
        ButtonIcon(
            text: 'Subject',
            icon: Icons.subject_outlined,
            function: () {
              Navigator.pushNamed(context, '/addSubject');
            }),
        const BoxWidth(w: 10),
        ButtonIcon(
            text: 'Quiz',
            icon: Icons.add_circle_outline,
            function: () {
              Navigator.pushNamed(context, '/addQuiz');
            })
      ],
    );
  }

  Widget _processingQuiz(NetworkImageWidget networkImage) {
    return BlocBuilder<OwnQuizBloc, OwnQuizState>(
      builder: (context, state) {
        if (state is OwnQuizLoadingSuccess) {
          final completeQuiz = state.completeQuiz;
          final quizList = state.quiz;
          final questionList = state.questionList;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: completeQuiz.length,
            itemBuilder: (context, index) {
              final completeQuizIndex = completeQuiz[index];
              final questions = questionList[index];
              return _cardCompleteQuiz(completeQuizIndex, quizList[index]!, networkImage, textStyle, questions.length);
            },
          );
        } else if (state is OwnQuizLoadingFailure) {
          return const Text('Failed to load quizzes');
        }
        return Container();
      },
    );
  }

  Widget _myQuiz(NetworkImageWidget networkImage) {
    return BlocBuilder<OwnQuizBloc, OwnQuizState>(
      builder: (context, quizState) {
        //Neu trang thai success => phat ra 1 list quiz
        if (quizState is OwnQuizLoadingSuccess) {
          final quizList = quizState.quizzes;
          return BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              //Load danh sach again
              OwnQuizBloc.loadingQuiz(context, user!.id!);
              return BlocListener<QuizBloc, QuizState>(
                child: quizList.isEmpty
                    ? const NotYetNoti(
                        label: 'Add',
                        image: 'assets/svg/add.svg',
                      )
                    : _listOwnQuiz(quizList),
                listener: (context, state) {
                  if (state is QuizDeleteSuccess) {
                    ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
                        context, state.successMessage, textStyle);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.pop(context);
                    });
                  } else if (state is QuizAddSuccess) {
                    ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
                        context, state.success, textStyle);
                  } else if (state is QuizAddFailure) {
                    ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
                        context, state.error, textStyle);
                  } else if (state is QuizDeleteFailure) {
                    ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
                        context, state.errorMessage, textStyle);
                    Navigator.pop(context);
                  }
                },
              );
            },
          );
        } else if (quizState is OwnQuizLoadingFailure) {
          return const Text('Failed to load quizzes');
        } else {
          return const CircularProgressIndicator(color: primaryColor);
        }
      },
    );
  }

  Widget _listOwnQuiz(List<Map<String, dynamic>> quizList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: quizList.length,
      itemBuilder: (context, index) {
        return _cardQuiz(quizList[index], networkImage, textStyle);
      },
    );
  }

  Widget _cardCompleteQuiz(
      Map<String, dynamic> completeIndex,
      Quiz quiz,
      NetworkImageWidget networkImage,
      TextStyleCustom textStyle,
      int totalQuestion) {
    return Slidable(
      key: ValueKey(quiz.id),
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            if(completeIndex['progress'] < 50){
              ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(context, 'You need to get 50% point to get key', textStyle);
              return;
            } else {
              Navigator.pushNamed(
                context,
                '/history',
                arguments: {
                  'quizId': quiz.id,
                  'quizUrl': quiz.url,
                },
              );
            }
          },
          padding: const EdgeInsets.all(0),
          foregroundColor: primaryColor,
          icon: Icons.manage_accounts_rounded,
          label: 'Result',
        ),
        SlidableAction(
          onPressed: (context) {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: quiz
              ,
            );
          },
          padding: const EdgeInsets.all(0),
          foregroundColor: primaryColor,
          icon: Icons.menu_open,
          label: 'Detail',
        ),
        SlidableAction(
          onPressed: (context) async {
            // Xử lý xóa
            await DBHelper.instance.deleteCompleteQuiz(user!.id!, quiz.id!);
            await DBHelper.instance.updateNumberCorrectAnswerReset(user!.id!, quiz.id!);
          },
          padding: const EdgeInsets.all(0),
          foregroundColor: primaryColor,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: Card(
        color: fullColor,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: SizedBox(
              width: 80,
              height: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: !quiz.url.toString().startsWith('/data/')
                    ? networkImage.networkImage(quiz.url)
                    : Image.file(
                        File(quiz.url),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style:
                      textStyle.contentTextStyle(FontWeight.w500, Colors.black),
                ),
                const BoxHeight(h: 2),
                Text(
                  'Paid at : ${textStyle.formatDateFromText(DateTime.parse(completeIndex['paid_at']))}',
                  style: textStyle.superSmallTextStyle(
                      FontWeight.w500, Colors.black),
                ),
                const BoxHeight(h: 5),

                //progressbar
                // //100% / question.length = r
                // //if choose answer => percentage += r
                // Text('Tong so cau hoi ${totalQuestion}'),
                // Text('Cau tra loi dung :${AnswerBloc.correctAnswerCount[quiz.id]}'),
                CustomProgressbar(
                    width: StyleSize(context).widthPercent(180),
                    height: 15,
                  progress: ((completeIndex['number_correct'] / totalQuestion).toDouble()),
                )
              ],
            ),
            trailing: const Icon(
              Icons.arrow_back_ios_new,
              color: primaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardQuiz(Map<String, dynamic> quiz, NetworkImageWidget networkImage,
      TextStyleCustom textStyle) {
    return Slidable(
      key: ValueKey(quiz['id']), // Khóa duy nhất để nhận dạng Slidable
      endActionPane: ActionPane(
        dragDismissible: true,
        motion: const ScrollMotion(), // Hiệu ứng cuộn
        children: [
          SlidableAction(
            onPressed: (context) async {
              // Xử lý xóa
              await _showModalSheetDelete(quiz);
            },
            padding: const EdgeInsets.all(0),
            foregroundColor: primaryColor,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) async {
              // Xử lý xóa
            },
            padding: const EdgeInsets.all(0),
            foregroundColor: primaryColor,
            icon: Icons.menu_open,
            label: 'Details',
          ),
        ],
      ),
      child: Card(
        color: fullColor,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: SizedBox(
              width: 75,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: !quiz['url'].toString().startsWith('/data/')
                    ? networkImage.networkImage(quiz['url'])
                    : Image.file(
                        File(quiz['url']),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz['title'],
                  style:
                      textStyle.contentTextStyle(FontWeight.w500, Colors.black),
                ),
                const BoxHeight(h: 2),
                Text(
                  'Create at : ${textStyle.formatDateFromText(DateTime.parse(quiz['created_at']))}',
                  style: textStyle.superSmallTextStyle(
                      FontWeight.w500, Colors.black),
                ),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_back_ios_new,
              color: primaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
