import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_category/category_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_category/category_bloc_state.dart';
import 'package:flutter_quiz_app/theme/color.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(Initial()) {
    on<CategoryOnPressed>(_toggleCategory);
  }

  void _toggleCategory(CategoryOnPressed event, Emitter<CategoryState> emit) {
      emit(CategoryStateSuccess(subjectId: event.subjectId,color: primaryColor));
  }

  static Future<void> category(BuildContext context, int subjectId) async {
    context.read<CategoryBloc>().add(CategoryOnPressed(subjectId: subjectId));
  }

}