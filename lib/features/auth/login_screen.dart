import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/core/routing/route.dart';
import 'package:shared/shared/constants/index.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:shared/shared/fields/widget/field_input.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/features/auth/controllers/login_controller.dart';

// ignore: must_be_immutable
class LoginScreen extends GetView<LoginController> {
  LoginScreen({super.key});
  
  @override
  LoginController controller = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FieldInput(
                    field: controller.form.get(
                      FieldInputType.email_or_phone_or_username,
                    ),
                  ),
                  FieldInput(
                    field: controller.form.get(
                      FieldInputType.password,
                    ),
                  ),
                ],
              ),
            ),

            Obx(
              () => buttonWidget(
                text: 'login',
                onTap: controller.login,
                loading: controller.loading.value,
                loadingText: 'Logging in...',
              ),
            ),

            buttonWidget(
              text: 'forgetPassword',
              onTap: () =>
                  Get.toNamed(CommonRoutes.forgetPasswordIdentifier),
            ),
          ],
        ),
      ),
    );
  }
}
