import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiCallScreen extends StatefulWidget {
  @override
  _ApiCallScreenState createState() => _ApiCallScreenState();
}

class _ApiCallScreenState extends State<ApiCallScreen> {

  Future<void> _fetchRouteData() async {
    final String apiKey = "02a1c92a-cd2e-460d-8125-7ccfe7ab4ad3";
    final String baseUrl = "https://graphhopper.com/api/1/route";

    // Define the params and customModel
    Map<String, dynamic> params = {
      'vehicle': 'car',
      'locale': 'en',
      'instructions': true,
      'calc_points': true,
    };

    Map<String, dynamic> customModel = {
      'priority': [
        {
          'if': 'max_speed > 60',
          'multiply_by': 0,
        },
      ],
      'snap_preventions': [
        'motorway',
        'ferry',
        'tunnel',
      ],
      'details': [
        'road_class',
        'surface',
        'max_speed',  // Ensure 'max_speed' is included in details
      ],
    };

    // Prepare the payload, without the API key
    Map<String, dynamic> payload = {
      'points': [
        [4.920020, 52.365760],  // origin
        [5.110278, 52.089444],  // destination
      ],
      'custom_model': customModel,
      'profile': params['vehicle'],
      'locale': params['locale'],
      'instructions': params['instructions'],
      'calc_points': params['calc_points'],
      'points_encoded': true,
      'ch.disable': true,
      'details': ['max_speed'],
    };

    // Log the payload before sending
    print("Payload: ${json.encode(payload)}");

    // Send the POST request with the API key in the URL
    final url = "$baseUrl?key=$apiKey";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, double>> decodedPolyline = decodePolyline(data["paths"][0]["points"]);

        // Extract speed limits and log the details
        var speedLimits = data["paths"][0]["details"]["max_speed"];

        print(speedLimits.length / 8);
        int length = speedLimits.length;
        int numPoints = 8;
        double interval = (length - 2) / numPoints;

        List<int> selectedIndices = [];
        for (int i = 1; i <= numPoints; i++) {
          int index = (interval * i).round();
          selectedIndices.add(index);
        }
        if (interval == 0) {
          interval = 1;
        }

        print(length);
        print(interval);
        print(selectedIndices);
        for (int i in selectedIndices) {

          var segment = speedLimits[i];
          var fromIndex = segment[0];
          var toIndex = segment[1];
          var speedLimit = segment[2];

          // Fetch the corresponding lat and lng values
          var startPoint = decodedPolyline[fromIndex]['lat'];
          var endPoint = decodedPolyline[fromIndex]['lng'];

          // Log the segment information
          print("Segment from $fromIndex to $toIndex:");
          print("Start Point: $startPoint, End Point: $endPoint");
          print("Speed Limit: $speedLimit km/h");
        };

        print("API Response: $decodedPolyline");
      } else {
        print("Failed to fetch route data: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  List<Map<String, double>> decodePolyline(String encoded) {
    List<Map<String, double>> coordinates = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int byte;
      int shift = 0;
      int result = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      coordinates.add({'lat': lat / 1E5, 'lng': lng / 1E5});
    }

    return coordinates;
  }

  @override
  void initState() {
    super.initState();
    _fetchRouteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Call Example")),
      body: Center(
        child: Text("Check the console for API response."),
      ),
    );
  }
}
