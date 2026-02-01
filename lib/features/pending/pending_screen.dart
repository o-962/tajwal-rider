import 'package:flutter/material.dart';
import 'package:shared/widgets/text_widget.dart';
import 'package:tajwal_rider/features/pending/controllers/pending_controller.dart';

class PendingScreen extends StatelessWidget {



  const PendingScreen({ super.key, });

  @override
  Widget build(BuildContext context) {
    PendingController().waitingForAcceptance();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Waiting for Driver"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              textWidget('waiting'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  PendingController().cancelOrder();
                },
                child: const Text("Cancel order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
