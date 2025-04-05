// ignore_for_file: deprecated_member_use

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'pages/device_data_page.dart';
import 'package:flutter/material.dart';

class BleController extends GetxController {
  final Rx<BluetoothDevice?> connectedDevice = Rx<BluetoothDevice?>(null);
  final RxString connectionStatus = "Disconnected".obs;
  final RxBool isScanning = false.obs;
  final RxList<ScanResult> scanResults = <ScanResult>[].obs;
  final RxString receivedData = "".obs;

  Future<void> scanDevices() async {
    isScanning.value = true;
    try {
      // Clear previous results
      scanResults.clear();

      // Start scanning for devices
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      // Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {
        scanResults.value = results;
      });

      // Wait for the scan to complete
      await Future.delayed(const Duration(seconds: 10));

      // Stop scanning
      FlutterBluePlus.stopScan();
    } catch (e) {
      Get.snackbar("Error", "Failed to scan devices: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isScanning.value = false;
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      connectionStatus.value = "Connecting to ${device.name}...";
      print("Attempting to connect to ${device.name}");
      await device.connect(timeout: const Duration(seconds: 15));
      connectedDevice.value = device; // Set the connected device
      connectionStatus.value = "Connected to ${device.name}";
      print("Connected to ${device.name}");

      // Discover services and characteristics
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        print("Service UUID: ${service.uuid}");
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          print("Characteristic UUID: ${characteristic.uuid}");
          print("Properties: ${characteristic.properties}");
          
          if (characteristic.properties.read) {
            print("This characteristic supports reading.");
          }
          if (characteristic.properties.write || characteristic.properties.writeWithoutResponse) {
            print("This characteristic supports writing.");
          }
          
          if (characteristic.properties.read && (characteristic.properties.write || characteristic.properties.writeWithoutResponse)) {
            print("Starting periodic read for characteristic: ${characteristic.uuid}");
            _readDataPeriodically(characteristic);
          } else {
            print("This characteristic does not meet the conditions for periodic read.");
          }

          // Enable notifications for the characteristic
          if (!characteristic.isNotifying) {
            await characteristic.setNotifyValue(true); // Enable notifications
            print("Notifications enabled for characteristic: ${characteristic.uuid}");
          }
          String buffer = ""; // Temporary buffer to store fragments

          characteristic.value.listen((value) {
            print("Notification received (decimal): $value");
            print("Notification received (hex): ${value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}");

            if (value.isNotEmpty) {
              try {
                // Decode the data as ASCII
                String data = String.fromCharCodes(value);

                // Ignore the echoed "R"
                if (data == "R") {
                  print("Ignored echoed 'R'");
                  return;
                }

                // Check for printable ASCII characters and valid control characters
                if (value.every((byte) => (byte >= 32 && byte <= 126) || byte == 13 || byte == 10)) {
                  // Append the fragment to the buffer
                  buffer += data;

                  // Check if the message is complete (e.g., ends with a newline or specific delimiter)
                  if (buffer.endsWith("\r\n")) {
                    receivedData.value = buffer.trim(); // Update the reactive variable
                    print("Complete message: ${receivedData.value}");
                    buffer = ""; // Clear the buffer for the next message
                  }
                } else {
                  print("Received corrupted data: $value");
                  buffer = ""; // Reset the buffer
                }
              } catch (e) {
                print("Error decoding data as ASCII: $e");
              }
            }
          });
        }
      }

      // Navigate to the new page
      Get.to(() => const DeviceDataPage());
    } catch (e) {
      connectionStatus.value = "Failed to connect to ${device.name}: $e";
      print("Error connecting to device: $e");
      Get.snackbar("Error", "Failed to connect to ${device.name}: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _readDataPeriodically(BluetoothCharacteristic characteristic) async {
    try {
      print("Entered _readDataPeriodically for characteristic: ${characteristic.uuid}");
      while (connectedDevice.value != null) {
        // Write the "R" command to the characteristic
        if (characteristic.properties.write || characteristic.properties.writeWithoutResponse) {
          print("Attempting to send 'R' command to ${characteristic.uuid}");
          await characteristic.write([82], withoutResponse: false); // Send "R"
          print("Sent 'R' command to ${characteristic.uuid}");
        } else {
          print("Characteristic does not support writing: ${characteristic.uuid}");
        }

        // Wait for 2 seconds before sending the next command
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      print("Error writing data: $e");
    }
  }

  Future<void> disconnectDevice() async {
    if (connectedDevice.value != null) {
      await connectedDevice.value!.disconnect();
      connectionStatus.value = "Disconnected";
      connectedDevice.value = null;
    }
  }

  Stream<List<ScanResult>> get scanResultsStream => FlutterBluePlus.scanResults;
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // Background color
      body: Stack(
        children: [
          // Top-left decorative circles
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFF5577F9), // Circle color
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF5577F9), // Circle color
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SIGNIFICS",
                  style: TextStyle(
                    fontFamily: "Poppins", // Font family
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your go to SL INTERPRETER",
                  style: TextStyle(
                    fontFamily: "Poppins", // Font family
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Add the logo image here
                Image.asset(
                  'assets/images/logo.png', // Path to your image
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain, // Adjust how the image fits in the container
                ),
                const SizedBox(height: 32),
                const Text(
                  "Do you sense a barrier in your daily-life communication? "
                  "Then this app is for you",
                  style: TextStyle(
                    fontFamily: "Poppins", // Font family
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to main.dart
                    Get.offAllNamed('/main');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5577F9), // Button color
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontFamily: "Poppins", // Font family
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}