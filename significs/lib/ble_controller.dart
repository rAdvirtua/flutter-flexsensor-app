// ignore_for_file: deprecated_member_use

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  final Rx<BluetoothDevice?> connectedDevice = Rx<BluetoothDevice?>(null);
  final RxString connectionStatus = "Disconnected".obs;
  final RxBool isScanning = false.obs;
  final RxList<ScanResult> scanResults = <ScanResult>[].obs;

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
      await device.connect(timeout: const Duration(seconds: 15));
      connectionStatus.value = "Connected to ${device.name}";
    } catch (e) {
      connectionStatus.value = "Failed to connect to ${device.name}: $e";
      Get.snackbar("Error", "Failed to connect to ${device.name}: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Stream<List<ScanResult>> get scanResultsStream => FlutterBluePlus.scanResults;
}