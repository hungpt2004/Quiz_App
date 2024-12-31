import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/bloc/bloc_answer/answer_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_own_quiz/ownquiz_bloc.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/network_image.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import '../../../model/user.dart';

class HistoryQuizDetailScreen extends StatefulWidget {
  const HistoryQuizDetailScreen({super.key, required this.quizId, required this.quizUrl});
  //yeu cau 1 quiz id
  final int quizId;
  final String quizUrl;

  @override
  State<HistoryQuizDetailScreen> createState() => _HistoryQuizDetailScreenState();
}

class _HistoryQuizDetailScreenState extends State<HistoryQuizDetailScreen> {
  User? currentUser = UserManager().currentUser;
  final networkImage = NetworkImageWidget();
  final textStyle = TextStyleCustom();


  @override
  void initState() {
    //Loading quiz id
    //Loading question
    //Loading cau tra loi cua nguoi dung
    OwnQuizBloc.loadingQuiz(context, currentUser!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final quizId = widget.quizId;
    final quizUrl = widget.quizUrl;

    return Scaffold(
      backgroundColor: fullColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            expandedHeight: 200, // Chiều cao khi mở rộng
            floating: false, // Không nổi trên màn hình
            pinned: true, // Giữ lại phần appBar khi cuộn
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [
                StretchMode.zoomBackground, // Phóng to hình ảnh
                StretchMode.fadeTitle, // Làm mờ tiêu đề
              ],
              title: Text(
                'DETAIL YOUR QUIZ',
                style: TextStyle(color: Colors.white), // Màu chữ tiêu đề
              ),
              centerTitle: true,
              expandedTitleScale: 1,
              collapseMode: CollapseMode.parallax,
              background: ClipRRect(
                child: quizUrl.toString().startsWith('/data/')
                    ? Image.file(
                  File(quizUrl),
                  fit: BoxFit.cover,)
                    : networkImage.networkImage(quizUrl),
              )
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _body(quizId)
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(int quizId){
    return FutureBuilder(
        future: DBHelper.instance.getQuizById(quizId),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } else if (!snapshot.hasData) {
            return Text('No have data');
          } else if (snapshot.hasError) {
            return Text('Have an error');
          }
          final quizIndex = snapshot.data!;
          return FutureBuilder(
              future: DBHelper.instance.getQuestionListByQuizId(quizIndex.id!),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                } else if (!snapshot.hasData) {
                  return Text('No have data');
                } else if (snapshot.hasError) {
                  return Text('Have an error');
                }
                final questionList = snapshot.data!;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: questionList.length,
                  itemBuilder: (context, index) {
                    final questionIndex = questionList[index];
                    List<String> listAnswer = [];
                    listAnswer.add(questionIndex['answer1']);
                    listAnswer.add(questionIndex['answer2']);
                    listAnswer.add(questionIndex['answer3']);
                    listAnswer.add(questionIndex['answer4']);
                    return _cardQuestion(questionIndex, listAnswer);
                  },
                );
              },
          );
        },
    );
  }

  Widget _cardQuestion(Map<String,dynamic> question, List<dynamic> listAnswer){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        elevation: 10,
        color: fullColor,
        child: Column(
          children: [
            BoxHeight(h: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(question['content'],style: textStyle.contentTextStyle(FontWeight.w700, Colors.black),)),
                ],
              ),
            ),
            BoxHeight(h: 20),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listAnswer.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: _cardAnswer(listAnswer[index], (index+1), question['correct_answer']),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _cardAnswer(String answerIndex, int index, int correctAnswer){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        height: 50,
        width: StyleSize(context).widthPercent(100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: index != correctAnswer ? Colors.black : Colors.green.shade700,width: 1),
          color: index != correctAnswer ? Colors.white : Colors.green.shade700
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BoxWidth(w: 15),
              Expanded(child: Text(answerIndex,style: textStyle.superSmallTextStyle(FontWeight.w600, index != correctAnswer ? Colors.black : Colors.white),)),
            ],
          ),
        ),
      ),
    );
  }

}
