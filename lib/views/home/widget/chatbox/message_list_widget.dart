import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MessageScreen extends StatefulWidget {
  final List messages;
  bool isLoading;
  MessageScreen({super.key, required this.messages, required this.isLoading});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final textStyle = TextStyleCustom();
  @override
  Widget build(BuildContext context) {
    const width = 400;
    return ListView.separated(
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: widget.messages[index]["isUserMessage"]
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 200),
                // height: widget.isLoading == true && !widget.messages[index]["isUserMessage"] ? 50 : null,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: widget.messages[index]["isUserMessage"]
                      ? secondaryColor
                      : Colors.grey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      topLeft: Radius.circular(
                          widget.messages[index]["isUserMessage"] ? 20 : 0),
                      bottomRight: Radius.circular(
                          widget.messages[index]["isUserMessage"] ? 0 : 20)),
                ),
                constraints: const BoxConstraints(maxWidth: width * 2 / 3),
                child: widget.isLoading == true &&
                        !widget.messages[index]["isUserMessage"]
                    ? _loading()
                    : Text(
                        widget.messages[index]["message"].text.text[0],
                        style: TextStyle(
                            color: widget.messages[index]["isUserMessage"]
                                ? Colors.white
                                : Colors.black),
                      ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(top: 10),
        );
      },
    );
  }

  Widget _loading() {
    return Center(
      child: Container(
        width: 40,
        height: 20,
        child: const LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          strokeWidth: 1,
          colors: [Colors.white],
        ),
      ),
    );
  }
}
