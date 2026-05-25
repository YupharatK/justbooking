import 'package:flutter/material.dart';
import '../services/owner_service.dart';
import '../models/booking.dart';

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
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการดึงข้อมูลการจอง')),
        );
      }
    }
  }

  Future<void> _updateStatus(int bookingId, String status) async {
    try {
      await _ownerService.updateBookingStatus(bookingId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('อัปเดตสถานะสำเร็จ', style: const TextStyle(fontFamily: 'Kanit')),
          backgroundColor: Colors.green,
        ),
      );
      _fetchBookings(); // Refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง')),
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
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'จัดการคำขอจอง',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _bookings.isEmpty
              ? const Center(
                  child: Text(
                    'ยังไม่มีคำขอจอง',
                    style: TextStyle(fontFamily: 'Kanit', color: Colors.grey),
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
    final bool isPending = booking.status == 'pending';
    final user = booking.user;
    final room = booking.room;
    final dorm = booking.dormitory;

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
                  fontFamily: 'Kanit',
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
                  _getStatusText(booking.status),
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(booking.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'ผู้จอง: ${user?.firstName ?? ''} ${user?.lastName ?? ''}',
            style: const TextStyle(
              fontFamily: 'Kanit',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'หอพัก: ${dorm?.name ?? ''} | ห้อง: ${room?.roomNumber ?? ''}',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'วันที่เข้าอยู่: ${booking.moveInDate}',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          if (booking.paymentSlipUrl != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // Could show full image dialogue
              },
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  const Text('แนบหลักฐานการโอนแล้ว', style: TextStyle(fontFamily: 'Kanit', fontSize: 12, color: Colors.blue)),
                ],
              ),
            ),
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
                    onPressed: () => _showConfirmDialog(booking.id, 'rejected'),
                    child: const Text('ปฏิเสธ', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
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
                    onPressed: () => _showConfirmDialog(booking.id, 'approved'),
                    child: const Text('อนุมัติ', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showConfirmDialog(int bookingId, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยัน', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
        content: Text(
          status == 'approved' ? 'คุณต้องการอนุมัติการจองนี้ใช่หรือไม่?' : 'คุณต้องการปฏิเสธการจองนี้ใช่หรือไม่?',
          style: const TextStyle(fontFamily: 'Kanit'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก', style: TextStyle(fontFamily: 'Kanit', color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(bookingId, status);
            },
            child: Text(
              'ยืนยัน',
              style: TextStyle(
                fontFamily: 'Kanit',
                color: status == 'approved' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return const Color(0xFFF97316);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'อนุมัติแล้ว';
      case 'rejected':
        return 'ถูกปฏิเสธ';
      case 'pending':
      default:
        return 'รอตรวจสอบ';
    }
  }
}
