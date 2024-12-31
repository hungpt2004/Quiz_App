import 'dart:ui';

abstract class CategoryState {}

class Initial extends CategoryState {}

class CategoryStateSuccess extends CategoryState {
  int subjectId;
  final Color color;
  CategoryStateSuccess({required this.subjectId, required this.color});
}

class CategoryStateFailure extends CategoryState {
  final String error;
  CategoryStateFailure({required this.error});
}