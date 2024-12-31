abstract class EmailState {}

class Initial extends EmailState {}

class SendSuccess extends EmailState {
  String success;
  SendSuccess({required this.success});
}

class SendFail extends EmailState {
  String error;
  SendFail({required this.error});
}

class SendLoading extends EmailState {
  bool isLoading;
  SendLoading({required this.isLoading});
}

