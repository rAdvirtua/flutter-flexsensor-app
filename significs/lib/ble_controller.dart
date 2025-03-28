// ignore_for_file: deprecated_member_use

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  Future<void> scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

        FlutterBluePlus.stopScan();
      }
    }
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}
