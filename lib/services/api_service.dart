import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<double?> predictLatitude(
    double ecc,
    double axis,
    double incl,
    double diam,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict_latitude"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "eccentrity": ecc,
        "semi_major_axis": axis,
        "inclination_angle": incl,
        "diameter": diam,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["latitude"];
    }
    return null;
  }

  static Future<double?> predictLongitude(
    double ecc,
    double axis,
    double vel,
    double angVel,
    double incl,
    double diam,
    double latitude,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict_longitude"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "eccentrity": ecc,
        "semi_major_axis": axis,
        "velocity": vel,
        "angular_velocity": angVel,
        "inclination_angle": incl,
        "diameter": diam,
        "latitude": latitude,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["longitude"];
    }
    return null;
  }

  static Future<double?> predictBlast(
    double ecc,
    double axis,
    double vel,
    double incl,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict_blast"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "eccentrity": ecc,
        "semi_major_axis": axis,
        "velocity": vel,
        "inclination_angle": incl,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["blast_radius"];
    }
    return null;
  }
}
