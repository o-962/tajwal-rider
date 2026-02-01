// import 'package:get/get.dart';
// import 'package:shared/models/api_response_model.dart';
// import 'package:shared/models/socket_model.dart';
// import 'package:shared/shared/services/notification_service.dart';
// import 'package:shared/shared/services/token_service.dart';

// class ForgetPasswordController extends GetxController {
//   RxMap inputs = {}.obs;
//   RxBool loading = false.obs;
//   TokenService sharedToken = Get.find<TokenService>();
//   @override
//   void onInit() {
//     super.onInit();
//     try {
//       // inputs.value = Map.from(SharedData.fields['forget_password']);
//       // initializeControllers(inputs.value);
//     } catch (e) {
//       print(sharedToken);
//     }
//   }

//   void resetPassword() async {
//     loading.value = true;
    
//     try {

//       final emailController = inputs['phone_number']?['controller'];
//       if (emailController == null) {
//         print("Controller is null");
//         return;
//       }
//       String phoneNumber = emailController.text.trim();

//       // disableAll(inputs);
      
//       var request = await ApiServices.dio.post(
//         '/auth/forget-password',
//         data: {
//           'phone_number': phoneNumber, // send email here
//         },
//       );
//       ApiModel response = request.parsed;
//       print(response.code);
//       await Future.delayed(Duration(seconds: 3));
      


//     } catch (e) {
//       NotificationService.message(
//         SocketMessageModel(toastHead: 'Error', toastType: ToastTypes.alert, toastBody: 'Not correct')
//       );
//     } finally {
//       loading.value = false;
//       enableAll(inputs);
//     }
//   }

//   void validateField(String fieldKey, String value) {
//     validator(value, fieldKey, inputs);
//   }
// }
