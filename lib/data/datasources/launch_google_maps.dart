import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMap( String startAddress, String destinationAddress,List<Map<String, double>> routeData) async {
    String origin = '${routeData[0]['lat']},${routeData[0]['lng']}';
    String destination = '${routeData[1]['lat']},${routeData[1]['lng']}';
    String waypoints = routeData
        .sublist(2)
        .map((point) => '${point['lat']},${point['lng']}')
        .join('|');

    String url = 'https://www.google.com/maps/dir/?api=1&origin=$startAddress&destination=$destinationAddress&waypoints=$waypoints&travelmode=driving&avoid=highways';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}