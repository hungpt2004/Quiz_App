import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomProgressbar extends StatelessWidget {
  const CustomProgressbar({
    super.key,
    required this.width,
    required this.height,
    required this.progress,
  });

  final double width;
  final double height;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final percentString = (progress * 100).toStringAsFixed(2); // Chuyển thành chuỗi và giới hạn 2 chữ số thập phân
    final twoDigits = percentString.split('.')[0];
    final textStyle = TextStyleCustom();

    return SizedBox(
      width: width,
      height: height,
      child: LinearPercentIndicator(
        width: width, // Chiều rộng thanh tiến trình
        lineHeight: height, // Chiều cao thanh tiến trình
        percent: progress.clamp(0.0, 1.0), // Giới hạn giá trị từ 0 -> 1
        backgroundColor: Colors.grey.withOpacity(0.6), // Màu nền phần chưa hoàn thành
        progressColor: Colors.green, // Màu phần đã hoàn thành
        center: Text(
          '${int.parse(twoDigits)}%', // Hiển thị % ở giữa
          style: textStyle.smallTextStyle(FontWeight.w600, Colors.white),
        ),
        barRadius: const Radius.circular(10), // Bo góc thanh tiến trình
        animation: true, // Hiệu ứng mượt khi thay đổi giá trị
        animationDuration: 1500, // Thời gian hiệu ứng
        curve: Curves.easeInOut,
      ),
    );
  }
}
