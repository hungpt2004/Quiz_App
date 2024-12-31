import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';

import '../model/user.dart';

class TestDatabase extends StatefulWidget {
  const TestDatabase({super.key});

  @override
  _TestDatabaseState createState() => _TestDatabaseState();
}

class _TestDatabaseState extends State<TestDatabase> {
  final TextEditingController totalScore = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();
    user = UserManager().currentUser; // Load user data
  }

  Future<void> _updateData() async {
    if (user != null) {
      await DBHelper.instance.updateUserTotalScore(int.parse(totalScore.text), user!.id!);
      await DBHelper.instance.updateRankByScore(user!.totalScore!, user!.id!);

      // Reload user data to reflect changes
      setState(() {
        user = UserManager().currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null)
              Center(
                child: Card(
                  child: ListTile(
                    title: Text(user!.username),
                    subtitle: Text('${user!.totalScore}'),
                    trailing: Text('${user!.id}'),
                  ),
                ),
              ),
            TextField(
              controller: totalScore,
              decoration: InputDecoration(
                hintText: 'Enter total score',
              ),
            ),
            ButtonField(
              text: 'UPDATE',
              function: _updateData,
            ),
          ],
        ),
      ),
    );
  }
}
