import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/owner_service.dart';
import '../models/booking.dart';
import '../services/notification_service.dart';
import '../core/localization/localization_extension.dart';

/// ----------------------------------------------------------------------
/// [OwnerBookingDashboard]
/// ฟีเจอร์: "หน้าจัดการคำขอจองสำหรับเจ้าของหอพัก"
/// หน้านี้ใช้สำหรับแสดงรายการคำขอจองห้องพัก (Bookings) ที่ผู้ใช้ส่งเข้ามาทั้งหมด
/// เจ้าของสามารถเรียกดูรูปภาพสลิปที่ผู้ใช้อัปโหลดมา และกด "อนุมัติ" (Approve) 
/// หรือ "ปฏิเสธ" (Reject) เพื่อเปลี่ยนสถานะคำขอในระบบ
/// 
/// การเชื่อมต่อ API หลักในหน้านี้:
/// - OwnerService.getOwnerBookings() -> ดึงรายการคำขอจองทั้งหมดของเจ้าของหอพักคนนี้
/// - OwnerService.approveBooking() / rejectBooking() -> ยิง API เพื่ออัปเดตสถานะเป็น 'pending_payment' หรือ 'rejected'
/// ----------------------------------------------------------------------

/// หน้าแสดงรายการคำขอจองห้องพักทั้งหมด เพื่อให้เจ้าของหอพักพิจารณาอนุมัติหรือปฏิเสธ

class OwnerBookingDashboard extends StatefulWidget {
  const OwnerBookingDashboard({super.key});

  @override
  State<OwnerBookingDashboard> createState() => _OwnerBookingDashboardState();
}

class _OwnerBookingDashboardState extends State<OwnerBookingDashboard> {
  final OwnerService _ownerService = OwnerService();
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  // ฟังก์ชันดึงรายการคำขอจองห้องพักทั้งหมดของหอพักตนเอง

