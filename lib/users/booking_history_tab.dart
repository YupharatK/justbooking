import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../models/booking.dart';
import 'booking_detail_page.dart';
import '../core/localization/localization_extension.dart';
import '../services/pdf_service.dart';

/// หน้าแสดงประวัติการจองห้องพักทั้งหมดของผู้ใช้งาน พร้อมบอกสถานะการจอง

class BookingHistoryTab extends StatefulWidget {
  const BookingHistoryTab({super.key});

  @override
  State<BookingHistoryTab> createState() => _BookingHistoryTabState();
}

class _BookingHistoryTabState extends State<BookingHistoryTab> {
  final BookingService _bookingService = BookingService();
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  String? _errorMessage;

  // ฟังก์ชันดึงประวัติการจองทั้งหมดของผู้ใช้

  // ฟังก์ชันนี้จะติดต่อกับ API ผ่าน BookingService เพื่อดึงข้อมูลการจองทั้งหมดของผู้ใช้
  // และทำการจัดการสถานะ (State) ว่ากำลังโหลด (isLoading) หรือเกิดข้อผิดพลาด (errorMessage)
  Future<void> _fetchBookings() async {
    try {
      // ดึงข้อมูลการจองจากฐานข้อมูลผ่าน Service
      final bookings = await _bookingService.getMyBookings();
      if (mounted) {
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  // ฟังก์ชัน build คือส่วนที่ใช้สร้างหน้าจอ UI (User Interface) ทั้งหมดของหน้านี้
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4274E6);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.bookingHistoryTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.bookingHistorySubtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          
          // ตรวจสอบสถานะ หากกำลังโหลด (_isLoading = true) ให้แสดงวงกลมหมุน (CircularProgressIndicator)
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            )
          // หากเกิดข้อผิดพลาดในการโหลดข้อมูล ให้แสดงข้อความแจ้งเตือน (Error Message)
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade300, size: 64),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 13
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          // หากดึงข้อมูลสำเร็จแต่ไม่มีประวัติการจองเลย ให้แสดงหน้าจอว่างเปล่า (Empty State)
          else if (_bookings.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_outlined, color: Colors.grey.shade300, size: 64),
                    const SizedBox(height: 12),
                    Text(
                      l10n.bookingHistoryEmpty,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchBookings,
                color: primaryColor,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    // ดึงข้อมูลการจองแต่ละรายการตามตำแหน่ง (index) มาแสดงผล
              final booking = _bookings[index];
                    return _buildBookingCard(booking, primaryColor);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, Color primaryColor) {
    final l10n = context.l10n;
    bool isPendingOwnerApproval = booking.status == 'pending_owner_approval';
    bool isPendingPayment = booking.status == 'pending_payment';
    bool isCompleted = booking.status == 'completed' || booking.status == 'confirmed';
    bool isRejected = booking.status == 'rejected';
    bool isCancelled = booking.status == 'cancelled';

    String statusText = booking.status.translateBookingStatus(context);
    if (isPendingPayment && booking.paymentStatus == 'submitted') {
      statusText = l10n.bookingStatusPendingPaymentVerification;
    }

    Color statusColor = primaryColor;
    Color statusBgColor = const Color(0xFFE8F1FF);
    IconData statusIcon = Icons.hourglass_empty_rounded;

    if (isCompleted) {
      statusColor = const Color(0xFF22C55E);
      statusBgColor = const Color(0xFFF0FDF4);
      statusIcon = Icons.check_circle_rounded;
    } else if (isRejected || isCancelled) {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
      statusIcon = Icons.cancel_rounded;
    } else if (isPendingPayment) {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFEF3C7);
      statusIcon = Icons.payment_rounded;
    }

    final dormName = booking.dormitory?.name ?? l10n.bookingNoDormName;
    final roomDesc = booking.room != null 
        ? '${l10n.bookingRoom} ${booking.room!.roomNumber} • ${booking.room!.roomType}'
        : l10n.bookingNoRoomInfo;
    final bookingFeeText = booking.room != null ? '฿${booking.room!.bookingFee.toStringAsFixed(0)}' : '฿0';
    final imageUrl = booking.dormitory?.coverImageUrl ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=150';

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${l10n.bookingIdPrefix}${booking.id}',
                style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 11
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.image, color: Colors.black26),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dormName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937)
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      roomDesc,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12
                      ),
                    ),
                    if (booking.moveInDate != null && booking.moveInDate!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '✨ พร้อมเข้าอยู่วันที่: ${booking.moveInDate!.split('T')[0]}',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.bookingDepositFee,
                    style: const TextStyle(color: Colors.black38, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookingFeeText,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                ],
              ),
              if (isPendingPayment)
                if (booking.paymentStatus == 'submitted' || (booking.paymentSlipUrl != null && booking.paymentStatus != 'rejected'))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      l10n.bookingWaitingOwnerConfirm,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (booking.paymentStatus == 'rejected')
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(l10n.bookingSlipRejected, style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailPage(
                                dormName: dormName,
                                roomType: booking.room?.roomType ?? 'ไม่ระบุประเภท',
                                monthlyPrice: booking.room != null ? booking.room!.price.toStringAsFixed(0) : '0',
                                securityDeposit: booking.room != null ? booking.room!.securityDeposit.toStringAsFixed(0) : '0',
                                bookingFee: booking.room != null ? booking.room!.bookingFee.toStringAsFixed(0) : '0',
                                imageUrl: imageUrl,
                                roomId: booking.roomId,
                                facilities: booking.room?.facilities ?? [],
                                roomNumber: booking.room!.roomNumber,
                                existingBooking: booking,
                              ),
                            ),
                          );
                          if (result == true) {
                            _fetchBookings(); // Refresh if payment succeeded
                          }
                        },
                        child: Text(l10n.bookingAttachSlip, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  )
              else if (isCompleted)
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF22C55E)),
                      ),
                      child: Text(
                        booking.status.translateBookingStatus(context),
                        style: const TextStyle(
                          color: Color(0xFF22C55E),
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('ดาวน์โหลดใบจอง', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        // show loading or just generate
                        try {
                          await PdfService.generateAndShareBookingReceipt(booking);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('ไม่สามารถสร้างใบจองได้: $e')),
                            );
                          }
                        }
                      },
                    )
                   ]
                 ),
            ],
          ),
        ],
      ),
    );
  }
}
