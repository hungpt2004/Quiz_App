import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class LabelText extends StatelessWidget {
  const LabelText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyleCustom();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(text,style: textStyle.contentTextStyle(FontWeight.bold, Colors.black),)
        ],
      ),
    );
  }
}
