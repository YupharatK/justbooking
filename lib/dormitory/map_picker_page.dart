import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final MapController _mapController = MapController();
  
  // Default to a central location in Thailand if none provided.
  late LatLng _center;

  @override
  void initState() {
    super.initState();
    _center = widget.initialLocation ?? const LatLng(13.7563, 100.5018); // Bangkok
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกพิกัดหอพัก', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
              onPositionChanged: (MapCamera camera, bool hasGesture) {
                setState(() {
                  _center = camera.center;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.just_booking', 
              ),
            ],
          ),
          // Center Marker (a fixed pin over the map)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0), // Offset to make pin tip point exactly to the center
              child: Icon(
                Icons.location_on,
                size: 50,
                color: Colors.red.shade600,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
          // Confirm Button
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF3F6DE3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              onPressed: () {
                Navigator.pop(context, _center);
              },
              child: const Text(
                'ยืนยันตำแหน่งนี้',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
