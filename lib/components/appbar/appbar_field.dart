import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

import '../../theme/color.dart';

class AppBarCustom {
  final textStyle = TextStyleCustom();

  static AppBar appbarBackNextBtn(TextStyleCustom textStyle, BuildContext context, TextEditingController controller) {
    return AppBar(
      backgroundColor: primaryColor,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  )),
              Text(
                'Back',
                style: textStyle.subTitleTextStyle(
                    FontWeight.bold, Colors.white),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Next',
                style: textStyle.subTitleTextStyle(
                    FontWeight.bold, Colors.white),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/pin',
                        arguments: controller.text);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  )),
            ],
          )
        ],
      ),
      leadingWidth: double.infinity,
    );
  }

  static AppBar appbarBackBtn(TextStyleCustom textStyle, BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  )),
              Text(
                'Back',
                style: textStyle.subTitleTextStyle(
                    FontWeight.bold, Colors.white),
              )
            ],
          ),
        ],
      ),
      leadingWidth: double.infinity,
    );
  }

  static AppBar appbarNoBackBtn(BuildContext context, String text, TextStyleCustom textStyle){
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: fullColor,
      title: Text(text,
          style: textStyle.titleTextStyle(FontWeight.w700, primaryColor)),
    );
  }

  static AppBar appbarBackTextBtn(BuildContext context, String text, TextStyleCustom textStyle){
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      backgroundColor: fullColor,
      title: Text(text,
          style: textStyle.titleTextStyle(FontWeight.w700, primaryColor)),
    );
  }

}