import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'message_list_widget.dart';

class FormChatBoxWidget extends StatefulWidget {
  const FormChatBoxWidget({super.key});

  @override
  State<FormChatBoxWidget> createState() => _FormChatBoxWidgetState();
}

class _FormChatBoxWidgetState extends State<FormChatBoxWidget> {
  DialogFlowtter? dialogFlowter; // Make it nullable
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  final textStyle = TextStyleCustom();

  @override
  void initState() {
    super.initState();
    _initializeDialogFlowtter();
  }

  void _initializeDialogFlowtter() async {
    dialogFlowter = DialogFlowtter(
      sessionId: Uuid().v4(), // Set your session ID
      jsonPath:
          "assets/chatbox/dialog_flow_auth.json", // Path to your DialogFlow JSON file
    );
    dialogFlowter?.dispose(); // Ensure the HTTP client is set up
    setState(() {}); // Rebuild UI after initialization
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 600,
        child: Stack(
          children: [
            Positioned.fill(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Lottie.asset('assets/animation/background_chatbox.json',
                  fit: BoxFit.cover),
            )),
            Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Chat Box',
                      style: textStyle.subTitleTextStyle(
                          FontWeight.w600, Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.white,
                ),
                Expanded(
                    child: MessageScreen(
                  messages: messages,
                  isLoading: isLoading,
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: _controller,
                        style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),),
                          hintText: 'Enter message ...',
                          hintStyle: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(width: 2,color: primaryColor)
                          )
                        ),
                      )),
                      IconButton(
                        onPressed: () {
                          sendMsg(_controller.text);
                          _controller.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          size: 25,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }

  sendMsg(String text) async {
    if (text.isEmpty) {
      return;
    }

    if (dialogFlowter == null) {
      return;
    }

    setState(() {
      addMessage(Message(text: DialogText(text: [text])), true);
    });

    DetectIntentResponse response = await dialogFlowter!.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );

    if (response.message == null) {
      return;
    } else {
      setState(() {
        isLoading = true;
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isLoading = false;
          });
        });
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
