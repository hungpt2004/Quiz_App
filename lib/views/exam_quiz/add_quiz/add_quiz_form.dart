import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_own_quiz/ownquiz_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc_state.dart';
import 'package:flutter_quiz_app/components/appbar/appbar_field.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/input_field/input_number_field.dart';
import 'package:flutter_quiz_app/components/input_field/input_select.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_field.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/model/quiz.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/user.dart';

class AddQuizForm extends StatefulWidget {
  const AddQuizForm({super.key});

  @override
  State<AddQuizForm> createState() => _AddQuizFormState();
}

class _AddQuizFormState extends State<AddQuizForm> {
  final textStyle = TextStyleCustom();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  int? _selectedSubjectId;
  int? _selectedTypeId;
  User? currentUser;
  String? url;
  XFile? imageFile;
  final picker = ImagePicker();

  // P I C K -- I M A G E
  Future<void> pickImage(bool isCamera) async {
    try {
      final imageFile = await picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 100);
      if (imageFile != null) {
        setState(() {
          url = imageFile.path;
        });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: SelectableText(e.toString()),
              ));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom.appbarBackBtn(textStyle, context),
      body: BlocListener<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizLoading) {
            ShowScaffoldMessenger.showScaffoldMessengerLoading(
                context, textStyle);
          } else if (state is QuizAddSuccess) {
            ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
                context, state.success, textStyle);
          } else if (state is QuizAddFailure) {
            ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
                context, state.error, textStyle);
          }
        },
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is LoginSuccess || state is UpdateAvatarSuccess) {
                    currentUser = state is LoginSuccess
                        ? state.user
                        : (state as UpdateAvatarSuccess).user;
                    return _body(currentUser!);
                  }
                  else if (state is UpdateNameSuccess) {
                    currentUser = state.user;
                    return _body(currentUser!);
                  }
                  else if (state is UpdateDOBSuccess) {
                    currentUser = state.user;
                    return _body(currentUser!);
                  }
                  else if (state is ResetPasswordSuccess) {
                    currentUser = state.user;
                    return _body(currentUser!);
                  }
                  return const Center(child: Text('Need to Login/Register'),);
                },
              )),
        ),
      ),
    );
  }

  Widget _body(User user){
    return Column(
      children: [
        const BoxHeight(h: 10),
        textStyle.titleRow(textStyle, 'Add Quiz'),
        const BoxHeight(h: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Try to contribute to this app by your knowledge and exepiriences !',
            style: textStyle.contentTextStyle(
                FontWeight.w500, Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '* You can upload image for quiz from Gallery or by Camera ',
            style: textStyle.contentTextStyle(
                FontWeight.w500, Colors.deepPurple),
          ),
        ),
        const BoxHeight(h: 20),
        InputTextField(
            controller: _titleController,
            textInputAction: TextInputAction.next,
            hint: 'Enter title',
            paddingRate: 10),
        const BoxHeight(h: 5),
        InputTextField(
            controller: _descriptionController,
            textInputAction: TextInputAction.next,
            hint: 'Enter description',
            paddingRate: 10),
        const BoxHeight(h: 5),
        InputNumberField(
            controller: _priceController,
            textInputAction: TextInputAction.next,
            hint: 'Enter price',
            paddingRate: 10),
        const BoxHeight(h: 5),
        FutureBuilder(
          future: DBHelper.instance
              .getSubjectById(_selectedSubjectId ?? 1),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: primaryColor,
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Error when fetch data');
            }
            return InputSelectField(
                textInputAction: TextInputAction.next,
                hint: snapshot.data!.name,
                paddingRate: 10);
          },
        ),
        const BoxHeight(h: 5),
        FutureBuilder(
          future: DBHelper.instance.getAllSubjects(),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: primaryColor,
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Error when fetch data');
            }
            return Container(
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: DropdownButton<int>(
                  elevation: 15,
                  iconSize: 30,
                  style: textStyle.contentTextStyle(
                      FontWeight.w500, Colors.white),
                  menuWidth: 200,
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
                      child: Text(option['name']),
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
        BoxHeight(h: 5),
        // T Y P E
        FutureBuilder(
          future: DBHelper.instance
              .getTypeById(_selectedTypeId ?? 1),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: primaryColor,
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Error when fetch data');
            }
            return InputSelectField(
                textInputAction: TextInputAction.done,
                hint: snapshot.data!.name,
                paddingRate: 10);
          },
        ),
        const BoxHeight(h: 5),
        FutureBuilder(
          future: DBHelper.instance.getAllType(),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: primaryColor,
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Error when fetch data');
            }
            return Container(
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: DropdownButton<int>(
                  elevation: 15,
                  iconSize: 30,
                  style: textStyle.contentTextStyle(
                      FontWeight.w500, Colors.white),
                  hint: Text(
                    'Select a type',
                    style: textStyle.contentTextStyle(
                        FontWeight.w500, Colors.black),
                  ),
                  dropdownColor: secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                  items: snapshot.data!.map((option) {
                    return DropdownMenuItem<int>(
                      value: option['id'],
                      child: Text(option['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTypeId = value;
                    });
                  },
                ),
              ),
            );
          },
        ),
        const BoxHeight(h: 5),
        if (url != null)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                    width: 1)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                File(url!),
                fit: BoxFit.cover,
              ),
            ),
          ),

        const BoxHeight(h: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonField(
                text: 'Upload by Camera',
                function: () {
                  pickImage(true);
                }),
            const BoxWidth(w: 10),
            ButtonField(
                text: 'Upload from Gallery',
                function: () {
                  pickImage(false);
                })
          ],
        ),
        Center(
          child: ButtonField(
              text: 'Add New Quiz',
              function: () async {
                if (_formKey.currentState!.validate()) {
                  await QuizBloc.quiz(
                      context,
                      Quiz(
                          description:
                          _descriptionController.text,
                          title: _titleController.text,
                          userId: user.id!,
                          subjectId: _selectedSubjectId!,
                          price:
                          int.parse(_priceController.text),
                          typeId: _selectedTypeId!,
                          createdAt: DateTime.now(),
                          url: url!),
                      user.id!);
                }
              }),
        )
      ],
    );
  }

}
