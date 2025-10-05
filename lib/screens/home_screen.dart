import 'package:asteroid/config/app_color.dart';
import 'package:asteroid/main.dart';
import 'package:asteroid/models/prediction_data.dart';
import 'package:asteroid/screens/consequences_screen.dart';
import 'package:asteroid/screens/escape_plan_screen.dart';
import 'package:asteroid/widgets/Cardd.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? userLat;
  double? userLon;
  bool loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => loadingLocation = false);
      return;
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => loadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => loadingLocation = false);
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      userLat = position.latitude;
      userLon = position.longitude;
      loadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/background.png',
              width: 600,
              fit: BoxFit.cover,
            ),
            loadingLocation
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xff00D3F2), Color(0xffFB64B6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                'Asteroid World',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PredictionTabs(),
                                ),
                              );
                            },
                            child: Cardd(
                              label: 'Collision Simulation',
                              text: 'AI for Predicting Impacts',
                              imageText: 'assets/images/collision.png',
                              isRow: true,
                              padd: 20,
                            ),
                          ),
                          const SizedBox(height: 50),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConsequencesScreen(
                                    latitude: PredictionData.latitude ?? 30,
                                    longitude: PredictionData.longitude ?? 31,
                                    blastRadius:
                                        PredictionData.blastRadius ?? 120,
                                  ),
                                ),
                              );
                            },
                            child: Cardd(
                              label: 'The Consequence on Earth',
                              text: 'The Consequences',
                              imageText: 'assets/images/volcano.png',
                              isRow: false,
                              padd: 250,
                            ),
                          ),
                          const SizedBox(height: 50),
                          InkWell(
                            onTap: userLat == null || userLon == null
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EscapePlanScreen(
                                          userLat: userLat!,
                                          userLon: userLon!,
                                          impactLat:
                                              PredictionData.latitude ?? 30,
                                          impactLon:
                                              PredictionData.longitude ?? 31,
                                          blastRadius:
                                              PredictionData.blastRadius ?? 120,
                                        ),
                                      ),
                                    );
                                  },
                            child: Cardd(
                              label: 'Escape Plan',
                              text: 'How to survive the impact',
                              imageText: 'assets/images/escape.png',
                              isRow: true,
                              padd: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
