import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/components/appbar/appbar_field.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_quiz_app/views/details/own_quiz_detail/widget/label_text_widget.dart';

import '../../../model/quiz.dart';

class QuizDetailScreen extends StatelessWidget {
  const QuizDetailScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyleCustom();
    return Scaffold(
      backgroundColor: fullColor,
      appBar: AppBarCustom.appbarBackTextBtn(context, 'Detail', textStyle),
      body: _cardDetail(context,textStyle),
    );
  }

  Widget _cardDetail(BuildContext context, TextStyleCustom textStyle){
    return Container(
      width: StyleSize(context).screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image(context),
            ],
          ),
          BoxHeight(h: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                QuizLabelTextWidget(label: 'Name', content: quiz.title),
                BoxHeight(h: 10),
                QuizLabelTextWidget(label: 'About', content:''),
                BoxHeight(h: 10),
                _textDot('* ${quiz.description}', textStyle),
                _textDot('* ${quiz.price == 0 ? 'Free Quiz' : '${quiz.price}\$/quiz'}', textStyle),
                _textDot('* ${quiz.typeId != 1 ? 'True/False Quiz' : 'Multiple Choice Quiz'}', textStyle),
                _textDot('* Publish at ${textStyle.formatDateFromText(quiz.createdAt)}', textStyle),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _image(BuildContext context){
    return Container(
      width: StyleSize(context).screenWidth,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: quiz.url
                .toString()
                .startsWith('/data/')
                ? FileImage(File(quiz.url))
                : CachedNetworkImageProvider(
                quiz.url),
            fit: BoxFit.cover
        ),
      ),
    );
  }

  Widget _textDot(String text, TextStyleCustom textStyle){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(child: Text(text,style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),))
        ],
      ),
    );
  }


}
