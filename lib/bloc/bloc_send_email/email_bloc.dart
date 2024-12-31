import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_send_email/email_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_send_email/email_bloc_state.dart';
import 'package:flutter_quiz_app/service/send_email/password_random.dart';
import 'package:flutter_quiz_app/service/send_email/send_email.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  EmailBloc() : super(Initial()) {
    on<OnPressSendEmail>(_sendEmail);
  }

  void _sendEmail(OnPressSendEmail event, Emitter<EmailState> emit) async {
    try {
      emit(SendLoading(isLoading: true)); // Emit loading state once at the start
      bool check =
          await SendEmailService().sendEmailResetPassword(event.toEmail);
      if (check) {
        emit(SendSuccess(success: 'Send email success! Please check email'));
        print("DA GUI MAIL");
      } else {
        emit(SendFail(error: 'Send email fail! Try again'));
        print("DA GUI ERROR");
      }
    } catch (e) {
      emit(SendFail(error: e.toString()));
    }
  }

  static Future<void> sendEmail(BuildContext context, String email) async {
    context.read<EmailBloc>().add(OnPressSendEmail(toEmail: email));
  }
}
