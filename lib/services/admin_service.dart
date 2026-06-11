import '../core/api_client.dart';
import '../models/user.dart';
import '../models/dormitory.dart';
import '../models/booking.dart';

class AdminService {
  final ApiClient _api = ApiClient();

  // Users
  Future<List<User>> getUsers() async {
    final response = await _api.get('/api/admin/users');
    return (response['users'] as List)
        .map((json) => User.fromJson(json))
        .toList();
  }

    // ฟังก์ชันสำหรับอัปเดตสถานะของผู้ใช้งาน เช่น ระงับบัญชี หรือเปิดใช้งาน (สำหรับ Admin)
  Future<void> updateUserStatus(int userId, String status) async {
    await _api.patch('/api/admin/users/$userId/status', body: {
      'status': status,
    });
  }

  // Dormitories
  Future<List<Dormitory>> getPendingDormitories() async {
    final response = await _api.get('/api/admin/dormitories/pending');
    return (response['dormitories'] as List)
        .map((json) => Dormitory.fromJson(json))
        .toList();
  }

    // ฟังก์ชันสำหรับอนุมัติหอพักให้แสดงในระบบ (สำหรับ Admin)
  Future<void> approveDormitory(int id) async {
    await _api.patch('/api/admin/dormitories/$id/approve');
  }

    // ฟังก์ชันสำหรับปฏิเสธการลงทะเบียนหอพักพร้อมระบุเหตุผล (สำหรับ Admin)
  Future<void> rejectDormitory(int id, String reason) async {
    await _api.patch('/api/admin/dormitories/$id/reject', body: {
      'reason': reason,
    });
  }

  // Bookings
  Future<List<Booking>> getBookings() async {
    final response = await _api.get('/api/admin/bookings');
    return (response['bookings'] as List)
        .map((json) => Booking.fromJson(json))
        .toList();
  }

  // Future<void> verifyPayment(int bookingId, String status) async {
  //   await _api.patch('/api/admin/bookings/$bookingId/payment', body: {
  //     'status': status,
  //   });
  // }

  // Reviews
    // ฟังก์ชันสำหรับซ่อนรีวิวที่ไม่เหมาะสม (สำหรับ Admin)
  Future<void> hideReview(int reviewId) async {
    await _api.patch('/api/admin/reviews/$reviewId/hide');
  }
}
