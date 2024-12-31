import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_favorite/favorite_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_favorite/favorite_bloc_state.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';

import '../../model/favorite.dart';
import '../../model/quiz.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(Initial()) {
    on<OnPressedAddFavorite>(_onAddFavorite);
    on<OnPressedRemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onAddFavorite(OnPressedAddFavorite event, Emitter<FavoriteState> emit) async {
    try {
      await DBHelper.instance.addNewFavorite(event.favorite, event.quizId, event.userId);
      Quiz? quiz = await DBHelper.instance.getQuizById(event.quizId);
      if (quiz != null) {
        emit(FavoriteAddSuccess('Add favorite success', quiz));
      } else {
        emit(FavoriteAddFailure('Quiz not found'));
      }
    } catch (e) {
      emit(FavoriteAddFailure(e.toString()));
    }
  }

  Future<void> _onRemoveFavorite(OnPressedRemoveFavorite event, Emitter<FavoriteState> emit) async {
    try {
      await DBHelper.instance.removeFavorite(event.quizId, event.userId);
      Quiz? quiz = await DBHelper.instance.getQuizById(event.quizId);
      if (quiz != null) {
        emit(FavoriteRemoveSuccess('Remove favorite success', quiz));
      } else {
        emit(FavoriteRemoveFailure('Quiz not found'));
      }
    } catch (e) {
      emit(FavoriteRemoveFailure(e.toString()));
    }
  }



  static Future<void> addFavorite(BuildContext context, Favorite favorite, int quizId, int userId) async {
    context.read<FavoriteBloc>().add(OnPressedAddFavorite(favorite,quizId, userId));
  }


  static Future<void> removeFavorite(BuildContext context, int quizId, int userId) async {
    context.read<FavoriteBloc>().add(OnPressedRemoveFavorite(quizId, userId));
  }

}