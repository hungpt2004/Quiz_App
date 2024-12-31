import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_category/category_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_category/category_bloc_state.dart';
import 'package:flutter_quiz_app/model/subject.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

class CategoriesQuizWidget extends StatefulWidget {
  const CategoriesQuizWidget({super.key});

  @override
  State<CategoriesQuizWidget> createState() => _CategoriesQuizWidgetState();
}

class _CategoriesQuizWidgetState extends State<CategoriesQuizWidget> {
  final textStyle = TextStyleCustom();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBHelper.instance.getAllSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: primaryColor,);
          } else if (!snapshot.hasData) {
            return const Text('No data for subject');
          } else if (snapshot.hasError) {
            return const Text('Error data subject');
          }
          return _body(snapshot.data!);
        }
      ),
    );
  }

  // B U T T O N
  Widget _buttonCategory(Map<String,dynamic> subject, TextStyleCustom textStyle, bool isSelected){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: (){
          CategoryBloc.category(context, subject['id']);
        },
        child: Card(
          color: !isSelected ? Colors.white : primaryColor,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide.none),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(subject['name'],style: textStyle.contentTextStyle(FontWeight.w500, !isSelected ? Colors.black : Colors.white ),),
            ),
          ),
        ),
      ),
    );
  }

  // B O D Y
  Widget _body(List<Map<String,dynamic>> subject){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: subject.length,
      itemBuilder: (context, index) {
        final subjectIndex = subject[index];
        // bool isSelected = subjectIndex['id'] == state.subjectId;
        return _buttonCategory(subjectIndex, textStyle, true);
      },
    );
  }

}
