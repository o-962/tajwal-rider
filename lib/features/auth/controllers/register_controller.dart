import 'dart:io';

import 'package:get/get.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_response_model.dart';
import 'package:shared/shared/fields/controllers/form_controller.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:shared/shared/fields/states/field_state.dart';
import 'package:shared/shared/fields/validators/required_validator.dart';
import 'package:shared/shared/services/token_service.dart';

class RegisterController extends GetxController {
  late final FormController form;
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();

    form.add(
      FormFieldState(
        type: FieldInputType.first_name,
        rules: [RequiredRule('First name is required')],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.last_name,
        rules: [RequiredRule('Last name is required')],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.email,
        rules: [RequiredRule('Email is required')],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.phone,
        rules: [RequiredRule('Phone is required')],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.password,
        rules: [RequiredRule('Password is required')],
      ),
    );
  }

  Future<void> register() async {
    // if (!form.validateAll()) return;

    // loading.value = true;

    // final response = await ApiServices.dio.post(
    //   ApiEndpoints.register,
    //   data: form.toBackendJson(),
    // );

    // loading.value = false;

    // final ApiModel parsed = response.parsed;

    // if (parsed.errors != null) {
    //   form.applyServerErrors(parsed.errors!);
    //   return;
    // }

    // if (parsed.statusCode == HttpStatus.created) {
    //   final token = parsed.data?['token']?.toString() ?? '';
    //   if (token.isNotEmpty) {
    //     Get.find<TokenService>().token = token;
    //   }
    // }
  }

  @override
  void onClose() {
    form.dispose();
    super.onClose();
  }
}
