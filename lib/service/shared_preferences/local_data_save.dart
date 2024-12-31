import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user.dart';

class LocalSaveData {
  Future<void> saveDataUserLocal(User user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Lưu các thông tin cần thiết
      await prefs.setInt('id', user.id ?? 0);
      await prefs.setInt('rankId', user.rankId ?? 1);
      await prefs.setString('name', user.name);
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);
      await prefs.setString('password', user.password);
      await prefs.setString('phone', user.phone ?? 'N/A');
      await prefs.setString('dob', user.dob?.toIso8601String() ?? 'N/A');
      await prefs.setString('url', user.url ?? '');
      await prefs.setInt('totalScore', user.totalScore ?? 0);
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // Phương thức để lấy thông tin người dùng từ SharedPreferences
  Future<User?> getDataUserLocal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('username')) {
        return User(
          id: prefs.getInt('id'),
          rankId: prefs.getInt('rankId'),
          name: prefs.getString('name') ?? '',
          username: prefs.getString('username') ?? '',
          password: prefs.getString('password') ?? '',
          email: prefs.getString('email') ?? '',
          phone: prefs.getString('phone'),
          dob: prefs.getString('dob') != 'N/A'
              ? DateTime.tryParse(prefs.getString('dob') ?? '')
              : null,
          url: prefs.getString('url'),
          totalScore: prefs.getInt('totalScore'),
        );
      }
      return null;
    } catch (e) {
      print("Error retrieving user data: $e");
      return null;
    }
  }

  //Logout
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // hoặc dùng `prefs.clear()` để xóa tất cả dữ liệu
  }
}
