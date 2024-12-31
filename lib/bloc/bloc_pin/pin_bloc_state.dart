abstract class PinState {}

class Initial extends PinState {}

class PinSuccess extends PinState {
  String success;
  String? pin;
  PinSuccess({required this.success,this.pin});
}

class PinFail extends PinState {
  String error;
  PinFail({required this.error});
}

class PinLoading extends PinState {
  bool isLoading;
  PinLoading({required this.isLoading});
}

