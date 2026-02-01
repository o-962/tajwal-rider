// rider_history_model.dart
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
      pickupLocation: json['pickupLocation'] ?? '',
      dropoffLocation: json['dropoffLocation'] ?? '',
      pickUpLat: toDouble(json['pickUpLat']),
      pickUpLng: toDouble(json['pickUpLng']),
      dropOffLat: toDouble(json['dropOffLat']),
      dropOffLng: toDouble(json['dropOffLng']),
      cost: toDouble(json['cost']),
      costDiscounted:
          json['costDiscounted'] == null ? null : toDouble(json['costDiscounted']),
      driverName: json['driverName'] ?? '',
      driverPhoneNumber: json['driverPhoneNumber'] ?? '',
      driverVehicle: json['driverVehicle'] ?? '',
      group: json['group'] ?? '',
    );
  }
}

/// ===============================
/// RIDER HISTORY RESPONSE
/// ===============================
class RiderHistoryModel {
  final List<RiderHistoryOrderModel> orders;
  final int totalOrders;
  final double totalCosts;
  final double totalProfits;

  RiderHistoryModel({
    required this.orders,
    required this.totalOrders,
    required this.totalCosts,
    required this.totalProfits,
  });

  factory RiderHistoryModel.fromJson(Map<String, dynamic> json) {
    final ordersList = (json['orders'] as List<dynamic>? ?? [])
        .map((e) => RiderHistoryOrderModel.fromJson(e))
        .toList();

    return RiderHistoryModel(
      orders: ordersList,
      totalOrders: toInt(json['totalOrders']),
      totalCosts: toDouble(json['totalCosts']),
      totalProfits: toDouble(json['totalProfits']),
    );
  }
}