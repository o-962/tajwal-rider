import 'dart:io';

import 'package:get/get.dart';
import 'package:shared/models/api_response_model.dart';
import 'package:shared/services/notification_services.dart';
import 'package:shared/utils/text_controller_utils.dart';
import 'package:shared/services/api_services.dart';
import 'package:shared/services/shared_data.dart';

class RegisterController extends GetxController {
  RxMap inputs = {}.obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      inputs.value = Map.from(SharedData.fields['register']);
      initializeControllers(inputs.value);
    } catch (e) {
      print('error occured');
      print(SharedData.fields);
    }
  }

  void register() async {
    loading.value = true;
    try {
      Map fields = extractTextFields(inputs);
      disableAll(inputs);
      
      await Future.delayed(Duration(seconds: 3));
      
      var request = await ApiServices.dio.post('/auth/register', data: fields);

      ApiModel response = request.parsed;

      if (response.statusCode == HttpStatus.unprocessableEntity) {
        // editErrors(inputs, response.errors);
      }
      
      if (response.statusCode == HttpStatus.created) {
        String? token = response.data!['token'];
        if (token != null) {
          // SocketConnectionServices().reconnect(token);
          SharedData.token = response.data!['token'];
        }
      }
    } catch (e) {
      NotificationServices.errorOccurred(
        error: e,
        message: "error while registering your account",
        header: "Error :(",
      );
    } finally {
      loading.value = false;
      enableAll(inputs);
    }
  }

  void validateField(String fieldKey, String value) {
    validator(value, fieldKey, inputs);
  }
}