import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Significs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  bool showNoDevices = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse, // Required for scanning on Android
    ].request();
  }

  void startScan() async {
    setState(() {
      isScanning = true;
      scanResults.clear();
      showNoDevices = false; // Reset the "No Devices Found" message
    });

    // Start scanning
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Listen for scan results
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });

    // Wait 10 seconds and then check if devices were found
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        isScanning = false;
        if (scanResults.isEmpty) {
          showNoDevices = true; // Show "No Devices Found" only after 10s
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanning for Flex Sensor Gloves")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
                scanResults.isNotEmpty
                    ? ListView.builder(
                      itemCount: scanResults.length,
                      itemBuilder: (context, index) {
                        final data = scanResults[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(data.device.platformName),
                            subtitle: Text(data.device.remoteId.str),
                            trailing: Text("RSSI: ${data.rssi}"),
                          ),
                        );
                      },
                    )
                    : isScanning
                    ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Show loading
                    : showNoDevices
                    ? const Center(
                      child: Text("No Devices Found"),
                    ) // Show message after 10s
                    : const SizedBox(), // Empty when no scan has happened
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: startScan,
              child: const Text("SCAN"),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
