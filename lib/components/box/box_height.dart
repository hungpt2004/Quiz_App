import 'package:flutter/cupertino.dart';

class BoxHeight extends StatelessWidget {
  const BoxHeight({super.key, required this.h});

  final double h;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h,
    );
  }
}
