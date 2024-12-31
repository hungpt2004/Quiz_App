import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class InputTextEmailFieldField extends StatefulWidget {
  InputTextEmailFieldField(
      {super.key, required this.controller, required this.hint, this.label, required this.paddingRate});

  TextEditingController controller;
  final String hint;
  String? label;
  final double paddingRate;

  @override
  State<InputTextEmailFieldField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextEmailFieldField> {
  final textStyle = TextStyleCustom();
  final String regExpEmail = r"^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Can\'t not empty';
          } else if (value.length < 2) {
            return 'Length must be > 2';
          } else if (!RegExp(regExpEmail).hasMatch(value)) {
            return "Enter with correct format :<";
          } else {
            return null;
          }
        },
        maxLines: 1,
        style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: widget.hint,
          hintStyle: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
