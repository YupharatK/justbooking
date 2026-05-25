import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../models/booking.dart';

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

  Future<void> _fetchBookings() async {
    try {
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
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4274E6);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'การจองของคุณ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'ติดตามสถานะการจองและการทำสัญญาหอพัก',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            )
          else if (_bookings.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_outlined, color: Colors.grey.shade300, size: 64),
                    const SizedBox(height: 12),
                    Text(
                      'ไม่มีประวัติการจองก่อนหน้านี้',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                        fontFamily: 'Kanit'
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
    bool isPending = booking.status == 'pending';
    bool isApproved = booking.status == 'approved';
    bool isRejected = booking.status == 'rejected';

    String statusText = 'รอการอนุมัติสัญญา';
    Color statusColor = primaryColor;
    Color statusBgColor = const Color(0xFFE8F1FF);
    IconData statusIcon = Icons.hourglass_empty_rounded;

    if (isApproved) {
      statusText = 'อนุมัติแล้ว';
      statusColor = const Color(0xFF22C55E);
      statusBgColor = const Color(0xFFF0FDF4);
      statusIcon = Icons.check_circle_rounded;
    } else if (isRejected) {
      statusText = 'ถูกปฏิเสธ';
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
      statusIcon = Icons.cancel_rounded;
    }

    final dormName = booking.dormitory?.name ?? 'ไม่ระบุชื่อหอพัก';
    final roomDesc = booking.room != null 
        ? 'ห้อง ${booking.room!.roomNumber} • ${booking.room!.roomType}'
        : 'ไม่มีข้อมูลห้อง';
    final price = booking.room != null ? '฿${booking.room!.price.toStringAsFixed(0)}' : '฿0';
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
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit'
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'รหัสการจอง #JB${booking.id}',
                style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 11,
                  fontFamily: 'Kanit'
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
                        color: Color(0xFF1F2937),
                        fontFamily: 'Kanit'
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      roomDesc,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontFamily: 'Kanit'
                      ),
                    ),
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
                  const Text(
                    'ค่ามัดจำสัญญา',
                    style: TextStyle(color: Colors.black38, fontSize: 11, fontFamily: 'Kanit'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Kanit'
                    ),
                  ),
                ],
              ),
              if (booking.paymentStatus != 'paid' && booking.status != 'rejected')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    // Logic to re-upload slip could go here
                  },
                  child: const Text('ชำระเงินมัดจำ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Kanit')),
                )
              else if (booking.paymentStatus == 'paid')
                 Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF22C55E)),
                  ),
                  child: const Text(
                    'ชำระเงินแล้ว',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'Kanit'
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
