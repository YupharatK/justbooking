import '../core/api_client.dart';
import '../models/dormitory.dart';
import '../models/review.dart';

class DormitoryService {
  final ApiClient _api = ApiClient();

  Future<List<Dormitory>> searchDormitories({
    String? search,
    double? maxDistance,
    double? minPrice,
    double? maxPrice,
    String? roomType,
  }) async {
    final queryParams = <String>[];
    if (search != null) queryParams.add('search=$search');
    if (maxDistance != null) queryParams.add('maxDistance=$maxDistance');
    if (minPrice != null) queryParams.add('minPrice=$minPrice');
    if (maxPrice != null) queryParams.add('maxPrice=$maxPrice');
    if (roomType != null) queryParams.add('roomType=$roomType');

    final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    final response = await _api.get('/api/dormitories$queryString', requireAuth: false);
    
    return (response['dormitories'] as List)
        .map((json) => Dormitory.fromJson(json))
        .toList();
  }

    // ฟังก์ชันสำหรับดึงรายละเอียดแบบเจาะลึกของหอพักและห้องพักทั้งหมด
  Future<Dormitory> getDormitoryDetail(int id) async {
    final response = await _api.get('/api/dormitories/$id', requireAuth: false);
    final dormJson = response['dormitory'] as Map<String, dynamic>;
    if (response['rooms'] != null) {
      dormJson['rooms'] = response['rooms'];
    }
    if (response['reviews'] != null) {
      dormJson['reviews'] = response['reviews'];
    }
    return Dormitory.fromJson(dormJson);
  }

  // Favorites
  Future<List<Dormitory>> getFavorites() async {
    final response = await _api.get('/api/favorites');
    return (response['favorites'] as List)
        .map((json) => Dormitory.fromJson(json))
        .toList();
  }

    // ฟังก์ชันสำหรับกดหัวใจ (บันทึก) หอพักลงในรายการโปรด
  Future<void> addFavorite(int dormitoryId) async {
    await _api.post('/api/favorites/$dormitoryId');
  }

    // ฟังก์ชันสำหรับยกเลิกการบันทึกหอพักออกจากรายการโปรด
  Future<void> removeFavorite(int dormitoryId) async {
    await _api.delete('/api/favorites/$dormitoryId');
  }

  // Reviews
    // ฟังก์ชันสำหรับเขียนรีวิวและให้คะแนนหอพัก
  Future<void> createReview(int dormitoryId, double rating, String comment) async {
    await _api.post('/api/dormitories/$dormitoryId/reviews', body: {
      'rating': rating,
      'comment': comment,
    });
  }
}
