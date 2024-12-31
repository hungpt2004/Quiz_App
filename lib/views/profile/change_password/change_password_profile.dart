import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_password_field.dart';
import 'package:flutter_quiz_app/components/input_field/label_text.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import '../../../bloc/bloc_auth/auth_bloc.dart';
import '../../../bloc/bloc_auth/auth_bloc_state.dart';
import '../../../components/box/box_height.dart';
import '../../../components/button/button_field.dart';
import '../../../components/input_field/input_text_field.dart';
import '../../../components/snackbar/scaffold_snackbar_msg.dart';
import '../../../model/user.dart';
import '../../../theme/color.dart';

class ChangePasswordProfile extends StatefulWidget {
  const ChangePasswordProfile({super.key});

  @override
  State<ChangePasswordProfile> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordProfile> {
  final textStyle = TextStyleCustom();
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmController = TextEditingController();
  User? currentUser;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  _refresh() {
    _passController.clear();
    _confirmController.clear();
    _newPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: fullColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      )),
                  Text(
                    'Back',
                    style: textStyle.subTitleTextStyle(
                        FontWeight.bold, Colors.white),
                  ),
                ],
              ),
            ],
          ),
          leadingWidth: double.infinity,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if(state is LoginSuccess) {
              currentUser = state.user;
              return _body(currentUser!);
            } else if (state is UpdateNameSuccess) {
              currentUser = state.user;
              return _body(currentUser!);
            }
            else if (state is UpdateDOBSuccess) {
              print('STATE HIEN TAI $state');
              currentUser = state.user;
              return _body(currentUser!);
            }
            else if (state is ResetPasswordSuccess) {
              currentUser = state.user;
              return _body(currentUser!);
            } else if (state is ResetPasswordFailure) {
              currentUser = state.user;
              return _body(currentUser!);
            }
            return Center(child: ButtonField(text: 'Need to Login/Register', function: (){}),);
          },
        ));
  }

  Widget _body(User user){
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          ShowScaffoldMessenger.showScaffoldMessengerLoading(
              context, textStyle);
        } else if (state is ResetPasswordSuccess) {
          ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
              context, state.success, textStyle);
        } else if (state is ResetPasswordFailure) {
          ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
              context, state.error, textStyle);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            const BoxHeight(h: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Choose a new password',
                        style: textStyle.subTitleTextStyle(
                            FontWeight.w700, Colors.black),
                      ),
                    ],
                  ),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'Use a minimum of 10 characters, including uppercase letters, lowercase letters, and numbers',
                        style: textStyle.contentTextStyle(
                            FontWeight.w500, Colors.black),
                      )),
                ],
              ),
            ),
            const BoxHeight(h: 20),
            Form(
              key: _formKey,
              child: Column(children: [
                const LabelText(text: 'Old password'),
                const BoxHeight(h: 5),
                InputTextPasswordField(
                  controller: _passController,
                  textInputAction: TextInputAction.next,
                  hint: 'Enter a password',
                  paddingRate: 15,
                ),
                const BoxHeight(h: 10),
                const LabelText(text: 'New password'),
                const BoxHeight(h: 5),
                InputTextPasswordField(
                  controller: _newPasswordController,
                  textInputAction: TextInputAction.next,
                  hint: 'Enter a password',
                  paddingRate: 15,
                ),
                const BoxHeight(h: 10),
                const LabelText(text: 'Confirm password'),
                const BoxHeight(h: 5),
                InputTextPasswordField(
                  controller: _confirmController,
                  textInputAction: TextInputAction.done,
                  hint: 'Confirm your password',
                  paddingRate: 15,
                ),
                const BoxHeight(h: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonField(
                        text: 'Change password',
                        function: () async {
                          if (_formKey.currentState!.validate()) {
                            //Check password
                            if ((_passController.text == user!.password) && (_newPasswordController.text == _confirmController.text)) {
                              await AuthBloc.changePassword(context, user!.email, _newPasswordController.text);
                              return;
                            } else if (_passController.text != user!.password) {
                              print(_passController.text);
                              print(user!.password);
                              ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(context, 'Old password are wrong!', textStyle);
                              return;
                            } else if (_newPasswordController.text != _confirmController.text) {
                              ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(context, 'Password and Confirm are wrong !', textStyle);
                              return;
                            }
                            // _refresh();
                          }
                        })
                  ],
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

}
