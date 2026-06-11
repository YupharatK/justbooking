import 'dart:io';
import '../core/api_client.dart';
import '../models/booking.dart';

class BookingService {
  final ApiClient _api = ApiClient();

    // ฟังก์ชันสำหรับส่งคำขอจองห้องพักไปยังเจ้าของหอพัก
  Future<int> createBooking({
    required int roomId,
    required String moveInDate,
    String? note,
  }) async {
    final response = await _api.post('/api/bookings', body: {
      'roomId': roomId,
      'moveInDate': moveInDate,
      if (note != null) 'note': note,
    });
    return response['bookingId'];
  }

  Future<List<Booking>> getMyBookings() async {
    final response = await _api.get('/api/bookings');
    return (response['bookings'] as List)
        .map((json) => Booking.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> submitPaymentSlip(int bookingId, File imageFile) async {
    final response = await _api.multipartPost(
      '/api/bookings/$bookingId/payment-slip',
      'slipImage',
      imageFile,
    );
    return response;
  }
}
