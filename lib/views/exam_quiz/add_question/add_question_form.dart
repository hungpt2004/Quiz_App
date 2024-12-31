import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_question/question_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_question/question_bloc_state.dart';
import 'package:flutter_quiz_app/components/appbar/appbar_field.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_field.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/model/question.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

import '../../../components/box/box_height.dart';
import '../../../components/input_field/input_select.dart';
import '../../../model/user.dart';
import '../../../sql/sql_helper.dart';
import '../../../theme/color.dart';

class AddQuestionForm extends StatefulWidget {
  const AddQuestionForm({super.key});

  @override
  State<AddQuestionForm> createState() => _AddQuestionFormState();
}

class _AddQuestionFormState extends State<AddQuestionForm> {
  final textStyle = TextStyleCustom();
  final _contentController = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();
  final _answer3Controller = TextEditingController();
  final _answer4Controller = TextEditingController();
  final _correctAnswerController = TextEditingController();
  User? user = UserManager().currentUser;
  int? _selectedSubjectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCustom.appbarBackBtn(textStyle, context),
      body: BlocListener<QuestionBloc, QuestionState>(
        listener: (context, state) {
          if (state is QuestionAddSuccess) {
            ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
                context, state.text, textStyle);
          } else if (state is QuestionAddFailure) {
            print(state.text);
            ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
                context, state.text, textStyle);
          }
        },
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const BoxHeight(h: 10),
          textStyle.titleRow(textStyle, 'Add Question'),
          const BoxHeight(h: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Try to contribute to this app by your knowledge and exepiriences !',
              style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
            ),
          ),
          const BoxHeight(h: 10),
          FutureBuilder(
            future: DBHelper.instance.getQuizByUserId(user!.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: primaryColor,
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error when fetch data');
              }
              return Container(
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: DropdownButton<int>(
                    elevation: 15,
                    iconSize: 30,
                    style:
                        textStyle.contentTextStyle(FontWeight.w500, Colors.white),
                    menuWidth: 250,
                    menuMaxHeight: 200,
                    hint: Text(
                      'Select a subject',
                      style: textStyle.contentTextStyle(
                          FontWeight.w500, Colors.black),
                    ),
                    dropdownColor: secondaryColor,
                    borderRadius: BorderRadius.circular(15),
                    items: snapshot.data!.map((option) {
                      return DropdownMenuItem<int>(
                        value: option['id'],
                        child: Text(option['title']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubjectId = value;
                      });
                    },
                  ),
                ),
              );
            },
          ),
          const BoxHeight(h: 10),
          FutureBuilder(
            future: DBHelper.instance.getQuizById(_selectedSubjectId ?? 1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: primaryColor,
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error when fetch data');
              }
              return InputSelectField(
                  textInputAction: TextInputAction.next,
                  hint: snapshot.data!.title,
                  paddingRate: 10);
            },
          ),
          const BoxHeight(h: 10),
          InputTextField(
              controller: _contentController,
              textInputAction: TextInputAction.next,
              hint: 'Enter content question',
              paddingRate: 10),
          const BoxHeight(h: 10),
          InputTextField(
              controller: _answer1Controller,
              textInputAction: TextInputAction.next,
              hint: 'Enter answer 1',
              paddingRate: 10),
          const BoxHeight(h: 10),
          InputTextField(
              controller: _answer2Controller,
              textInputAction: TextInputAction.next,
              hint: 'Enter answer 2',
              paddingRate: 10),
          const BoxHeight(h: 10),
          InputTextField(
              controller: _answer3Controller,
              textInputAction: TextInputAction.next,
              hint: 'Enter answer 3',
              paddingRate: 10),
          const BoxHeight(h: 10),
          InputTextField(
              controller: _answer4Controller,
              textInputAction: TextInputAction.next,
              hint: 'Enter answer 4',
              paddingRate: 10),
          const BoxHeight(h: 10),
          InputTextField(
              controller: _correctAnswerController,
              textInputAction: TextInputAction.done,
              hint: 'Enter correct answer (index of question 1,2,3,4...)',
              paddingRate: 10),
          const BoxHeight(h: 10),
          ButtonField(
              text: 'Add question',
              function: () {
                QuestionBloc.addQuestion(
                    context,
                    Question(
                        content: _contentController.text,
                        answer1: _answer1Controller.text,
                        answer2: _answer2Controller.text,
                        answer3: _answer3Controller.text,
                        answer4: _answer4Controller.text,
                        correctAnswer: int.parse(_correctAnswerController.text),
                        quizId: _selectedSubjectId!),
                    _selectedSubjectId!,
                    user!.id!);
              })
        ],
      ),
    );
  }
}
