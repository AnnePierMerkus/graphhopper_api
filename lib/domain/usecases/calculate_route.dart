import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GraphHopperAPICall {
  GraphHopperAPICall._();

  static Future<List<Map<String, double>>> fetchRouteData(double startLat, double startLng, double destinationLat, double destinationLng) async {
    final String apiKey = "";
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
        'max_speed',
      ],
    };

    Map<String, dynamic> payload = {
      'points': [
        [startLng, startLat], // origin
        [destinationLng, destinationLat], // destination
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


    final url = "$baseUrl?key=$apiKey";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, double>> decodedPolyline =
            decodePolyline(data["paths"][0]["points"]);

        var speedLimits = data["paths"][0]["details"]["max_speed"];

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
        List<Map<String, double>> pointsList = [];

        pointsList.add(decodedPolyline[speedLimits[0][0]]);
        pointsList.add(decodedPolyline[speedLimits[length -1][1]]);
        for (int i in selectedIndices) {
          var segment = speedLimits[i];
          var fromIndex = segment[0];
          pointsList.add(decodedPolyline[fromIndex]);
        }
        return pointsList;
      } else {
        print("Failed to fetch route data: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }

    return [];
  }

  static List<Map<String, double>> decodePolyline(String encoded) {
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
}
