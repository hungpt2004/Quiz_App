import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotYetNoti extends StatelessWidget {
  const NotYetNoti({super.key, required this.label, required this.image});

  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyleCustom();
    return Center(
      child: SizedBox(
        width: StyleSize(context).screenWidth,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SvgPicture.asset(image,fit: BoxFit.cover,),
              ),
            ),
            const BoxHeight(h: 5),
            Text('You haven\'t added any quizzes yet',style: textStyle.contentTextStyle(FontWeight.w600, Colors.black),),
            const BoxHeight(h: 5),
            Text('Click $label in the quizzes to add to the list',style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),),
          ],
        ),
      ),
    );
  }
}
