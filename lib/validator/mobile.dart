import 'package:flutter_framework/common/code/code.dart';

int isMobileValid(String countryCode, String phoneNumber) {
  if (countryCode.isEmpty || phoneNumber.isEmpty) {
    return Code.empty;
  }
  return Code.oK;
}
