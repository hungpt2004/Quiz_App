import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class ButtonIcon extends StatefulWidget {
  ButtonIcon({super.key, required this.text, required this.icon, required this.function});

  final String text;
  final IconData icon;
  VoidCallback function;

  @override
  State<ButtonIcon> createState() => _ButtonFieldState();
}

class _ButtonFieldState extends State<ButtonIcon> {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(widget.icon,color: Colors.white,size: 20,),
          const BoxWidth(w: 5),
          Text(widget.text,textAlign: TextAlign.center,style: textStyle.contentTextStyle(FontWeight.w600, Colors.white),),
        ],
      )
    );
  }
}
