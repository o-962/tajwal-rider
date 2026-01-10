import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/common/colors.dart';
import 'package:shared/common/font_size.dart';
import 'package:shared/common/media_query.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:shared/widgets/text_widget.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:shared/utils/app_utils.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  TextStyle _headingStyle(double size, Color color) =>
      TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Image Section
            Column(
              children: [
                TextButton(onPressed: () => changeLanguage(), child: Text('Change Language')),
                Container(
                  height: AppSize.height * 0.5,
                  width: AppSize.width,
                  color: AppColor.secondary,
                  alignment: Alignment.center,
                  child: Image.asset(
                    assetsRoutes['images']['logo-transparent'],
                    width: AppSize.width * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
        
            // Bottom Text + Buttons Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                        "hi1",
                        style: _headingStyle(AppFontSize.big, AppColor.primary),
                      ),
                      const SizedBox(height: 8),
                      textWidget(
                        'أفضل خيار لك مع خدماتنا المميزة',
                        style: _headingStyle(AppFontSize.mid, AppColor.primary),
                      ),
                    ],
                  ),
        
                  // Buttons
                  Column(
                    children: [
                      buttonWidget(
                        text: 'Login',
                        onTap: () => Get.toNamed(AppRoutes.login),
                      ),
                      const SizedBox(height: 1),
                      buttonWidget(
                        text: 'Signup',
                        onTap: () => Get.toNamed(AppRoutes.register),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
