import 'dart:io';

import 'package:get/get.dart';
import 'package:shared/core/config/app_config.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_response_model.dart';
import 'package:shared/shared/fields/controllers/form_controller.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:shared/shared/fields/states/field_state.dart';
import 'package:shared/shared/fields/validators/required_validator.dart';
import 'package:shared/shared/services/notification_service.dart';
import 'package:shared/shared/services/token_service.dart';
import 'package:tajwal_rider/features/auth/interfaces/login_interface.dart';

class LoginController extends GetxController {
  late final FormController<LoginDto> form;

  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    form = FormController<LoginDto>(allowedFields: LoginDto.fields);
    form.add(
      FormFieldState(
        type: FieldInputType.email_or_phone_or_username,
        rules: [RequiredRule('Identifier is required')],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.password,
        rules: [RequiredRule('Password is required')],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.fcm_token,
        rules: [RequiredRule('FCM Token is required')],
        isHidden: true,
        isHiddenMessage: 'FCM Token will be set automatically',
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.is_driver,
        isHidden: true,
        isHiddenMessage: 'Driver flag not found',
      ),
    );
  }

  Future<void> login() async {
    
    String? fcm = await NotificationService.getFCMToken();
    
    form.text(FieldInputType.fcm_token, fcm ?? '');
    form.text(FieldInputType.is_driver, AppConfig.isDriver);

    if (!form.validateAll()) return;

    loading.value = true;

    final response = await ApiServices.dio.post(
      ApiEndpoints.login,
      data: form.toBackendJson(),
    );

    loading.value = false;

    final ApiModel parsed = response.parsed;
    if (parsed.errors != null) {
      form.applyServerErrors(parsed.errors!);
      return;
    }

    if (parsed.statusCode == HttpStatus.ok) {
      final token = parsed.data?['token']?.toString() ?? '';
      if (token.isNotEmpty) {
        Get.find<TokenService>().token = token;
      }
    }
  }

  @override
  void onClose() {
    form.dispose();
    super.onClose();
  }
}
