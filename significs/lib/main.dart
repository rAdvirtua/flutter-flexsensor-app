import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ble_controller.dart'; // Adjusted the import path to match the local file structure

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BLE Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final BleController controller = Get.put(BleController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanning the environment for Flex Sensor Gloves"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Connection Status Display
          Obx(() => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.connectionStatus.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              )),
          Expanded(
            child: Obx(() {
              final scanResults = controller.scanResults.value;
              if (scanResults.isNotEmpty) {
                return ListView.builder(
                  itemCount: scanResults.length,
                  itemBuilder: (context, index) {
                    final data = scanResults[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(data.device.name.isNotEmpty
                            ? data.device.name
                            : "Unknown Device"),
                        subtitle: Text(data.device.id.id),
                        trailing: Text("RSSI: ${data.rssi}"),
                        onTap: () {
                          controller.connectToDevice(data.device);
                          Get.snackbar(
                            "Connection Status",
                            "Attempting to connect to ${data.device.name.isNotEmpty ? data.device.name : "Unknown Device"}",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                    );
                  },
                );
              } else if (controller.isScanning.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: Text("No Devices Found"),
                );
              }
            }),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await controller.scanDevices();
            },
            child: Obx(() => Text(
                  controller.isScanning.value ? "Scanning..." : "SCAN",
                )),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}