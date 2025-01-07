import 'package:external_app_launcher/external_app_launcher.dart';

Future<void> openGoogleMaps(String startLat, String startLng, String endLat, String endLng) async {
  try {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving';

    await LaunchApp.openApp(
      androidPackageName: 'com.google.android.apps.maps',
      openStore: false, // Don't redirect to Play Store if not installed
      iosUrlScheme: url,
      // Pass the URL to Google Maps
    );
  } catch (e) {
    print('Error launching Google Maps: $e');
  }
}

void main() {
  openGoogleMaps('52.365760', '4.920020', '52.089444', '5.110278');
}

void launchGoogleMaps() {
  openGoogleMaps('52.365760', '4.920020', '52.089444', '5.110278');

}