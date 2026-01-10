import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/fields_model.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/features/auth/controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  controller.fieldsController
                      .fieldWidget(type: FieldInputType.email),

                  controller.fieldsController
                      .fieldWidget(type: FieldInputType.password),
                ],
              ),
            ),

            buttonWidget(
              text: 'login',
              onTap: controller.login,
            ),
          ],
        ),
      ),
    );
  }
}
