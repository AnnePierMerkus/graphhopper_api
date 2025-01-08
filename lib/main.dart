import 'package:flutter/material.dart';
import 'package:graphhopper_api/data/datasources/launch_google_maps.dart';
import 'package:graphhopper_api/domain/usecases/calculate_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Open Google Maps')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              List<Map<String, double>> routeData = await GraphHopperAPICall.fetchRouteData();
              MapUtils.openMap(routeData);
            },
            child: Text('Open Route in Google Maps'),
          ),
        ),
      ),
    );
  }
}
