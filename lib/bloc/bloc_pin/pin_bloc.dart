import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_pin/pin_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_pin/pin_bloc_state.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import '../../model/pin.dart';
import '../../model/user.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  PinBloc() :super(Initial()) {
    on<OnPressedPinToString>(_onPressToGetPin);
    on<OnPressSendPin>(_onPressSendPin);
  }

  Future<void> _onPressToGetPin(OnPressedPinToString event,
      Emitter<PinState> emit) async {
    try {
      String pinCode = '${event.num1}${event.num2}${event.num3}${event.num4}${event.num5}${event.num6}';
      pinCode = pinCode.trim();
      emit(PinSuccess(success: 'You enter $pinCode',pin: pinCode));
    } catch (e) {
      emit(PinFail(error: e.toString()));
      throw Exception(e.toString());
    }
  }

  Future<bool> _onPressSendPin(OnPressSendPin event, Emitter<PinState> emit) async {
    try {
      User? user = await DBHelper.instance.getUserByEmail(event.email);
      if (user == null) {
        emit(PinFail(error: 'User not found'));
        return false;
      }

      Pin? pin = await DBHelper.instance.getPinByUserId(user.id!);
      if (pin == null) {
        emit(PinFail(error: 'No pin code found in DB'));
        return false;
      }

      DateTime realTime = DateTime.now();
      print('Expired AT :${pin.expiredAt}');
      print('Start AT :${pin.createdAt}');
      print('Now AT :${realTime}');
      if (event.pinCode == pin.pinCode && (realTime.isAfter(pin.createdAt!) && realTime.isBefore(pin.expiredAt!))) {
        print('PIN CODE SUCCESS: ${pin.pinCode}');
        emit(PinSuccess(success: 'Pin are correct!'));
        return true;
      } else if (event.pinCode != pin.pinCode) {
        print('User ID: ${user.id}');
        print('Event Pin Code: ${event.pinCode}');
        print('Database Pin Code: ${pin.pinCode}');
        print('Created At: ${pin.createdAt}');
        print('Expired At: ${pin.expiredAt}');
        print('Current Time: $realTime');
        emit(PinFail(error: 'Pin are not correct! Try again'));
        return false;
      } else if (realTime.isAfter(pin.expiredAt!)) {
        emit(PinFail(error: 'Pin are over time! Request again'));
        return false;
      }
      return false;
    } catch (e) {
      emit(PinFail(error: 'An error occurred: ${e.toString()}'));
      return false;
    }
  }

  static Future<void> sendPin(BuildContext context, String pinCode, String email) async {
    context.read<PinBloc>().add(OnPressSendPin(pinCode: pinCode, email: email));
  }

  static Future<void> getPin(BuildContext context, String num1, String num2, String num3, String num4, String num5, String num6) async {
    context.read<PinBloc>().add(OnPressedPinToString(num1: num1, num2: num2, num3: num3, num4: num4, num5: num5, num6: num6));
  }


}
