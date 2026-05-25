import '../core/api_client.dart';
import '../models/booking.dart';

class BookingService {
  final ApiClient _api = ApiClient();

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

  Future<void> submitPaymentSlip(int bookingId, String slipImageUrl) async {
    await _api.post('/api/bookings/$bookingId/payment-slip', body: {
      'slipImageUrl': slipImageUrl,
    });
  }
}
