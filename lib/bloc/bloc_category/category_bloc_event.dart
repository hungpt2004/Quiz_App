abstract class CategoryEvent {}

class CategoryOnPressed extends CategoryEvent {
  int subjectId;
  CategoryOnPressed({required this.subjectId});
}