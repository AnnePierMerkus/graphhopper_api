import 'package:flutter/material.dart';
import 'package:graphhopper_api/data/datasources/launch_google_maps.dart';
import 'package:graphhopper_api/domain/usecases/calculate_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController startController;
  late TextEditingController destinationController;

  @override
  void initState() {
    startController = TextEditingController();
    destinationController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    startController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Open Google Maps')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: startController,
                decoration: InputDecoration(
                  labelText: 'Enter Start Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: 'Enter Destination Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String startAddress = startController.text;
                  String destinationAddress = destinationController.text;
                  if (startAddress.isNotEmpty && destinationAddress.isNotEmpty) {
                    List<Map<String, double>> routeData = await GraphHopperAPICall.fetchRouteData(52.3600855,4.9156198, 52.0894311,5.1073394);
                    MapUtils.openMap(startAddress, destinationAddress, routeData);
                  }
                },
                child: Text('Open Route in Google Maps'),
              ),
            ],
          ),
        ),
      ),);
  }
}
