import 'dart:async'; // Import Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ble_controller.dart';

class MainApplicationPage extends StatelessWidget {
  const MainApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BleController controller = Get.find<BleController>();

    // Variable to store the completed sentence
    final RxString completedSentence = ''.obs;

    // Variable to control the blinking cursor
    final RxBool showCursor = true.obs;

    // Start a periodic timer to toggle the cursor visibility
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      showCursor.value = !showCursor.value;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Application"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gesture Display with Blinking Cursor
            Obx(() => RichText(
                  text: TextSpan(
                    text: "Gesture: ${controller.receivedData.value} ", // Current gesture
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: showCursor.value ? "|" : "", // Blinking cursor
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            // Finished Button
            ElevatedButton(
              onPressed: () {
                // Append the current gesture to the completed sentence
                completedSentence.value += "${controller.receivedData.value} ";
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "FINISHED",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Completed Sentence Display
            Obx(() => Text(
                  "Completed Sentence: ${completedSentence.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}