import 'dart:ui';
import 'package:asteroid/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class LongitudeScreen extends StatefulWidget {
  final double? latitudeValue;

  const LongitudeScreen({super.key, this.latitudeValue});

  @override
  State<LongitudeScreen> createState() => _LongitudeScreenState();
}

class _LongitudeScreenState extends State<LongitudeScreen> {
  final eccController = TextEditingController(text: "0.35");
  final axisController = TextEditingController(text: "2.5");
  final velController = TextEditingController(text: "22.1");
  final angVelController = TextEditingController(text: "0.002");
  final inclController = TextEditingController(text: "10.5");
  final diamController = TextEditingController(text: "1500");

  double? result;

  Future<void> predict() async {
    final value = await ApiService.predictLongitude(
      double.parse(eccController.text),
      double.parse(axisController.text),
      double.parse(velController.text),
      double.parse(angVelController.text),
      double.parse(inclController.text),
      double.parse(diamController.text),
      widget.latitudeValue ?? 0.0,
    );
    setState(() => result = value);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🌌 Background
        Image.asset(
          'assets/images/background.png',
          width: 600,
          scale: 0.5,
          fit: BoxFit.cover,
        ),

        // 🌍 Main content
        ListView(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: 20,
            top: 50,
          ),
          children: [
            // 🔭 Inputs
            TextField(
              controller: eccController,
              decoration: _inputDecoration("Eccentricity"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: axisController,
              decoration: _inputDecoration("Semi Major Axis (AU)"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: velController,
              decoration: _inputDecoration("Velocity (km/s)"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: angVelController,
              decoration: _inputDecoration("Angular Velocity (deg/s)"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: inclController,
              decoration: _inputDecoration("Inclination Angle (deg)"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: diamController,
              decoration: _inputDecoration("Diameter (m)"),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),
            Text(
              "Latitude (from Tab 1): ${widget.latitudeValue ?? "Not calculated"}",
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 25),

            // 🚀 Predict Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffAD46FF).withOpacity(0.6),
                    blurRadius: 20, // increase to make it more blurry
                    spreadRadius: 6, // make it spread wider
                    //offset: const Offset(0, 6), // move shadow down
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffAD46FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: predict,
                child: Text(
                  "Predict Longitude",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (result != null) ...[
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Predicted Longitude: $result",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
