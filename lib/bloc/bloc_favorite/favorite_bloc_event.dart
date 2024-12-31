import '../../model/favorite.dart';
import '../../model/quiz.dart';

abstract class FavoriteEvent {}

class OnPressedAddFavorite extends FavoriteEvent {
  Favorite favorite;
  int quizId;
  int userId;
  OnPressedAddFavorite(this.favorite, this.quizId, this.userId);
}

class OnPressedRemoveFavorite extends FavoriteEvent {
  int quizId;
  int userId;
  OnPressedRemoveFavorite(this.quizId, this.userId);
}

