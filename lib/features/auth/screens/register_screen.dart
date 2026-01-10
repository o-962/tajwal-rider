import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/common/colors.dart';
import 'package:shared/common/media_query.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/features/auth/controllers/register_controller.dart';
import 'package:shared/utils/text_controller_utils.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: AppSize.height * 0.5,
                  child: Image.asset(
                    assetsRoutes['images']['login-banner'],
                    fit:BoxFit.cover,
                  ),
                  
                ),
                const Positioned(
                  bottom: 10,
                  left: 20,
                  
                  child: Text(
                    'Register new account', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.primary, fontSize: 32),
                  ),
                ),
              ],
            ),
            
            Obx(
              () => Column(
                children: buildTextFields(
                  controller.inputs, 
                  (fieldKey, value) => controller.validateField(fieldKey, value),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Obx(() => buttonWidget(
              text: 'Signup',
              onTap: controller.register,
              loading: controller.loading.value,
              loadingText: 'Signing up...'
            )),
          ],
        ),
      ),
    );
  }
}