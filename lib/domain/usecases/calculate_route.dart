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
    final String url =
        "$baseUrl?key=$apiKey&point=52.365760,4.920020&point=52.089444,5.110278"
        "&type=json&profile=scooter&maxspeed=60&calc_points=true&instructions=true&algorithm=astar&ch.disable=true";

    try {
      print("URL STUFF");
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, double>> decodedPolyline = decodePolyline(data["paths"][0]["points"]);
        print("API Response: $decodedPolyline");
      } else {
        print("Failed to fetch route data: ${response.statusCode}");
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
