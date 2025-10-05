import 'package:asteroid/config/app_color.dart';
import 'package:asteroid/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/latitude_screen.dart';
import 'screens/longitude_screen.dart';
import 'screens/blast_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asteroid Predictor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class PredictionTabs extends StatefulWidget {
  const PredictionTabs({super.key});

  @override
  State<PredictionTabs> createState() => _PredictionTabsState();
}

class _PredictionTabsState extends State<PredictionTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  double? latitudeResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        title: const Text(
          "Asteroid Predictor",
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          labelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: "Latitude"),
            Tab(text: "Longitude"),
            Tab(text: "Blast Radius"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LatitudeScreen(
            onResult: (value) {
              setState(() => latitudeResult = value);
              _tabController.animateTo(1); // Move to Longitude tab
            },
          ),
          LongitudeScreen(latitudeValue: latitudeResult),
          const BlastScreen(),
        ],
      ),
    );
  }
}
