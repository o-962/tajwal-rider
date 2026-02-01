import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/index.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:shared/shared/fields/widget/field_input.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/features/auth/controllers/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: AppSize.height * 0.5,
                  width: AppSize.width,
                  child: Image.asset(
                    AppAssets.logo,
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  left: 20,
                  child: Text(
                    'Register new account',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FieldInput(
                    field: controller.form.get(FieldInputType.first_name),
                  ),
                  FieldInput(
                    field: controller.form.get(FieldInputType.last_name),
                  ),
                  FieldInput(
                    field: controller.form.get(FieldInputType.email),
                  ),
                  FieldInput(
                    field: controller.form.get(FieldInputType.phone),
                  ),
                  FieldInput(
                    field: controller.form.get(FieldInputType.password),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => buttonWidget(
                text: 'Signup',
                onTap: controller.register,
                loading: controller.loading.value,
                loadingText: 'Signing up...',
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
