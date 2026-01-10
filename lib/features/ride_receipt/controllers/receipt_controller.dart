import 'package:dio/dio.dart';
import 'package:shared/services/api_services.dart';
import 'package:tajwal_rider/services/ride_services.dart';
import 'package:shared/services/shared_data.dart';

class ReceiptController {
  Future<void> submit() async {
    try {
      // Ensure Dio is initialized
      if (!SharedData.isInitialized) {
        throw Exception("Dio instance not initialized");
      }

      Map<String, dynamic> data = RideServices.ride.toJson();
      
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
