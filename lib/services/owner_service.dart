import 'dart:io';
import '../core/api_client.dart';
import '../models/dormitory.dart';
import '../models/room.dart';
import '../models/booking.dart';

class OwnerService {
  final ApiClient _api = ApiClient();

  // Dormitories
  Future<List<Dormitory>> getMyDormitories() async {
    final response = await _api.get('/api/owner/dormitories');
    return (response['dormitories'] as List)
        .map((json) => Dormitory.fromJson(json))
        .toList();
  }

  Future<int> createDormitory(Map<String, dynamic> data) async {
    final response = await _api.post('/api/owner/dormitories', body: data);
    return response['id'];
  }

  Future<void> updateDormitory(int id, Map<String, dynamic> data) async {
    await _api.patch('/api/owner/dormitories/$id', body: data);
  }

  Future<String> uploadDormitoryCoverImage(int dormitoryId, File imageFile) async {
    final response = await _api.multipartPost(
      '/api/owner/dormitories/$dormitoryId/cover-image',
      'coverImage',
      imageFile,
    );
    return response['image']['url'];
  }

  // Rooms
  Future<int> createRoom(int dormitoryId, Map<String, dynamic> data) async {
    final response = await _api.post('/api/owner/dormitories/$dormitoryId/rooms', body: data);
    return response['id'];
  }

  Future<void> updateRoom(int roomId, Map<String, dynamic> data) async {
    await _api.patch('/api/owner/rooms/$roomId', body: data);
  }

  Future<void> uploadRoomImages(int roomId, List<File> imageFiles) async {
    await _api.multiMultipartPost(
      '/api/owner/rooms/$roomId/images',
      'roomImages',
      imageFiles,
    );
  }

  // Bookings
  Future<List<Booking>> getOwnerBookings() async {
    final response = await _api.get('/api/owner/bookings');
    return (response['bookings'] as List)
        .map((json) => Booking.fromJson(json))
        .toList();
  }

  Future<void> updateBookingStatus(int bookingId, String status) async {
    await _api.patch('/api/owner/bookings/$bookingId', body: {
      'status': status,
    });
  }

  // Reviews
  Future<void> replyReview(int reviewId, String replyMessage) async {
    await _api.post('/api/owner/reviews/$reviewId/reply', body: {
      'reply': replyMessage,
    });
  }
}
