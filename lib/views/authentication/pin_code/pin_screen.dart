import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_pin/pin_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_pin/pin_bloc_state.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class FormPinWidget extends StatefulWidget {
  const FormPinWidget({super.key, required this.emailUser});

  final String emailUser;

  @override
  State<FormPinWidget> createState() => _FormPinWidgetState();
}

class _FormPinWidgetState extends State<FormPinWidget> {
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String num1;
  late String num2;
  late String num3;
  late String num4;
  late String num5;
  late String num6;
  String pin = '';

  @override
  void initState() {
    num1 = '';
    num2 = '';
    num3 = '';
    num4 = '';
    num5 = '';
    num6 = '';
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyleCustom();
    return Scaffold(
      backgroundColor: fullColor,
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
                  style: textStyle.subTitleTextStyle(FontWeight.bold, Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Next',
                  style: textStyle.subTitleTextStyle(
                      FontWeight.bold, Colors.white),
                ),
                IconButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/password',arguments: widget.emailUser);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    )),
              ],
            )
          ],
        ),
        leadingWidth: double.infinity,
      ),
      body: BlocListener<PinBloc, PinState>(
        listener: (context, state) {
          if(state is PinLoading){
            ShowScaffoldMessenger.showScaffoldMessengerLoading(context, textStyle);
          } else if (state is PinSuccess) {
            ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(context, state.success, textStyle);
          } else if (state is PinFail) {
            ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(context, state.error, textStyle);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const BoxHeight(h: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('Enter your email address',style: textStyle.subTitleTextStyle(FontWeight.w700, Colors.black),),
                      ],
                    ),
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(child: Text('We send a reset link to ${widget.emailUser} enter 6 digit code that mentioned in the email',style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),)),
                  ],
                ),
              ),
              const BoxHeight(h: 20),
              Form(
                key: _formKey,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      inputField(context, 1,textStyle),
                      inputField(context, 2,textStyle),
                      inputField(context, 3,textStyle),
                      inputField(context, 4,textStyle),
                      inputField(context, 5,textStyle),
                      inputField(context, 6,textStyle),
                    ],
                  ),
                  const BoxHeight(h: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonField(text: 'Verify Code', function: () async {
                        if(_formKey.currentState!.validate()){
                          print("PIN O DAY $pin");
                          //MAKE STRING 6 DIGIT
                          pin = '$num1$num2$num3$num4$num5$num6';
                          await PinBloc.getPin(context, num1, num2, num3, num4, num5, num6);
                          //VERIFY
                          await PinBloc.sendPin(context, pin, widget.emailUser);
                          Future.delayed(Duration(seconds: 2),(){Navigator.pushNamed(context, '/pass');});
                        }
                      })
                    ],
                  )
                ]),
              ),
            ],
          ),
        ),
      )
    );
  }



  // INPUT
  Widget inputField(BuildContext context, int index, TextStyleCustom textStyle) {
    return SizedBox(
      height: 60,
      width: 55,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: primaryColor, // Màu khi trường đang được chọn
              width: 2, // Có thể điều chỉnh độ dày
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: primaryColor, // Màu khi trường được kích hoạt
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red, // Màu cho trạng thái lỗi
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent, // Màu khi trường lỗi và được chọn
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
            setState(() {
              if (index == 1) {
                num1 = value;
              }
              if (index == 2) {
                num2 = value;
              }
              if (index == 3) {
                num3 = value;
              }
              if (index == 4) {
                num4 = value;
              }
              if (index == 5) {
                num5 = value;
              }
              if (index == 6) {
                num6 = value;
              }
            });
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Empty!";
          } else {
            return null;
          }
        },
        style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}