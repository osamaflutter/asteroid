class AsteroidFeatures {
  final double eccentricity;
  final double semiMajorAxis;
  final double inclination;
  final double diameter;

  AsteroidFeatures({
    required this.eccentricity,
    required this.semiMajorAxis,
    required this.inclination,
    required this.diameter,
  });

  Map<String, dynamic> toJson() {
    return {
      "eccentricity": eccentricity,
      "semi_major_axis": semiMajorAxis,
      "inclination": inclination,
      "diameter": diameter,
    };
  }
}

class PredictionResult {
  final double latitude;
  final double longitude;
  final double blastRadius;

  PredictionResult({
    required this.latitude,
    required this.longitude,
    required this.blastRadius,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      blastRadius: (json['blast_radius'] as num).toDouble(),
    );
  }
}
