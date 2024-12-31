import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

import '../../../../components/box/box_width.dart';
import '../../../../model/quiz.dart';

class QuizLabelTextWidget extends StatelessWidget {
  const QuizLabelTextWidget({super.key, required this.label, required this.content});

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyleCustom();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _label(label,textStyle),
          const BoxWidth(w: 10),
          Row(
            children: [
              Text(content,style: textStyle.contentTextStyle(FontWeight.w600, Colors.black),),
            ],
          )
        ],
      ),
    );
  }

  Widget _label(String text, TextStyleCustom textStyle){
    return Container(
      width: 70,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.purple.withOpacity(0.1)
      ),
      child: Center(
        child: Text(text, style: textStyle.contentTextStyle(FontWeight.w600, Colors.black),),
      ),
    );
  }

}
