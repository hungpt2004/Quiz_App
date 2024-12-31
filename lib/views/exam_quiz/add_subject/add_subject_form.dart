import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc_state.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_field.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/model/subject.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

import '../../../bloc/bloc_quiz/quiz_bloc.dart';
import '../../../components/appbar/appbar_field.dart';
import '../../../components/box/box_height.dart';

class AddSubjectForm extends StatefulWidget {
  const AddSubjectForm({super.key});

  @override
  State<AddSubjectForm> createState() => _AddSubjectFormState();
}

class _AddSubjectFormState extends State<AddSubjectForm> {
  final _nameController = TextEditingController();
  final textStyle = TextStyleCustom();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom.appbarBackBtn(textStyle, context),
      body: SingleChildScrollView(
        child: BlocListener<QuizBloc, QuizState>(
          listener: (context, state) {
            if(state is QuizAddSubjectSuccess) {
              ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(context, state.success, textStyle);
            } else if (state is QuizAddSubjectFailure) {
              ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(context, state.error, textStyle);
            }
          },
          child: Column(
            children: [
              const BoxHeight(h: 10),
              textStyle.titleRow(textStyle, 'Add Subject'),
              const BoxHeight(h: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Try to contribute to this app by your knowledge and exepiriences !',
                  style: textStyle.contentTextStyle(
                      FontWeight.w500, Colors.black),
                ),
              ),
              const BoxHeight(h: 10),
              InputTextField(controller: _nameController, textInputAction: TextInputAction.done, hint: 'Enter subject name', paddingRate: 10),
              BoxHeight(h: 10),
              ButtonField(text: 'Add new subject', function: (){
                QuizBloc.addSubject(context, Subject(name: _nameController.text));
              })
            ],
          ),
        ),
      ),
    );
  }
}
