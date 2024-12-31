// snackbar_util.dart
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class ShowScaffoldMessenger {

  final textStyle = TextStyleCustom();

  static void showScaffoldMessengerSuccessfully(
      BuildContext context, String message, TextStyleCustom textStyle)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                message,
                style: textStyle.contentTextStyle(FontWeight.w400, Colors.white))
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        duration: const Duration(seconds: 1)
      ),
    );
  }

  static void showScaffoldMessengerUnsuccessfully(
      BuildContext context, String message, TextStyleCustom textStyle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                message,
                style: textStyle.contentTextStyle(FontWeight.w400, Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  static void showScaffoldMessengerLoading(
      BuildContext context,TextStyleCustom textStyle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 30,
              height: 30,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: CircularProgressIndicator(color: primaryColor,),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'Please wait a few second !',
                style: textStyle.contentTextStyle(FontWeight.w400, primaryColor),
            )),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        duration: const Duration(seconds: 3),
      ),
    );
  }

}
