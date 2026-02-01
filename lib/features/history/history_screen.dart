// history_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/history_controller.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip History')),
      body: Obx(() {
        final h = controller.history.value;
        if (h == null || h.orders.isEmpty) {
          return const Center(child: Text('No history found'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem('Trips', h.totalOrders),
                  _summaryItem('Total', h.totalCosts),
                  _summaryItem('Profit', h.totalProfits),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: h.orders.length,
                itemBuilder: (context, i) {
                  final o = h.orders[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${o.pickupLocation} → ${o.dropoffLocation}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text('Cost: ${o.cost}'),
                          if (o.costDiscounted != null) Text('Discounted: ${o.costDiscounted}'),
                          Text('Group: ${o.group}'),
                          const SizedBox(height: 6),
                          Text('Driver: ${o.driverPhoneNumber}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryItem(String label, num value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
