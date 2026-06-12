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

    // ฟังก์ชันสำหรับลงทะเบียนเพิ่มหอพักใหม่เข้าสู่ระบบ
  Future<int> createDormitory(Map<String, dynamic> data) async {
    final response = await _api.post('/api/owner/dormitories', body: data);
    return response['id'];
  }

    // ฟังก์ชันสำหรับแก้ไขข้อมูลหอพัก
  Future<void> updateDormitory(int id, Map<String, dynamic> data) async {
    await _api.patch('/api/owner/dormitories/$id', body: data);
  }

    // ฟังก์ชันสำหรับลบข้อมูลหอพักออกจากระบบ
  Future<void> deleteDormitory(int id) async {
    await _api.delete('/api/owner/dormitories/$id');
  }

    // ฟังก์ชันสำหรับอัปโหลดรูปภาพหน้าปกของหอพัก
  Future<String> uploadDormitoryCoverImage(int dormitoryId, File imageFile) async {
    final response = await _api.multipartPost(
      '/api/owner/dormitories/$dormitoryId/cover-image',
      'coverImage',
      imageFile,
    );
    return response['image']['url'];
  }

  // ฟังก์ชันสำหรับอัปโหลดเอกสารยืนยันตัวตนและหอพัก
  Future<void> uploadVerificationDocuments(int dormitoryId, File ownerIdCard, File dormDocument) async {
    await _api.multiFieldMultipartPost(
      '/api/owner/dormitories/$dormitoryId/verification-documents',
      {
        'ownerIdCard': ownerIdCard,
        'dormDocument': dormDocument,
      },
    );
  }

  // Rooms
    // ฟังก์ชันสำหรับเพิ่มประเภทห้องพักใหม่ในหอพัก
  Future<int> createRoom(int dormitoryId, Map<String, dynamic> data) async {
    final response = await _api.post('/api/owner/dormitories/$dormitoryId/rooms', body: data);
    return response['id'];
  }

    // ฟังก์ชันสำหรับแก้ไขข้อมูลและราคาห้องพัก
  Future<void> updateRoom(int roomId, Map<String, dynamic> data) async {
    await _api.patch('/api/owner/rooms/$roomId', body: data);
  }

    // ฟังก์ชันสำหรับลบประเภทห้องพัก
  Future<void> deleteRoom(int roomId) async {
    await _api.delete('/api/owner/rooms/$roomId');
  }

    // ฟังก์ชันสำหรับอัปโหลดรูปภาพหลายๆ รูปของห้องพัก
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

    // ฟังก์ชันสำหรับอนุมัติคำขอจองห้องพักของผู้เช่า
  Future<void> approveBooking(int bookingId) async {
    await _api.patch('/api/owner/bookings/$bookingId/approve');
  }

    // ฟังก์ชันสำหรับปฏิเสธคำขอจองห้องพัก
  Future<void> rejectBooking(int bookingId) async {
    await _api.patch('/api/owner/bookings/$bookingId/reject');
  }

  // Payment Slips
    // ฟังก์ชันสำหรับตรวจสอบและยืนยันว่าได้รับเงินตามสลิปโอนเงินแล้ว
  Future<void> confirmPaymentSlip(int bookingId, {String? moveInDate}) async {
    final body = <String, dynamic>{
      'status': 'verified',
    };
    if (moveInDate != null) {
      body['move_in_date'] = moveInDate;
    }
    await _api.patch('/api/owner/bookings/$bookingId/payment', body: body);
  }

    // ฟังก์ชันสำหรับปฏิเสธสลิปโอนเงิน (กรณีไม่ถูกต้อง)
  Future<void> rejectPaymentSlip(int bookingId) async {
    await _api.patch('/api/owner/bookings/$bookingId/payment', body: {
      'status': 'rejected',
    });
  }

  // Reviews
    // ฟังก์ชันสำหรับให้เจ้าของหอพักตอบกลับคอมเมนต์รีวิวของผู้เช่า
  Future<void> replyReview(int reviewId, String replyMessage) async {
    await _api.post('/api/owner/reviews/$reviewId/reply', body: {
      'reply': replyMessage,
    });
  }

  // ฟังก์ชันสำหรับรีวิวผู้เช่า
  Future<void> reviewTenant(int tenantId, int dormitoryId, double rating, String comment) async {
    await _api.post('/api/owner/tenants/$tenantId/reviews', body: {
      'dormitoryId': dormitoryId,
      'rating': rating,
      'comment': comment,
    });
  }

  // ดึงข้อมูลรีวิวของผู้เช่า
  Future<List<Map<String, dynamic>>> getTenantReviews(int tenantId) async {
    final response = await _api.get('/api/owner/tenants/$tenantId/reviews');
    return List<Map<String, dynamic>>.from(response['reviews'] ?? []);
  }

  // ดึงรายชื่อผู้เช่าทั้งหมด
  Future<List<Map<String, dynamic>>> getOwnerTenants() async {
    final response = await _api.get('/api/owner/tenants');
    return List<Map<String, dynamic>>.from(response['tenants'] ?? []);
  }
}
