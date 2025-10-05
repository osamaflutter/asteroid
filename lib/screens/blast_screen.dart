import 'dart:ui';
import 'package:asteroid/config/app_color.dart';
import 'package:asteroid/models/prediction_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'impact_map_screen.dart';

class BlastScreen extends StatefulWidget {
  const BlastScreen({super.key});

  @override
  State<BlastScreen> createState() => _BlastScreenState();
}

class _BlastScreenState extends State<BlastScreen> {
  final eccController = TextEditingController(text: "0.35");
  final axisController = TextEditingController(text: "2.5");
  final velController = TextEditingController(text: "22.1");
  final angVelController = TextEditingController(text: "0.002");
  final inclController = TextEditingController(text: "10.5");
  final diamController = TextEditingController(text: "1500");

  bool isLoading = false;

  Future<void> predictImpact() async {
    setState(() => isLoading = true);

    try {
      final latitude = await ApiService.predictLatitude(
        double.parse(eccController.text),
        double.parse(axisController.text),
        double.parse(inclController.text),
        double.parse(diamController.text),
      );

      if (latitude == null) throw Exception("Failed to get latitude");

      final longitude = await ApiService.predictLongitude(
        double.parse(eccController.text),
        double.parse(axisController.text),
        double.parse(velController.text),
        double.parse(angVelController.text),
        double.parse(inclController.text),
        double.parse(diamController.text),
        latitude,
      );

      if (longitude == null) throw Exception("Failed to get longitude");

      final blastRadius = await ApiService.predictBlast(
        double.parse(eccController.text),
        double.parse(axisController.text),
        double.parse(velController.text),
        double.parse(inclController.text),
      );

      if (blastRadius == null) throw Exception("Failed to get blast radius");

      PredictionData.blastRadius = blastRadius;
      PredictionData.latitude = latitude;
      PredictionData.longitude = longitude;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImpactMapScreen(
            latitude: 35,
            longitude: 30,
            blastRadius: 50,
            semiMajorAxis: 2.3,
            eccentricity: 0.35,
            inclination: 10.5,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
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
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        // 🌍 Content
        ListView(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: 20,
            top: 50,
          ),
          children: [
            // 🔭 Input fields
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

            const SizedBox(height: 30),

            // 🚀 Predict button
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
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
                      onPressed: predictImpact,
                      child: Text(
                        "Predict Impact",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
