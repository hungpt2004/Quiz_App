import 'package:flutter/cupertino.dart';

class StyleSize {
  final BuildContext context;

  StyleSize(this.context);

  final double figmaWidth = 412;
  final double figmaHeight = 915;

  // GETTER
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  // METHOD
  double widthPercent(double size) => (screenWidth / figmaWidth) * size;
  double heightPercent(double size) => (screenHeight / figmaHeight) * size;

  //Responsive font size
  double scale(double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / figmaWidth) * size;
  }

  //Responsive padding size
  double moderateScale(double size, [double factor = 0.5]) {
    final scaledSize = scale(size);
    return size + (scaledSize - size) * factor;
  }

}