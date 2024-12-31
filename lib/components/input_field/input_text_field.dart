import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class InputTextField extends StatefulWidget {
  InputTextField({super.key,required this.controller,required this.textInputAction, required this.hint, this.label, required this.paddingRate});

  TextEditingController controller;
  TextInputAction textInputAction;
  final String hint;
  String? label;
  double paddingRate;

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  final textStyle = TextStyleCustom();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingRate),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if(value!.isEmpty){
            return 'Can\'t not empty';
          } else if (value.length < 2) {
            return 'Length must be > 2';
          } else {
            return null;
          }
        },
        maxLines: 1,
        style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: widget.hint,
          hintStyle: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
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
