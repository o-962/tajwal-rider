import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared/core/config/app_config.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class ReceiptController {
  RideService rideService = Get.find<RideService>();
  Future<void> submit() async {
    try {
      // Ensure Dio is initialized
      if (!AppConfig.isInitialized) {
        throw Exception("Dio instance not initialized");
      }
      Map<String, dynamic> data = rideService.ride.toJson();
      var response = await ApiServices.dio.post( '/orders', data: data, );
      if (response.data == null) {
        print('No response data from server');
        return;
      }

      print('Order response: ${response.data}');
    } on DioException catch (e) {
      print('Dio error: $e');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }
}
