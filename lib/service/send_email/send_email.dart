import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/service/send_email/password_random.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';

import '../../constant/email_key.dart';
import 'package:http/http.dart' as http;

import '../../model/pin.dart';

class SendEmailService {

  final PasswordService passwordService = PasswordService();

  final String _userID = user_id;
  final String _templateID1 = template_id1;
  final String _templateID2 = template_id2;
  final String _serviceID = service_id;

  Future<bool> sendEmailResetPassword(String toEmail) async {
    try {
      print("Checking if user exists...");
      List<Map<String, dynamic>> users = await DBHelper.instance.getAllUser();
      print("Users fetched: ${users.length}");

      // Check if the email exists
      Map<String, dynamic>? user;
      for (var u in users) {
        if (u['email'] == toEmail) {
          user = u;
          break;
        }
      }

      if (user == null) {
        print("User not found for email: $toEmail");
        throw Exception('User not found');
      } else {
        print("User found, generating password...");
        String password = passwordService.generateRandomPin();
        int check = await DBHelper.instance.addNewPin(password, toEmail);
        print("Pin added to database: $check");

        if (check == 0) {
          print("Failed to add pin to the database");
          return false;
        }

        print("Sending email...");
        final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'service_id': _serviceID,
            'template_id': _templateID1,
            'user_id': _userID,
            'template_params': {
              'to_email': toEmail,
              'company_name': 'QuizzLiz Group Auto',
              'from_name': 'QuizzLiz Group Auto',
              'to_name': toEmail,
              'pin_code': password
            }
          }),
        );

        print("Email response status: ${response.statusCode}");
        print("Email response body: ${response.body}");

        if (response.statusCode == 200) {
          print("Email sent successfully");
          return true;
        } else {
          print('Error: Status code ${response.statusCode}');
          return false;
        }
      }
    } catch (e) {
      print("Error in sendEmailResetPassword: ${e.toString()}");
      throw Exception(e.toString());
    }
  }


}
