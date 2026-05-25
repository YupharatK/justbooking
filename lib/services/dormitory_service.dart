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

  Future<Dormitory> getDormitoryDetail(int id) async {
    final response = await _api.get('/api/dormitories/$id', requireAuth: false);
    return Dormitory.fromJson(response['dormitory']);
  }

  // Favorites
  Future<List<Dormitory>> getFavorites() async {
    final response = await _api.get('/api/favorites');
    return (response['favorites'] as List)
        .map((json) => Dormitory.fromJson(json))
        .toList();
  }

  Future<void> addFavorite(int dormitoryId) async {
    await _api.post('/api/favorites/$dormitoryId');
  }

  Future<void> removeFavorite(int dormitoryId) async {
    await _api.delete('/api/favorites/$dormitoryId');
  }

  // Reviews
  Future<void> createReview(int dormitoryId, double rating, String comment) async {
    await _api.post('/api/dormitories/$dormitoryId/reviews', body: {
      'rating': rating,
      'comment': comment,
    });
  }
}
