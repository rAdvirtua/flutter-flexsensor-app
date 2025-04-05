import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // Background color
      body: Stack(
        children: [
          // Top-left decorative circles with transparency
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF5577F9).withAlpha(51), // Circle color with transparency (20% opacity)
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
              decoration: BoxDecoration(
                color: const Color(0xFF5577F9).withAlpha(51), // Circle color with transparency (20% opacity)
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