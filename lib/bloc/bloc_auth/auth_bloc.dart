import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_state.dart';
import 'package:flutter_quiz_app/service/shared_preferences/local_data_save.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc() : super(Initial()) {
    on<LoginOnPressed>(_login);
    on<RegisterOnPressed>(_register);
    on<ChangePasswordOnPressed>(_changePassword);
    on<UpdateOnPressed>(_update);
    on<UpdateAvatarOnPressed>(_updateAvatar);
    on<UpdateNameOnPressed>(_updateName);
    on<UpdateDobOnPressed>(_updateDob);
  }

  void _login(LoginOnPressed event, Emitter<AuthState> emit) async {
    try {
      emit(LoginLoading(isLoading: true));
      User? user = await DBHelper.instance.getUserByUsername(event.username);
      if(user != null) {
        if(user.username == event.username && user.password == event.password) {
          await LocalSaveData().saveDataUserLocal(user);
          print('User trong BLOC ${user.name}');
          emit(LoginSuccess(user: user));
        } else {
          emit(LoginFailure(error: 'Wrong password or username'));
        }
      } else {
        emit(LoginFailure(error: 'No have user data'));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  void _register(RegisterOnPressed event, Emitter<AuthState> emit) async {
    try {
      emit(RegisterLoading(isLoading: true));
      await DBHelper.instance.addNewUser(event.user);
      emit(RegisterSuccess(success: 'Register successfully'));
    } catch (e) {
      emit(RegisterLoading(isLoading: false));
      emit(RegisterFailure(error: e.toString()));
    }
  }

  void _changePassword(ChangePasswordOnPressed event, Emitter<AuthState> emit) async {
    try {
      emit(ResetPasswordLoading(isLoading: true)); // Bắt đầu loading
      await DBHelper.instance.updatePasswordUser(event.email, event.newPassword);
      User? user = await DBHelper.instance.getUserByEmail(event.email);
      emit(ResetPasswordSuccess(success: 'Change Password Successfully',user: user)); // Thành công
    } catch (e) {
      User? user = await DBHelper.instance.getUserByEmail(event.email);
      emit(ResetPasswordFailure(error: e.toString(), user: user)); // Lỗi
    }
  }

  void _update(UpdateOnPressed event, Emitter<AuthState> emit) async {
    try {
      await DBHelper.instance.updateUser(event.user, event.user.id!);
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  void _updateAvatar(UpdateAvatarOnPressed event, Emitter<AuthState> emit) async {
    try {
      await DBHelper.instance.updateAvatar(event.url, event.userId);
      User? user = await DBHelper.instance.getUserById(event.userId);
      emit(UpdateAvatarSuccess('Update avatar successfully',user!));
    } catch (e) {
      emit(UpdateAvatarFailure(e.toString()));
    }
  }

  void _updateName(UpdateNameOnPressed event, Emitter<AuthState> emit) async {
    try {
      await DBHelper.instance.updateName(event.name, event.userId);
      User? user = await DBHelper.instance.getUserById(event.userId);
      emit(UpdateNameSuccess('Update name successfully',user!));
    } catch (e) {
      emit(UpdateNameFailure(e.toString()));
    }
  }

  void _updateDob(UpdateDobOnPressed event, Emitter<AuthState> emit) async {
    try {
      await DBHelper.instance.updateDob(event.dob, event.userId);
      User? user = await DBHelper.instance.getUserById(event.userId);
      emit(UpdateDOBSuccess('Update dob successfully',user!));
    } catch (e) {
      emit(UpdateDOBFailure(e.toString()));
    }
  }



  static Future<void> login(BuildContext context, String username, String password) async {
    context.read<AuthBloc>().add(LoginOnPressed(username: username, password: password));
  }

  static Future<void> register(BuildContext context, User user) async {
    context.read<AuthBloc>().add(RegisterOnPressed(user: user));
  }

  static Future<void> changePassword(BuildContext context, String email, String newPassword) async {
    context.read<AuthBloc>().add(ChangePasswordOnPressed(email: email, newPassword: newPassword));
  }

  static Future<void> update(BuildContext context, User user) async {
    context.read<AuthBloc>().add(UpdateOnPressed(user));
  }

  static Future<void> updateAvatar(BuildContext context, String url, int userId) async {
    context.read<AuthBloc>().add(UpdateAvatarOnPressed(url,userId));
  }

  static Future<void> updateName(BuildContext context, String name, int userId) async {
    context.read<AuthBloc>().add(UpdateNameOnPressed(name,userId));
  }

  static Future<void> updateDob(BuildContext context, String dob, int userId) async {
    context.read<AuthBloc>().add(UpdateDobOnPressed(dob,userId));
  }

}