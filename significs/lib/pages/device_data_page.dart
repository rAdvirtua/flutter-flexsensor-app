import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ble_controller.dart';
import 'main_application_page.dart'; // Import the Main Application Page

class DeviceDataPage extends StatelessWidget {
  const DeviceDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BleController controller = Get.find<BleController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calibration Page"),
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
          const SizedBox(height: 20),
          // Calibration Logic
          Obx(() {
            if (controller.receivedData.value ==
                "Hello world from Flex Sensor Glove") {
              return ElevatedButton(
                onPressed: () {
                  // Navigate to the Main Application Page
                  Get.to(() => const MainApplicationPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Proceed to Main Application",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              return const Text(
                "Waiting for calibration message...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}