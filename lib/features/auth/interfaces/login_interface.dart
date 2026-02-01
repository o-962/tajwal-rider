import 'package:shared/shared/fields/interfaces/fields.dart';

class LoginDto {
  static const Set<FieldInputType> fields = {
    FieldInputType.email_or_phone_or_username,
    FieldInputType.password,
    FieldInputType.fcm_token,
    FieldInputType.is_driver,
  };

  final String emailOrPhoneOrUsername;
  final String password;
  final String fcmToken;
  final bool isDriver;

  LoginDto({
    required this.emailOrPhoneOrUsername,
    required this.password,
    required this.fcmToken,
    required this.isDriver,
  });

  Map<String, dynamic> toJson() {
    return {
      FieldInputType.email_or_phone_or_username.name: emailOrPhoneOrUsername,
      FieldInputType.password.name: password,
      FieldInputType.fcm_token.name: fcmToken,
      FieldInputType.is_driver.name: isDriver,
    };
  }
}