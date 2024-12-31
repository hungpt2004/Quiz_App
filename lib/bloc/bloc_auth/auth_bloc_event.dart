import '../../model/user.dart';

abstract class AuthEvent {}

class LoginOnPressed extends AuthEvent {
  String username;
  String password;
  LoginOnPressed({required this.username, required this.password});
}

class LogoutOnPressed extends AuthEvent {}

class RegisterOnPressed extends AuthEvent {
  User user;
  RegisterOnPressed({required this.user});
}

class ChangePasswordOnPressed extends AuthEvent {
  String email;
  String newPassword;
  ChangePasswordOnPressed({required this.email, required this.newPassword});
}

class UpdateOnPressed extends AuthEvent {
  User user;
  UpdateOnPressed(this.user);
}

class UpdateAvatarOnPressed extends AuthEvent {
  String url;
  int userId;
  UpdateAvatarOnPressed(this.url, this.userId);
}

class UpdateNameOnPressed extends AuthEvent {
  String name;
  int userId;
  UpdateNameOnPressed(this.name, this.userId);
}

class UpdateDobOnPressed extends AuthEvent {
  String dob;
  int userId;
  UpdateDobOnPressed(this.dob, this.userId);
}