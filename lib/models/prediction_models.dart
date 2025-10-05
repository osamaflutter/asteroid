class LatitudeRequest {
  double eccentricity;
  double semiMajorAxis;
  double inclinationAngle;
  double diameter;

  LatitudeRequest({
    required this.eccentricity,
    required this.semiMajorAxis,
    required this.inclinationAngle,
    required this.diameter,
  });

  Map<String, dynamic> toJson() => {
    "eccentricity": eccentricity,
    "semi_major_axis": semiMajorAxis,
    "inclination_angle": inclinationAngle,
    "diameter": diameter,
  };
}

class LongitudeRequest {
  double eccentricity;
  double semiMajorAxis;
  double velocity;
  double angularVelocity;
  double inclinationAngle;
  double diameter;
  double latitude;

  LongitudeRequest({
    required this.eccentricity,
    required this.semiMajorAxis,
    required this.velocity,
    required this.angularVelocity,
    required this.inclinationAngle,
    required this.diameter,
    required this.latitude,
  });

  Map<String, dynamic> toJson() => {
    "eccentricity": eccentricity,
    "semi_major_axis": semiMajorAxis,
    "velocity": velocity,
    "angular_velocity": angularVelocity,
    "inclination_angle": inclinationAngle,
    "diameter": diameter,
    "latitude": latitude,
  };
}

class BlastRequest {
  double eccentricity;
  double semiMajorAxis;
  double velocity;
  double inclinationAngle;

  BlastRequest({
    required this.eccentricity,
    required this.semiMajorAxis,
    required this.velocity,
    required this.inclinationAngle,
  });

  Map<String, dynamic> toJson() => {
    "eccentricity": eccentricity,
    "semi_major_axis": semiMajorAxis,
    "velocity": velocity,
    "inclination_angle": inclinationAngle,
  };
}
