import '../../model/user.dart';

abstract class AuthState {}


//Before show form login
class Initial extends AuthState {}

class LoginSuccess extends AuthState {
  final User user;
  LoginSuccess({required this.user});
}

class LoginFailure extends AuthState {
  final String error;
  LoginFailure({required this.error});
}

class LoginLoading extends AuthState {
  bool isLoading;
  LoginLoading({required this.isLoading});
}

class RegisterSuccess extends AuthState{
  final String success;
  RegisterSuccess({required this.success});
}

class RegisterFailure extends AuthState{
  final String error;
  RegisterFailure({required this.error});
}

class RegisterLoading extends AuthState {
  bool isLoading;
  RegisterLoading({required this.isLoading});
}

class ResetPasswordSuccess extends AuthState {
  final String success;
  User? user;
  ResetPasswordSuccess({required this.success, this.user});
}

class ResetPasswordFailure extends AuthState{
  final String error;
  User? user;
  ResetPasswordFailure({required this.error, this.user});
}

class ResetPasswordLoading extends AuthState {
  bool isLoading;
  ResetPasswordLoading({required this.isLoading});
}

class UpdateSuccess extends AuthState {
  String text;
  UpdateSuccess(this.text);
}

class UpdateFailure extends AuthState {
  String text;
  UpdateFailure(this.text);
}

class UpdateAvatarSuccess extends AuthState {
  String text;
  User user;
  UpdateAvatarSuccess(this.text, this.user);
}


class UpdateAvatarFailure extends AuthState {
  String text;
  UpdateAvatarFailure(this.text);
}


class UpdateNameSuccess extends AuthState {
  String text;
  User user;
  UpdateNameSuccess(this.text, this.user);
}


class UpdateNameFailure extends AuthState {
  String text;
  UpdateNameFailure(this.text);
}

class UpdateDOBSuccess extends AuthState {
  String text;
  User user;
  UpdateDOBSuccess(this.text, this.user);
}


class UpdateDOBFailure extends AuthState {
  String text;
  UpdateDOBFailure(this.text);
}