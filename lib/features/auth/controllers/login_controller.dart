import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/common/enums.dart';
import 'package:shared/common/fields.dart';
import 'package:shared/models/api_response_model.dart';
import 'package:shared/models/fields_model.dart';
import 'package:shared/services/api_services.dart';
import 'package:shared/services/notification_services.dart';
import 'package:shared/services/shared_data.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FieldsHandlerController fieldsController = FieldsHandlerController();

  @override
  void onInit() {
    super.onInit();

    fieldsController.addField(
      type: FieldInputType.email,
      controller: emailController,
      otherParams: const FieldContext(
        value: 'o.alkhatib962@gmail.com'
      ),
    );

    fieldsController.addField(
      type: FieldInputType.password,
      controller: passwordController,
      otherParams: const FieldContext(
        value: 'ah90ahah'
      ),
    );
  }

  void login() async {
    fieldsController.validateAll();
    var request = await ApiServices.dio.post(
      '/auth/login',
      data: {
        FieldInputType.email.name: emailController.text,
        FieldInputType.password.name: passwordController.text,
      },
    );

    ApiModel response = request.parsed;
    if (response.statusCode == HttpStatus.ok) {
        String? token = response.data!['token'];
        if (token != null && token != '') {
          SharedData.token = token;
        }
      }
      else {
        NotificationServices.snackBarMessage(
          messageStatus: MessageStatusType.alert,
          header: "Login Failed",
          message: "Email or password is incorrect",
        );
      }
    // backend validation errors
    fieldsController.validateField(response.errors);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
