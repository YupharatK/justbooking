import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapConstants {
  // Mahasarakham University (Khamriang Campus) Location
  static const LatLng msuLocation = LatLng(16.2456, 103.2501);

  // Default Zoom Level
  static const double defaultZoom = 15.0;

  // OpenStreetMap Tile URL
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgent = 'com.example.just_booking'; // Update this if app package name changes

  // Map Bounds for Mahasarakham Province Area (approximate)
  // This prevents users from panning too far away from the university/province.
  static final LatLngBounds mahasarakhamBounds = LatLngBounds(
    const LatLng(15.5000, 102.8000), // South-West point
    const LatLng(16.6000, 103.5000), // North-East point
  );
}
