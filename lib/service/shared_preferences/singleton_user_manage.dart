import '../../model/user.dart';
import 'local_data_save.dart';

class UserManager {
  //_internal ten constructor trong dart
  //
  //Su dung trong cac singleton pattern => tao ra 1 class duy nhat
  //
  //_ => private constructor

  static final UserManager _instance = UserManager._internal();
  User? currentUser;

  factory UserManager() {
    return _instance;
  }

  //constructor
  UserManager._internal();

  Future<void> loadUser() async {
    currentUser = await LocalSaveData().getDataUserLocal();
  }

  Future<void> logout() async {
    // Clear the user data from local storage
    await LocalSaveData().clearUserData(); // Ensure this method clears user data in SharedPreferences

    // Clear currentUser in UserManager
    currentUser = null; // Reset the currentUser to null

    // Optionally, notify other parts of the app that the user has logged out (e.g., with BLoC or Provider)
  }
}

