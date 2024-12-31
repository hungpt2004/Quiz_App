abstract class OwnQuizEvent {}

class OnPressedLoading extends OwnQuizEvent {
  int userId;
  OnPressedLoading(this.userId);
}

class OnPressedLoadingFavorite extends OwnQuizEvent {
  int userId;
  OnPressedLoadingFavorite(this.userId);
}
