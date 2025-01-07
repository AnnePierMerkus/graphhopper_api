import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();


  static Future<void> openMap(double startLat, double startLng, double endLat, double endLng) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=52.36576,4.92002&destination=52.089444,5.110278&travelmode=driving',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }


  // static Future<void> openMap(double startLat, double startLng, double endLat, double endLng) async {
  //   // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  //   final googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving';
  //   if (await canLaunchUrl(Uri.parse(googleUrl))) {
  //     await launchUrl(Uri.parse(googleUrl));
  //   } else {
  //     throw 'Could not open the map.';
  //   }
  // }
}