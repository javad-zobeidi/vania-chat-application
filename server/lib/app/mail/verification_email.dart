import 'package:vania/vania.dart';

class VerificationEmail extends Mailable {
  final String to;
  final int otp;
  final String subject;

  const VerificationEmail(
      {required this.to, required this.otp, required this.subject});

  String htmlTemplate(int otp) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Email Template</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .header {
            background-color: #007BFF;
            padding: 20px;
            text-align: center;
        }
        .header img {
            max-width: 100px;
        }
        .container {
            padding: 20px;
        }
        .top-text {
            font-size: 18px;
            font-weight: bold;
            letter-spacing: 6px;
            text-align: center;
        }
        .message {
            margin-top: 20px;
            text-align: center;
        }
        .footer {
            margin-top: 40px;
            text-align: center;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="https://vdart.dev/img/logo.png" alt="Logo">
    </div>
    <div class="container">
        <div class="top-text">$otp</div>
        <div class="message">
            <p>Keep your top secure and don't share it with others. Your security is our priority.</p>
        </div>
        <div class="footer">
            <p>example.com</p>
            <p>123 Company Address, City, Country</p>
        </div>
    </div>
</body>
</html>
''';
  }

  @override
  List<Attachment>? attachments() {
    return null;
  }

  @override
  Content content() {
    return Content(
      html: htmlTemplate(otp),
    );
  }

  @override
  Envelope envelope() {
    return Envelope(
      from: Address(
          env<String>('MAIL_FROM_ADDRESS'), env<String>('MAIL_FROM_NAME')),
      to: [Address(to)],
      subject: subject,
    );
  }
}
