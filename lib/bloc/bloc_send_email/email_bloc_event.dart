abstract class EmailEvent {}

class OnPressSendEmail extends EmailEvent {
  final String toEmail;
  OnPressSendEmail({required this.toEmail});
}
