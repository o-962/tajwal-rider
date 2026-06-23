// rider_history_model.dart
import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:shared/utils/index.dart';
/// ===============================
/// RIDER HISTORY ORDER
/// ===============================
class RiderHistoryOrderModel {
  final String pickupLocation;
  final String dropoffLocation;
  final double pickUpLat;
  final double pickUpLng;
  final double dropOffLat;
  final double dropOffLng;
  final double cost;
  final double? costDiscounted;
  final String driverName;
  final String driverPhoneNumber;
  final String driverVehicle;
  final String group;

  RiderHistoryOrderModel({
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickUpLat,
    required this.pickUpLng,
    required this.dropOffLat,
    required this.dropOffLng,
    required this.cost,
    this.costDiscounted,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.driverVehicle,
    required this.group,
  });

  factory RiderHistoryOrderModel.fromJson(Map<String, dynamic> json) {
    return RiderHistoryOrderModel(
      pickupLocation: (json[FieldInputType.PICKUP_LOCATION.value] ?? '').toString(),
      dropoffLocation: (json[FieldInputType.DROPOFF_LOCATION.value] ?? '').toString(),
      pickUpLat: toDouble(json[FieldInputType.PICKUP_LAT.value]),
      pickUpLng: toDouble(json[FieldInputType.PICKUP_LNG.value]),
      dropOffLat: toDouble(json[FieldInputType.DROPOFF_LAT.value]),
      dropOffLng: toDouble(json[FieldInputType.DROPOFF_LNG.value]),
      cost: toDouble(json[FieldInputType.COST.value]),
      costDiscounted:
        json[FieldInputType.COST_DISCOUNTED.value] == null ? null : toDouble(json[FieldInputType.COST_DISCOUNTED.value]),
      driverName: (json[FieldInputType.DRIVER_NAME.value] ?? '').toString(),
      driverPhoneNumber: (json[FieldInputType.DRIVER_PHONE_NUMBER.value] ?? '').toString(),
      driverVehicle: (json[FieldInputType.DRIVER_VEHICLE.value] ?? '').toString(),
      group: (json[FieldInputType.GROUP.value] ?? '').toString(),
    );
  }
  
}

/// ===============================
/// RIDER HISTORY RESPONSE
/// ===============================
class RiderHistoryDto {
  final List<RiderHistoryOrderModel> orders;
  final int totalOrders;
  final double totalCosts;
  final double totalProfits;

  RiderHistoryDto({
    required this.orders,
    required this.totalOrders,
    required this.totalCosts,
    required this.totalProfits,
  });

  factory RiderHistoryDto.fromJson(Map<String, dynamic> json) {
    final ordersList = (json[FieldInputType.ORDERS.value] as List<dynamic>? ?? [])
        .map((e) => RiderHistoryOrderModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return RiderHistoryDto(
      orders: ordersList,
      totalOrders: toInt(json[FieldInputType.TOTAL_ORDERS.value]),
      totalCosts: toDouble(json[FieldInputType.TOTAL_COSTS.value]),
      totalProfits: toDouble(json[FieldInputType.TOTAL_PROFITS.value]),
    );
  }
}