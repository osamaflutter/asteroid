import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsequencesScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double blastRadius;

  const ConsequencesScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.blastRadius,
  });

  // Simple estimation formulas (for demo purposes)
  double calculateEarthquakeMagnitude(double blastRadius) {
    return (blastRadius / 50).clamp(4.0, 10.0); // Richter scale
  }

  String calculateTsunamiRisk(double lat, double lon) {
    // Example: if latitude/longitude near ocean zones (dummy logic)
    if (lat.abs() > 60 || lon.abs() > 150) {
      return "🌊 High tsunami risk (coastal/ocean impact)";
    }
    return "Low tsunami risk";
  }

  String calculateAtmosphericImpact(double blastRadius) {
    if (blastRadius > 200)
      return "🌫 Severe atmospheric disturbance (global cooling)";
    if (blastRadius > 100) return "Moderate dust + climate effects";
    return "Minor atmospheric impact";
  }

  String calculateThermalEffect(double blastRadius) {
    if (blastRadius > 150) return "🔥 Global firestorms possible";
    if (blastRadius > 80) return "Regional thermal radiation damage";
    return "Localized fires near impact site";
  }

  @override
  Widget build(BuildContext context) {
    final magnitude = calculateEarthquakeMagnitude(blastRadius);
    final tsunamiRisk = calculateTsunamiRisk(latitude, longitude);
    final atmosphere = calculateAtmosphericImpact(blastRadius);
    final thermal = calculateThermalEffect(blastRadius);

    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),

        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 22,
        title: Row(
          children: [
            Text(
              "Back",

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            width: 600,
            scale: 0.5,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(height: 30),

                Center(
                  child: Text(
                    'Consequences',
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                _buildCard(
                  "Earthquake",
                  "Magnitude ~ ${magnitude.toStringAsFixed(1)} on Richter scale",
                  Colors.orangeAccent,
                  "warning",
                ),
                SizedBox(height: 30),
                _buildCard(
                  "Tsunami",
                  tsunamiRisk,
                  Colors.lightBlueAccent,
                  "wave",
                ),
                SizedBox(height: 30),
                _buildCard(
                  "Atmosphere",
                  atmosphere,
                  Color(0xff00C951),
                  "lightning",
                ),
                SizedBox(height: 30),
                _buildCard("Thermal", thermal, Colors.redAccent, "fire-flame"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    String title,
    String description,
    Color accent,
    String image,
  ) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          height: 125,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent),
            color: accent.withOpacity(0.3),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/${image}.png',
                      width: 35,
                      height: 35,
                    ),
                    SizedBox(width: 12),
                    Text(
                      title,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  description,
                  style: GoogleFonts.aBeeZee(
                    color: const Color.fromARGB(211, 255, 255, 255),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
