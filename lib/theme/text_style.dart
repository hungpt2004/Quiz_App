import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const heading1 = 24;
const heading1_5 = 18;
const heading2 = 14;
const heading3 = 12;
const heading4 = 10;
const heading5 = 16;

class TextStyleCustom {

  TextStyle titleTextStyle( FontWeight weight, Color color) {
    return GoogleFonts.aboreto(
      fontSize: heading1.toDouble(),
      fontWeight: weight,
      color: color
    );
  }

  TextStyle subTitleTextStyle( FontWeight weight, Color color) {
    return GoogleFonts.aboreto(
        fontSize: heading1_5.toDouble(),
        fontWeight: weight,
        color: color
    );
  }

  TextStyle contentTextStyle( FontWeight weight, Color color) {
    return GoogleFonts.quicksand(
        fontSize: heading2.toDouble(),
        fontWeight: weight,
        color: color
    );
  }

  TextStyle questionTextStyle( FontWeight weight, Color color) {
    return GoogleFonts.quicksand(
        fontSize: heading1_5.toDouble(),
        fontWeight: weight,
        color: color
    );
  }

  TextStyle smallTextStyle( FontWeight weight, Color color) {
    return GoogleFonts.quicksand(
        fontSize: heading4.toDouble(),
        fontWeight: weight,
        color: color
    );
  }

  TextStyle superSmallTextStyle( FontWeight weight, Color color) {
    return GoogleFonts.quicksand(
        fontSize: heading3.toDouble(),
        fontWeight: weight,
        color: color
    );
  }

  Widget titleRow(TextStyleCustom textStyle, String text){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(text,style: textStyle.subTitleTextStyle(FontWeight.w600, Colors.black),),
        ],
      ),
    );
  }


  //DATE FORMAT
  String formatDateFromText(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }




}