  Future<void> _fetchBookings() async {
    try {
      final bookings = await _ownerService.getOwnerBookings();
      if (mounted) {
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.ownerBookingFetchError)),
        );
      }
    }
  }

  Future<void> _updateStatus(int bookingId, int userId, String status) async {
    try {
      if (status == 'approved') {
        await _ownerService.approveBooking(bookingId);
        try {
          await NotificationService().createApprovalNotification(userId);
        } catch (e) {
          debugPrint('Notification Error: $e');
        }
      } else {
        await _ownerService.rejectBooking(bookingId);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.ownerBookingUpdateSuccess, style: TextStyle()), backgroundColor: Colors.green),
      );
      _fetchBookings(); // Refresh
    } catch (e) {
      debugPrint('Error updateStatus: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.l10n.ownerBookingUpdateError}${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F6DE3);
    const bgColor = Color(0xFFF8F9FB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.l10n.ownerBookingTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _bookings.isEmpty
              ? Center(
                  child: Text(
                    context.l10n.ownerBookingEmpty,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchBookings,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      final booking = _bookings[index];
                      return _buildBookingCard(booking, primaryColor);
                    },
                  ),
                ),
    );
  }

  Widget _buildBookingCard(Booking booking, Color primaryColor) {
    final bool isPending = booking.status == 'pending_owner_approval';
    final user = booking.user;
    final room = booking.room;
    final dorm = booking.dormitory;

    bool isPaymentExpired = false;
    if (booking.status == 'pending_payment' && booking.paymentSlipUrl == null && booking.paymentStatus != 'submitted') {
      try {
        final createdAt = DateTime.parse(booking.createdAt).toLocal();
        if (DateTime.now().isAfter(createdAt.add(const Duration(minutes: 15)))) {
          isPaymentExpired = true;
        }
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รหัสการจอง #${booking.id}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPaymentExpired ? 'หมดเวลาชำระเงิน' : booking.status.translateBookingStatus(context),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPaymentExpired ? Colors.red : _getStatusColor(booking.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user?.profileImageUrl != null && user!.profileImageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user.profileImageUrl!),
                    onBackgroundImageError: (_, __) {},
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.l10n.ownerBookingTenant}${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    if (user?.nickname != null && user!.nickname!.isNotEmpty)
                      Text('ชื่อเล่น: ${user.nickname}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700))
                    else
                      Text('ชื่อเล่น: -', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                    const SizedBox(height: 4),
                    
                    if (user?.phone != null && user!.phone!.isNotEmpty)
                      Text('${context.l10n.ownerBookingPhone}${user.phone}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700))
                    else
                      Text('${context.l10n.ownerBookingPhone}-', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                    const SizedBox(height: 2),
                    
                    if (user?.address != null && user!.address!.isNotEmpty)
                      Text('${context.l10n.ownerBookingAddress}${user.address}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700))
                    else
                      Text('${context.l10n.ownerBookingAddress}-', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                    const SizedBox(height: 2),
                    
                    if (user?.email != null && user!.email.isNotEmpty)
                      Text('${context.l10n.ownerBookingEmail}${user.email}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700))
                    else
                      Text('${context.l10n.ownerBookingEmail}-', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                    const SizedBox(height: 4),
                    if (user?.averageRating != null && user!.reviewCount != null && user!.reviewCount! > 0)
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${user.averageRating!.toStringAsFixed(1)} (${user.reviewCount} รีวิว)',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showTenantReviewsDialog(user.id, user.firstName ?? ''),
                            child: const Text('ดูประวัติรีวิวผู้เช่า', style: TextStyle(fontSize: 13, color: Color(0xFF4274E6), decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          const Text('ยังไม่มีคะแนนรีวิว', style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showTenantReviewsDialog(user?.id ?? 0, user?.firstName ?? ''),
                            child: const Text('ดูประวัติรีวิวผู้เช่า', style: TextStyle(fontSize: 13, color: Color(0xFF4274E6), decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${context.l10n.ownerBookingDorm}${dorm?.name ?? ''} | ${context.l10n.ownerBookingRoom}${room?.roomNumber ?? ''}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${context.l10n.ownerBookingDate}${booking.createdAt}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          if (isPaymentExpired) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ผู้เช่าไม่ได้ชำระเงินภายใน 15 นาที ระบบหมดอายุการจองอัตโนมัติ',
                      style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (booking.paymentSlipUrl != null) ...[
            const SizedBox(height: 12),
            Text(context.l10n.ownerBookingSlip, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _showImageDialog(booking.paymentSlipUrl!);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  booking.paymentSlipUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (isPending) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _showConfirmDialog(booking.id, booking.userId, 'rejected'),
                    child: Text(context.l10n.ownerBookingReject, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _showConfirmDialog(booking.id, booking.userId, 'approved'),
                    child: Text(context.l10n.ownerBookingApprove, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ] else if (booking.status == 'pending_payment_verification' || (booking.status == 'pending_payment' && (booking.paymentStatus == 'submitted' || booking.paymentSlipUrl != null))) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _showConfirmSlipDialog(booking.id, booking.userId, 'rejected'),
                    child: Text(context.l10n.ownerBookingRejectSlip, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _handleVerifySlipDatePicker(booking.id, booking.userId),
                    child: Text(context.l10n.ownerBookingVerifySlip, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ] else if (booking.status == 'completed') ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4274E6),
                  side: const BorderSide(color: Color(0xFF4274E6)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.star_rate_rounded),
                label: const Text('รีวิวผู้เช่า', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => _showReviewTenantDialog(booking.userId, dorm?.id ?? 0),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showConfirmDialog(int bookingId, int userId, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.ownerBookingConfirmTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          status == 'approved' ? context.l10n.ownerBookingConfirmApprove : context.l10n.ownerBookingConfirmReject,
          style: const TextStyle(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.ownerBookingCancel, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(bookingId, userId, status);
            },
            child: Text(
              context.l10n.ownerBookingConfirmTitle,
              style: TextStyle(
                color: status == 'approved' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmSlipDialog(int bookingId, int userId, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.ownerBookingConfirmSlipTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          action == 'verified' ? context.l10n.ownerBookingConfirmSlipVerify : context.l10n.ownerBookingConfirmSlipReject,
          style: const TextStyle(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.ownerBookingCancel, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateSlipStatus(bookingId, userId, action);
            },
            child: Text(
              context.l10n.ownerBookingConfirmTitle,
              style: TextStyle(
                color: action == 'verified' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleVerifySlipDatePicker(int bookingId, int userId) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      helpText: 'เลือกวันที่สามารถเข้าอยู่ได้',
      cancelText: 'ยกเลิก',
      confirmText: 'ตกลง',
    );

    if (pickedDate == null) return; // User cancelled

    final thaiMonths = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    final displayDateStr = '${pickedDate.day} ${thaiMonths[pickedDate.month - 1]} ${pickedDate.year + 543}';

    if (!mounted) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการตั้งค่าวันเข้าอยู่', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('ยืนยันสลีปและกำหนดวันเข้าอยู่ $displayDateStr ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.ownerBookingCancel, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              context.l10n.ownerBookingConfirmTitle,
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final String apiDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _updateSlipStatus(bookingId, userId, 'verified', moveInDate: apiDate, displayDateStr: displayDateStr);
    }
  }

  Future<void> _updateSlipStatus(int bookingId, int userId, String action, {String? moveInDate, String? displayDateStr}) async {
    try {
      if (action == 'verified') {
        await _ownerService.confirmPaymentSlip(bookingId, moveInDate: moveInDate);
        if (displayDateStr != null) {
          try {
            await NotificationService().createSlipVerifiedNotification(userId, displayDateStr);
          } catch (e) {
            debugPrint('Notification Error: $e');
          }
        }
      } else {
        await _ownerService.rejectPaymentSlip(bookingId);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.ownerBookingSlipUpdateSuccess, style: TextStyle()),
          backgroundColor: Colors.green,
        ),
      );
      _fetchBookings(); // Refresh
    } catch (e) {
      debugPrint('Error updateSlipStatus: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.l10n.ownerBookingUpdateError}${e.toString()}')),
      );
    }
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 1.0,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.white,
                    child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewTenantDialog(int tenantId, int dormitoryId) {
    double rating = 5.0;
    final TextEditingController commentController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('รีวิวผู้เช่า', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('ให้คะแนนผู้เช่า', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 36,
                        ),
                        onPressed: () {
                          setModalState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text('ความคิดเห็น (ไม่บังคับ)', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'อธิบายประสบการณ์การให้เช่าของคุณ...',
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF4274E6)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4274E6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              setModalState(() => isSubmitting = true);
                              try {
                                await _ownerService.reviewTenant(tenantId, dormitoryId, rating, commentController.text.trim());
                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('ส่งรีวิวผู้เช่าสำเร็จ')),
                                  );
                                }
                              } catch (e) {
                                setModalState(() => isSubmitting = false);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                                  );
                                }
                              }
                            },
                      child: isSubmitting
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('ส่งรีวิว', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTenantReviewsDialog(int tenantId, String tenantName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('ประวัติการเช่าของ $tenantName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _ownerService.getTenantReviews(tenantId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                }
                final reviews = snapshot.data ?? [];
                if (reviews.isEmpty) {
                  return const Center(child: Text('ผู้เช่ารายนี้ยังไม่เคยได้รับรีวิว', style: TextStyle(color: Colors.black54)));
                }

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review['dormitory_name'] ?? 'ไม่ทราบหอพัก',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    review['rating']?.toString() ?? '0',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (review['comment'] != null && review['comment'].toString().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              review['comment'],
                              style: const TextStyle(color: Colors.black87, fontSize: 13),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            'โดย ${review['owner_first_name']} ${review['owner_last_name']} - ${review['created_at'].toString().split('T')[0]}',
                            style: const TextStyle(color: Colors.black45, fontSize: 11),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ปิด', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
      case 'confirmed':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      case 'pending_payment':
      case 'pending_payment_verification':
        return Colors.blue;
      case 'pending_owner_approval':
      default:
        return const Color(0xFFF97316);
    }
  }
}
