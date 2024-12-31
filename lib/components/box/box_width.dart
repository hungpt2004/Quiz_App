import 'package:flutter/cupertino.dart';

class BoxWidth extends StatelessWidget {
  const BoxWidth({super.key, required this.w});

  final double w;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
    );
  }
}
