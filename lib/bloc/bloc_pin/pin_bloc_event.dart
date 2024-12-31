abstract class PinEvent{}

class OnPressedPinToString extends PinEvent {
  String num1;
  String num2;
  String num3;
  String num4;
  String num5;
  String num6;
  OnPressedPinToString({required this.num1,required this.num2,required this.num3,required this.num4,required this.num5,required this.num6,});
}

class OnPressSendPin extends PinEvent {
  String pinCode;
  String email;
  OnPressSendPin({required this.pinCode, required this.email});
}

class OnPressedClearAllPin extends PinEvent {

}