import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapSearchService {
  /// ค้นหาสถานที่ผ่าน Nominatim API (OpenStreetMap)
  /// ใช้เวลาเรียกใช้งาน ต้องระวังไม่เรียกถี่เกินไปตามข้อกำหนดของ Nominatim (1 request/sec)
  static   // ฟังก์ชันสำหรับค้นหาสถานที่บนแผนที่ด้วยชื่อหรือที่อยู่
  Future<LatLng?> searchPlace(String query) async {
    if (query.trim().isEmpty) return null;

    // จำกัดผลการค้นหาเฉพาะประเทศไทย เพื่อให้ผลลัพธ์แม่นยำขึ้น
    final String url = 'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&countrycodes=th'
        '&limit=1';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent': 'com.example.just_booking/1.0', // Required by Nominatim
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat'].toString());
          final lon = double.tryParse(data[0]['lon'].toString());
          
          if (lat != null && lon != null) {
            return LatLng(lat, lon);
          }
        }
      }
      return null;
    } catch (e) {
      print('Error searching place: $e');
      return null;
    }
  }
}
