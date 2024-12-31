import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_send_email/email_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_send_email/email_bloc_state.dart';
import 'package:flutter_quiz_app/components/appbar/appbar_field.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_email_field.dart';
import 'package:flutter_quiz_app/components/input_field/label_text.dart';
import 'package:flutter_quiz_app/constant/label_str.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import '../../../components/snackbar/scaffold_snackbar_msg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final textStyle = TextStyleCustom();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom.appbarBackNextBtn(textStyle, context, _emailController),
      backgroundColor: fullColor,
      body: BlocListener<EmailBloc, EmailState>(
        listener: (BuildContext context, EmailState state) {
          if (state is SendLoading) {
            ShowScaffoldMessenger.showScaffoldMessengerLoading(
                context, textStyle);
          } else if (state is SendSuccess) {
            ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
                context,state.success, textStyle);
            // _toggleButton(false);
          } else if (state is SendFail) {
            ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
                context, state.error, textStyle);
            // _toggleButton(true);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const BoxHeight(h: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        'Enter your email address',
                        style: textStyle.subTitleTextStyle(
                            FontWeight.w700, Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'We\'ll use this to sign you in or to create an account if you don\'t have one yet.',
                        style: textStyle.contentTextStyle(
                            FontWeight.w500, Colors.black),
                      )),
                    ],
                  ),
                ),
                const BoxHeight(h: 20),
                const LabelText(text: LABEL_EMAIL),
                const BoxHeight(h: 5),
                InputTextEmailFieldField(
                    controller: _emailController, hint: 'Enter your email',paddingRate: 15,),
                const BoxHeight(h: 20),
                ButtonField(
                    text: 'Continue',
                    function: () async {
                      if (_formKey.currentState!.validate()) {
                        await EmailBloc.sendEmail(
                            context, _emailController.text);
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
