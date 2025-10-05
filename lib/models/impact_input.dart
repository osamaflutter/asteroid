class ImpactInput {
  final double asteroidDiameter;
  final double velocity;
  final double density;
  final double angle;

  ImpactInput({
    required this.asteroidDiameter,
    required this.velocity,
    required this.density,
    required this.angle,
  });

  Map<String, dynamic> toJson() {
    return {
      "asteroid_diameter": asteroidDiameter,
      "velocity": velocity,
      "density": density,
      "angle": angle,
    };
  }
}
