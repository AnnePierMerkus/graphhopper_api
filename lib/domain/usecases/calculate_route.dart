import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GraphHopperAPICall {
  GraphHopperAPICall._();

  static Future<List<Map<String, double>>> fetchRouteData(double startLat, double startLng, double destinationLat, double destinationLng) async {
    final String apiKey = "354228c0-cdd7-4c72-b31a-915f297cf782";
    final String baseUrl = "https://graphhopper.com/api/1/route";

    Map<String, dynamic> customModel = {
      'priority': [
        {
          'if': 'max_speed > 60',
          'multiply_by': 0,
        },
      ]
    };

    Map<String, dynamic> payload = {
      'points': [
        [startLng, startLat], // origin
        [destinationLng, destinationLat], // destination
      ],
      'custom_model': customModel,
      'profile': 'car',
      'locale': 'en',
      'instructions': true,
      'calc_points': true,
      'points_encoded': true,
      'ch.disable': true,
      'details': ['max_speed'],
      'snap_preventions': [
        'motorway',
        'tunnel'
      ]
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
        int numPoints = (length - 2) > 8 ? 8 : length - 2;
        double interval = (length - 2) / numPoints;

        List<int> selectedIndices = [];
        for (int i = 1; i <= numPoints; i++) {
          int index = (interval * i).round();
          selectedIndices.add(index);
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
