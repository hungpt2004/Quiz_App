import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_svg/svg.dart';

class SocialButtonField extends StatefulWidget {
  SocialButtonField({super.key, required this.text, required this.function});

  String text;
  VoidCallback function;

  @override
  State<SocialButtonField> createState() => _SocialButtonFieldState();
}

class _SocialButtonFieldState extends State<SocialButtonField> {
  final textStyle = TextStyleCustom();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTap: widget.function,
        child: Card(
          color: Colors.white,
          elevation: 8,
          child: ListTile(
            leading: SizedBox(
              width: 30,
              height: 30,
              child: ClipRRect(
                child: SvgPicture.asset('assets/svg/google.svg',fit: BoxFit.cover,),
              ),
            ),
            title: Text(widget.text,style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),),
          ),
        ),
      ),
    );
  }
}
