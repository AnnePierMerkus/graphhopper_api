import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double startLat, double startLng, double endLat, double endLng) async {
    final String url = 'https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&travelmode=driving&dir_action=navigate';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }

  }

}