import 'package:flutter/material.dart';
import '../../service/shared_preferences/singleton_user_manage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Load user data from UserManager (if it's available)
    await UserManager().loadUser();

    // After loading, navigate to home screen
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show loading spinner
      ),
    );
  }
}
