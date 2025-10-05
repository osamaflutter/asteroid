import 'dart:convert';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class EscapePlanScreen extends StatefulWidget {
  final double userLat;
  final double userLon;
  final double impactLat;
  final double impactLon;
  final double blastRadius; // in km

  const EscapePlanScreen({
    super.key,
    required this.userLat,
    required this.userLon,
    required this.impactLat,
    required this.impactLon,
    required this.blastRadius,
  });

  @override
  State<EscapePlanScreen> createState() => _EscapePlanScreenState();
}

class _EscapePlanScreenState extends State<EscapePlanScreen> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  late LatLng _userPosition;
  late LatLng _impactPoint;
  late LatLng _safeZone;

  @override
  void initState() {
    super.initState();
    _userPosition = LatLng(widget.userLat, widget.userLon);
    _impactPoint = LatLng(widget.impactLat, widget.impactLon);

    // Safe zone point (for example, 2× blast radius away north)
    _safeZone = LatLng(
      widget.impactLat + (widget.blastRadius / 111), // 1 degree ≈ 111 km
      widget.impactLon,
    );

    _setMarkers();
    _getRoute();
  }

  void _setMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('user'),
        position: _userPosition,
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('impact'),
        position: _impactPoint,
        infoWindow: const InfoWindow(title: 'Impact Zone'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('safe'),
        position: _safeZone,
        infoWindow: const InfoWindow(title: 'Safe Zone'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    ]);
  }

  Future<void> _getRoute() async {
    const apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_userPosition.latitude},${_userPosition.longitude}&destination=${_safeZone.latitude},${_safeZone.longitude}&mode=driving&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      final decodedPoints = PolylinePoints.decodePolyline(points);

      final List<LatLng> polylineCoords = decodedPoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.cyanAccent,
            width: 5,
            points: polylineCoords,
          ),
        );
      });
    }
  }

  // Calculate distance (rough estimate using flat Earth model for simplicity)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // km
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // km
  }

  @override
  Widget build(BuildContext context) {
    final distanceFromImpact = calculateDistance(
      widget.userLat,
      widget.userLon,
      widget.impactLat,
      widget.impactLon,
    );

    // If inside blast zone
    final requiredDistance = distanceFromImpact < widget.blastRadius
        ? (widget.blastRadius - distanceFromImpact)
        : 0;

    // Escape assumptions
    const blastWaveTime =
        10.0; // seconds before impact blast reaches ground (dummy)
    const walkingSpeed = 5.0; // km/h
    const runningSpeed = 15.0; // km/h

    final requiredTimeMinutes =
        requiredDistance / runningSpeed * 60; // in minutes
    final requiredVelocity =
        requiredDistance / (blastWaveTime / 3600); // km/h needed
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leadingWidth: 22
        ,
        title: const Text("Back", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
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
                    'Escape plan',
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                _buildCard(
                  "Distance from Impact",
                  "${distanceFromImpact.toStringAsFixed(2)} km away",
                  Colors.cyanAccent,
                  'distance',
                ),
                SizedBox(height: 30),

                _buildCard(
                  "Required Dista to Escape",
                  "${requiredDistance.toStringAsFixed(2)} km",
                  Colors.orangeAccent,
                  'run (1)',
                ),
                SizedBox(height: 30),

                _buildCard(
                  "Required Time to Escape",
                  "${requiredTimeMinutes.toStringAsFixed(1)} minutes (if running)",
                  Colors.lightGreenAccent,
                  'chronometer',
                ),
                SizedBox(height: 30),

                _buildCard(
                  "Required Velocity",
                  "${requiredVelocity.toStringAsFixed(1)} km/h",
                  Colors.redAccent,
                  'speedometer',
                ),

                // 🔹 Your existing UI stays here
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Escape Analysis:\n"
                            "• Required distance and time will be estimated below.\n"
                            "• Map shows the safest route beyond the impact radius.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🗺️ Dark-styled map at bottom
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _userPosition,
                      zoom: 6,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _mapController!.setMapStyle(_darkMapStyle);
                    },
                    markers: _markers,
                    circles: {
                      Circle(
                        circleId: const CircleId('blastRadius'),
                        center: _impactPoint,
                        radius: widget.blastRadius * 1000,
                        fillColor: Colors.red.withOpacity(0.3),
                        strokeColor: Colors.redAccent,
                        strokeWidth: 2,
                      ),
                    },
                    polylines: _polylines,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
  );
}

// 🌙 Custom dark map theme (Google Maps style JSON)
const _darkMapStyle = '''
[
  {"elementType": "geometry","stylers": [{"color": "#242f3e"}]},
  {"elementType": "labels.text.stroke","stylers": [{"color": "#242f3e"}]},
  {"elementType": "labels.text.fill","stylers": [{"color": "#746855"}]},
  {"featureType": "road","elementType": "geometry","stylers": [{"color": "#38414e"}]},
  {"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#746855"}]},
  {"featureType": "water","elementType": "geometry","stylers": [{"color": "#17263c"}]},
  {"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#263c3f"}]},
  {"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#1f2835"}]},
  {"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#9ca5b3"}]},
  {"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},
  {"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#515c6d"}]},
  {"featureType": "water","elementType": "labels.text.stroke","stylers": [{"color": "#17263c"}]}
]
''';
