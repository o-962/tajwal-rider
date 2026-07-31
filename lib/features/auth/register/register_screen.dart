import 'package:flutter/material.dart';
import 'package:shared/base/base_form_screen.dart';
import 'package:shared/base/base_screen.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:tajwal_rider/features/auth/register/controllers/register_controller.dart';

class RegisterScreen extends BaseScreen<RegisterController> {
  const RegisterScreen({super.key})
  : super(title: 'signup', showLoading: true);

  @override
  Widget builder(RegisterController controller) {
    return BaseFormScreen(
      headerIcon: Icons.person_add,
      headerTitle: 'create_account',
      headerDescription: 'sign_up_to_get_started',

      headerIconColor: AppColor.primary,
      formCardIconColor: AppColor.primary,
      fields: [
        controller.form.get(FieldInputType.FIRST_NAME),
        controller.form.get(FieldInputType.LAST_NAME),
        controller.form.get(FieldInputType.USER_NAME),
        controller.form.get(FieldInputType.EMAIL),
        controller.form.get(FieldInputType.PHONE_NUMBER),
        controller.form.get(FieldInputType.PASSWORD),
      ],
      buttonText: 'signup',
      onSubmit: controller.register,
      isLoading: controller.isLoading,
    );
  }
}
