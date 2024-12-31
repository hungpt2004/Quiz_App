import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_state.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/button/social_button_field.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_field.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_password_field.dart';
import 'package:flutter_quiz_app/components/input_field/label_text.dart';
import 'package:flutter_quiz_app/constant/label_str.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:lottie/lottie.dart';

import '../../../components/snackbar/scaffold_snackbar_msg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textStyle = TextStyleCustom();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fullColor,
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is LoginLoading) {
            ShowScaffoldMessenger.showScaffoldMessengerLoading(
                context, textStyle);
          } else if (state is LoginSuccess) {
            ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
                context, "Login Successfully", textStyle);
            print('Name trong login screen ${state.user.name}');
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.pushNamed(context, '/');
            });
          } else if (state is LoginFailure) {
            ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
                context, state.error, textStyle);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  'Welcome to QuizzLiz !',
                  textAlign: TextAlign.center,
                  style:
                      textStyle.titleTextStyle(FontWeight.w600, Colors.black),
                ),

                //TEXT FIELD
                const BoxHeight(h: 20),
                const LabelText(text: LABEL_USERNAME),
                InputTextField(controller: _usernameController,textInputAction: TextInputAction.next, hint: 'Enter username',paddingRate: 30,),
                const BoxHeight(h: 10),
                const LabelText(text: LABEL_PASSWORD),
                InputTextPasswordField(controller: _passwordController,textInputAction: TextInputAction.done, hint: 'Enter password',paddingRate: 30,),

                //FORGOT PASSWORD
                const BoxHeight(h: 15),
                _forgotPassword(() {}),

                //BUTTON
                const BoxHeight(h: 15),
                ButtonField(
                    text: 'Login',
                    function: () async {
                      if (_formKey.currentState!.validate()) {
                        await AuthBloc.login(context, _usernameController.text,
                            _passwordController.text);
                      }
                    }),

                //DIVIDER
                const BoxHeight(h: 15),
                _divider(),

                //ICON

                //GOOGLE LOGIN
                const BoxHeight(h: 30),
                SocialButtonField(text: 'Sign in with Google', function: () {}),

                //SIGN UP GO TO
                const BoxHeight(h: 30),
                _signUpGoTo()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _forgotPassword(VoidCallback function) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context,'/forgot'),
            child: Text(
              'Forgot Password',
              style: textStyle.contentTextStyle(FontWeight.w500, primaryColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 1,
      color: Colors.grey.withOpacity(0.2),
    );
  }

  Widget _signUpGoTo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: textStyle.contentTextStyle(FontWeight.w400, Colors.black),
        ),
        InkWell(
          onTap: () => Navigator.pushNamed(context,'/register'),
          child: Text('Sign Up',
              style: textStyle.contentTextStyle(FontWeight.w400, primaryColor)),
        )
      ],
    );
  }
}
