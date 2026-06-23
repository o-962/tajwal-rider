import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/base/base_screen.dart';
import 'package:tajwal_rider/features/trip_waiting/ride_pending_acceptance/controllers/pending_controller.dart';
import 'package:tajwal_rider/features/trip_waiting/ride_pending_acceptance/widgets/cancel_order_widget.dart';
import 'package:tajwal_rider/features/trip_waiting/ride_pending_acceptance/widgets/searching_animation_widget.dart';
import 'package:tajwal_rider/features/trip_waiting/ride_pending_acceptance/widgets/waiting_message_widget.dart';

class PendingScreen extends BaseScreen<PendingController> {
  const PendingScreen({super.key})
  : super(title: 'waiting_for_driver', showLoading: false);

  @override
  Widget builder(PendingController controller) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          const Spacer(flex: 2),
          
          // Animated search indicator
          const SearchingAnimationWidget(),
          
          const SizedBox(height: 40),
          
          // Waiting message card
          const WaitingMessageWidget(),
          
          const Spacer(flex: 3),
          
          // Cancel button
          CancelOrderWidget(onCancel: controller.cancelOrder),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
