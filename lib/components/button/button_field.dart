import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class ButtonField extends StatefulWidget {
  ButtonField({super.key, required this.text, required this.function});

  final String text;
  VoidCallback function;

  @override
  State<ButtonField> createState() => _ButtonFieldState();
}

class _ButtonFieldState extends State<ButtonField> {
  final textStyle = TextStyleCustom();
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      onPressed: widget.function,
      hoverElevation: 15,
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      color: primaryColor,
      child: Text(widget.text,textAlign: TextAlign.center,style: textStyle.contentTextStyle(FontWeight.w600, Colors.white),),
    );
  }
}
