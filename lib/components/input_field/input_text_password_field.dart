import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class InputTextPasswordField extends StatefulWidget {
  InputTextPasswordField({super.key, required this.controller, required this.hint, this.label, required this.paddingRate, required this.textInputAction});

  TextEditingController controller;
  final String hint;
  String? label;
  double paddingRate;
  TextInputAction textInputAction;

  @override
  State<InputTextPasswordField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextPasswordField> {
  bool _seePassword = false;

  _toggleSeePassword(){
    setState(() {
      _seePassword = !_seePassword;
    });
  }

  final textStyle = TextStyleCustom();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Can\'t not empty';
          } else if (value.length < 2) {
            return 'Length must be > 2';
          } else {
            return null;
          }
        },
        maxLines: 1,
        style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
        obscureText: !_seePassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: InkWell(
            onTap: () {
              _toggleSeePassword();
            },
            child: !_seePassword ? const Icon(Icons.visibility_off_outlined) : const Icon(Icons.visibility_outlined),
          ),
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
