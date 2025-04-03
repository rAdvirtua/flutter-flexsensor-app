import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ble_controller.dart';

class DeviceDataPage extends StatelessWidget {
  const DeviceDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BleController controller = Get.find<BleController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Data"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Connection Status Display
          Obx(() => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Connection Status: ${controller.connectionStatus.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              )),
          const SizedBox(height: 20),
          // Received Data Display
          Obx(() => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Received Data: ${controller.receivedData.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}