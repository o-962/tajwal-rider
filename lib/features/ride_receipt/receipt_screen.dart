import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/features/ride_receipt/controllers/receipt_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class ReceiptScreen extends StatelessWidget {
  RideService rideService = Get.find<RideService>();
  ReceiptScreen({super.key});

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? '-', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ride receipt")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final ride = rideService.ride;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ride.deliveryType != null)
                Column(
                  children: [
                    _infoRow('Delivery Type', ride.deliveryType?.name),
                    _infoRow('Driver Gender', ride.driverGender?.name),
                    _infoRow('Passengers Gender', ride.passengersGender?.name),
                    _infoRow('Male Passengers', ride.male.toString()),
                    _infoRow('Female Passengers', ride.female.toString()),
                  ],
                ),
              _infoRow('Gift Type', ride.giftType?.name),
              const SizedBox(height: 20),
              _infoRow('Pickup Location', ride.pickupLocation),
              _infoRow('Pickup Lat', ride.pickupLat.toString()),
              _infoRow('Pickup Lng', ride.pickupLng.toString()),
              const SizedBox(height: 20),
              _infoRow('Dropoff Location', ride.dropoffLocation),
              _infoRow('Dropoff Lat', ride.dropoffLat.toString()),
              _infoRow('Dropoff Lng', ride.dropoffLng.toString()),
              const SizedBox(height: 40),
              _infoRow('price', ride.cost.toString()),
              buttonWidget(text: 'send', onTap: ReceiptController().submit),
            ],
          );
        }),
      ),
    );
  }
}
