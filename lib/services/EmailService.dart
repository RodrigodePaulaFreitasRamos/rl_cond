
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  void enviarEmail(SimpleMailMessage email) async {
    final smtpServer = SmtpServer('smtp.example.com',
        username: 'username', password: 'password');
    final message = Message()
      ..from = Address(email.from)
      ..recipients.addAll(email.to)
      ..subject = email.subject
      ..text = email.text;
    await send(message, smtpServer);
  }

  void enviarEmail(String para, String assunto, String mensagem) async {
    final smtpServer = SmtpServer('smtp.example.com',
        username: 'username', password: 'password');
    final message = Message()
      ..from = Address('from@example.com')
      ..recipients.add(para)
      ..subject = assunto
      ..text = mensagem;
    await send(message, smtpServer);
  }
}