import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_state.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_email_field.dart';
import 'package:flutter_quiz_app/constant/label_str.dart';
import 'package:flutter_quiz_app/model/user.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:lottie/lottie.dart';

import '../../../bloc/bloc_auth/auth_bloc.dart';
import '../../../components/box/box_height.dart';
import '../../../components/input_field/input_text_field.dart';
import '../../../components/input_field/label_text.dart';
import '../../../components/snackbar/scaffold_snackbar_msg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final textStyle = TextStyleCustom();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fullColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            ShowScaffoldMessenger.showScaffoldMessengerLoading(
                context, textStyle);
          } else if (state is RegisterSuccess) {
            ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
                context, state.success, textStyle);
          } else if (state is RegisterFailure) {
            ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
                context, state.error, textStyle);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BoxHeight(h: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: ClipRRect(
                      child: Lottie.asset(
                          'assets/animation/animation_login.json')),
                ),

                //TEXT WELCOME
                Text(
                  'Sign up now to explore !',
                  textAlign: TextAlign.center,
                  style:
                  textStyle.titleTextStyle(FontWeight.w600, Colors.black),
                ),

                const BoxHeight(h: 10),
                const LabelText(text: LABEL_FULLNAME),
                InputTextField(
                    controller: _nameController,textInputAction: TextInputAction.next, hint: 'Enter fullname',paddingRate: 15,),
                const BoxHeight(h: 10),
                const LabelText(text: LABEL_USERNAME),
                InputTextField(
                    controller: _usernameController,textInputAction: TextInputAction.next, hint: 'Enter username',paddingRate: 15,),
                const BoxHeight(h: 10),
                const LabelText(text: LABEL_PASSWORD),
                InputTextField(
                    controller: _passwordController,textInputAction: TextInputAction.next, hint: 'Enter password',paddingRate: 15,),
                const BoxHeight(h: 10),
                const LabelText(text: LABEL_CONFIRM_PASSWORD),
                InputTextField(
                    controller: _confirmPassword,textInputAction: TextInputAction.done, hint: 'Enter confirm password',paddingRate: 15,),
                const BoxHeight(h: 10),
                const LabelText(text: LABEL_EMAIL),
                InputTextEmailFieldField(controller: _emailController, hint: 'Enter email',paddingRate: 30,),

                const BoxHeight(h: 30),

                ButtonField(text: 'Register', function: () async {
                  if(_formKey.currentState!.validate()){
                    if(_confirmPassword.text != _passwordController.text){
                      ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(context, 'Password and Confirm are wrong !', textStyle);
                      return;
                    }
                    await AuthBloc.register(context, User(name: _nameController.text, username: _usernameController.text, password: _passwordController.text, email: _emailController.text));
                    _refresh();
                  }
                }),

                const BoxHeight(h: 20),

                _signInGoTo(),

                const BoxHeight(h: 20),

                _policyRegister((){})

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _policyRegister(VoidCallback function){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('By signing up, you agree to our ',style: textStyle.smallTextStyle(FontWeight.w500, Colors.black),),
        InkWell(
          onTap: function,
          child: Text('[Terms and Conditions]',style: textStyle.smallTextStyle(FontWeight.w500, primaryColor)),
        ),
      ],
    );
  }

  Widget _signInGoTo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: textStyle.contentTextStyle(FontWeight.w400, Colors.black),
        ),
        InkWell(
          onTap: () => Navigator.pushNamed(context,'/login'),
          child: Text('Sign In',
              style: textStyle.contentTextStyle(FontWeight.w400, primaryColor)),
        )
      ],
    );
  }

  _refresh(){
    _nameController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _confirmPassword.clear();
    _emailController.clear();
  }

}
