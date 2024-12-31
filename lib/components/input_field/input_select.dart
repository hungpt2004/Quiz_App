import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class InputSelectField extends StatefulWidget {
  InputSelectField({super.key,this.controller,required this.textInputAction, required this.hint, this.label, required this.paddingRate, this.function});

  TextEditingController? controller;
  TextInputAction textInputAction;
  final String hint;
  String? label;
  double paddingRate;
  VoidCallback? function;

  @override
  State<InputSelectField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputSelectField> {
  final textStyle = TextStyleCustom();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingRate),
      child: TextFormField(
        controller: widget.controller,
        readOnly: true,
        maxLines: 1,
        style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: widget.hint,
          hintStyle: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
          suffixIcon: IconButton(onPressed: widget.function, icon: Icon(Icons.keyboard_arrow_right_rounded)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }
}
