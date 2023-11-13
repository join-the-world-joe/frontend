import 'package:email_validator/email_validator.dart';

bool isEmailValid(String email) {
  return EmailValidator.validate(email);
}