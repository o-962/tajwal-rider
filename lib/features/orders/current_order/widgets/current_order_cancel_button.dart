import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/common/pages.dart';

/// The cancel-order action and its confirmation dialog. [filled] switches
/// between the solid button (assigned-driver screen) and the outlined one
/// (pending-board screen).
class CurrentOrderCancelButton extends StatelessWidget {
  const CurrentOrderCancelButton({
    super.key,
    required this.onCancel,
    this.filled = true,
  });

  final VoidCallback onCancel;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: filled
          ? ElevatedButton.icon(
              onPressed: _confirm,
              icon: const Icon(Icons.close),
              label: const Text('Cancel order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            )
          : OutlinedButton(
              onPressed: _confirm,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade600,
                side: BorderSide(color: Colors.red.shade600),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Cancel order',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
    );
  }

  void _confirm() {
    Get.defaultDialog(
      title: 'Cancel order',
      middleText: 'Are you sure you want to cancel this order?',
      textCancel: 'No',
      textConfirm: 'Yes, cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red.shade600,
      onConfirm: () {
        onCancel();
        Get.until((route) => route.settings.name == AppRoutes.shell);
      },
    );
  }
}
