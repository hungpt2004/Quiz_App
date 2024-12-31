import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class InputNumberField extends StatefulWidget {
  const InputNumberField({
    Key? key,
    required this.controller,
    required this.textInputAction,
    required this.hint,
    this.label,
    required this.paddingRate,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String hint;
  final String? label;
  final double paddingRate;

  @override
  State<InputNumberField> createState() => _InputNumberFieldState();
}

class _InputNumberFieldState extends State<InputNumberField> {
  final TextStyleCustom textStyle = TextStyleCustom();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingRate),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        textInputAction: widget.textInputAction,
        maxLines: 1,
        style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
        decoration: _buildInputDecoration(),
        validator: _validateInput,
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.2),
      hintText: widget.hint,
      hintStyle: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }
}
