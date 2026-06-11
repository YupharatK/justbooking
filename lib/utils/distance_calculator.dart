import 'package:latlong2/latlong.dart';

class DistanceCalculator {
  // พิกัดมหาวิทยาลัยมหาสารคาม (วิทยาเขตขามเรียง) - สามารถปรับเปลี่ยนได้หากต้องการ
  static const LatLng msuLocation = LatLng(16.2456, 103.2501);

  /// คำนวณระยะห่างด้วย Haversine formula แล้วแปลงเป็นกิโลเมตร
  static double calculateDistanceInKm(double dormLat, double dormLng) {
    const Distance distance = Distance();
    final double meter = distance(msuLocation, LatLng(dormLat, dormLng));
    return meter / 1000.0;
  }
}
