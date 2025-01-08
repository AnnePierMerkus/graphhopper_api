import 'package:flutter/material.dart';
import 'package:graphhopper_api/data/datasources/app_launcher.dart';
import 'package:graphhopper_api/data/datasources/launch_google_maps.dart';
import 'package:graphhopper_api/domain/usecases/calculate_route.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Open Google Maps')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               MapUtils.openMap(52.365760, 4.920020, 52.089444, 5.110278);
//             },
//             child: Text('Open Route in Google Maps'),
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Call Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ApiCallScreen(), // Set ApiCallScreen as the home screen
    );
  }
}
