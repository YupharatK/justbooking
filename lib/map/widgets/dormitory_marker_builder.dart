import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/dormitory.dart';

class DormitoryMarkerBuilder {
  /// สร้างหมุดสำหรับมหาวิทยาลัย
  static Marker buildUniversityMarker(LatLng location) {
    return Marker(
      point: location,
      width: 60.0,
      height: 60.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 24,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3F6DE3).withOpacity(0.9), // Primary color
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// สร้างหมุดสำหรับหอพัก
  static Marker buildDormitoryMarker(
    Dormitory dorm, {
    required VoidCallback onTap,
  }) {
    return Marker(
      point: LatLng(dorm.latitude, dorm.longitude),
      width: 45.0,
      height: 45.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red.shade400, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.apartment_rounded,
            color: Colors.red.shade400,
            size: 20,
          ),
        ),
      ),
    );
  }
}
