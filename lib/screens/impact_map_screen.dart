import 'dart:async';
import 'dart:math';
import 'package:asteroid/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ImpactMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double blastRadius; // km
  final double semiMajorAxis; // AU
  final double eccentricity;
  final double inclination; // deg

  const ImpactMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.blastRadius,
    required this.semiMajorAxis,
    required this.eccentricity,
    required this.inclination,
  });

  @override
  State<ImpactMapScreen> createState() => _ImpactMapScreenState();
}

class _ImpactMapScreenState extends State<ImpactMapScreen> {
  GoogleMapController? mapController;
  List<LatLng> trajectoryPoints = [];
  int currentStep = 0;

  double animatedBlastRadius = 0; // meters
  Color blastColor = AppColors.blastOuter;
  Timer? timer;

  double speed = 1.0; // 1x speed
  int baseDuration = 100; // milliseconds per step

  @override
  void initState() {
    super.initState();
    setupSimulation();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void setupSimulation() {
    trajectoryPoints = computeKeplerianTrajectory(
      semiMajorAxis: widget.semiMajorAxis,
      eccentricity: widget.eccentricity,
      inclination: widget.inclination,
      impactPoint: LatLng(widget.latitude, widget.longitude),
    );
    currentStep = 0;
    animatedBlastRadius = 0;
    blastColor = AppColors.blastOuter;
    animateTrajectory();
  }

  // Keplerian trajectory
  List<LatLng> computeKeplerianTrajectory({
    required double semiMajorAxis,
    required double eccentricity,
    required double inclination,
    required LatLng impactPoint,
    int steps = 100,
  }) {
    List<LatLng> points = [];
    double radIncl = inclination * pi / 180;

    for (int t = 0; t <= steps; t++) {
      double theta = t / steps * pi; // 0 → 180 degrees

      double r =
          semiMajorAxis *
          (1 - pow(eccentricity, 2)) /
          (1 + eccentricity * cos(theta));

      double xOrb = r * cos(theta);
      double yOrb = r * sin(theta);

      double yRot = yOrb * cos(radIncl);
      double zRot = yOrb * sin(radIncl);

      double lat = impactPoint.latitude + yRot / 100;
      double lng = impactPoint.longitude + xOrb / 100;

      points.add(LatLng(lat, lng));
    }

    return points;
  }

  void animateTrajectory() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: (baseDuration ~/ speed)), (
      t,
    ) {
      setState(() {
        if (currentStep < trajectoryPoints.length - 1) {
          currentStep++;
        } else {
          timer?.cancel();
          zoomToImpact();
          animateBlast();
        }
      });
    });
  }

  void zoomToImpact() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 9,
          ),
        ),
      );
    }
  }

  void animateBlast() {
    double targetRadius = widget.blastRadius * 1000;
    double step = targetRadius / 50;
    timer = Timer.periodic(const Duration(milliseconds: 50), (blastTimer) {
      setState(() {
        if (animatedBlastRadius < targetRadius) {
          animatedBlastRadius += step;
          double t = animatedBlastRadius / targetRadius;
          blastColor = Color.lerp(
            AppColors.blastOuter,
            AppColors.blastInner,
            t,
          )!;
        } else {
          animatedBlastRadius = targetRadius;
          blastColor = AppColors.blastInner;
          blastTimer.cancel();
        }
      });
    });
  }

  void replaySimulation() {
    setupSimulation();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng impactPoint = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Asteroid Collision Simulation",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: impactPoint,
                zoom: 4,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("impact"),
                  position: impactPoint,
                  infoWindow: const InfoWindow(title: "Impact Point"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
                Marker(
                  markerId: const MarkerId("asteroid"),
                  position: trajectoryPoints[currentStep],
                  infoWindow: const InfoWindow(title: "Asteroid"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("trajectory"),
                  points: trajectoryPoints,
                  color: AppColors.trajectory,
                  width: 2,
                ),
              },
              circles: {
                Circle(
                  circleId: const CircleId("blastRadius"),
                  center: impactPoint,
                  radius: animatedBlastRadius,
                  strokeWidth: 2,
                  strokeColor: blastColor,
                  fillColor: blastColor.withOpacity(0.3),
                ),
              },
              onMapCreated: (controller) => mapController = controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surface,
              ),
              child: Column(
                children: [
                  const Text(
                    "Adjust Asteroid Speed",
                    style: TextStyle(color: Colors.white),
                  ),
                  Slider(
                    value: speed,
                    min: 0.1,
                    max: 5.0,
                    divisions: 49,
                    label: "${speed.toStringAsFixed(1)}x",
                    onChanged: (value) {
                      setState(() {
                        speed = value;
                        animateTrajectory();
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: replaySimulation,
                    child: const Text("Replay Simulation"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
