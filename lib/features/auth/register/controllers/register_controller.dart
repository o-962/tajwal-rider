import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared/base/base_controller.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_dto.dart';
import 'package:shared/shared/fields/controllers/form_controller.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:shared/shared/fields/states/field_state.dart';
import 'package:shared/shared/fields/validators/required_validator.dart';
import 'package:shared/shared/services/notification_service.dart';
import 'package:tajwal_rider/common/pages.dart';

class RegisterController extends BaseController {

  RegisterController();

  late final FormController form;

  @override
  void onInit() {
    super.onInit();

    form = FormController(
      allowedFields: {
        FieldInputType.FIRST_NAME,
        FieldInputType.LAST_NAME,
        FieldInputType.EMAIL,
        FieldInputType.PHONE_NUMBER,
        FieldInputType.PASSWORD,
        FieldInputType.USER_NAME,
        FieldInputType.FCM_TOKEN,
      },
    );

    form.add(
      FormFieldState(
        type: FieldInputType.FIRST_NAME,
        rules: [RequiredRule('first_name_required'.tr)],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.LAST_NAME,
        rules: [RequiredRule('last_name_required'.tr)],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.EMAIL,
        rules: [RequiredRule('email_required'.tr)],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.PHONE_NUMBER,
        rules: [RequiredRule('phone_required'.tr)],
      ),
    );

    form.add(
      FormFieldState(
        type: FieldInputType.PASSWORD,
        rules: [RequiredRule('password_required'.tr)],
      ),
    );
    form.add(
      FormFieldState(
        type: FieldInputType.USER_NAME,
        rules: [RequiredRule('user_name_required'.tr)],
      ),
    );
    form.add(
      FormFieldState(
        type: FieldInputType.FCM_TOKEN,
        isHidden: true,
        isHiddenMessage: 'fcm_token_push_required'.tr,
        rules: [RequiredRule('fcm_token_required'.tr)],
      ),
    );
  }

  Future<void> register() async {
    String? fcm = await NotificationService.getFCMToken();
    form.text(FieldInputType.FCM_TOKEN, fcm);
    if (!form.validateAll()) return;

    await execute(
      () async {
        final response = await ApiServices.dio.post(
          ApiEndpoints.register,
          data: form.toJson(),
        );

        final ApiDto parsed = response.parsed;
        if (parsed.errors != null) {
          form.applyServerErrors(parsed.errors!);
        }

        if (parsed.statusCode == HttpStatus.created) {
          final identifier =
              parsed.data?['email_or_phone_or_username']?.toString() ?? '';
          if (identifier.isNotEmpty) {
            Get.toNamed(AppRoutes.registerOtpVerify, arguments: identifier);
          }
          return parsed;
        }
      },
      errorMessage: 'registration_failed'.tr,
    );
  }

  @override
  void onClose() {
    form.dispose();
    super.onClose();
  }
}
