import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class BookingDetailPage extends StatefulWidget {
  final String dormName;
  final String roomType;
  final String price;
  final String imageUrl;
  final int roomId;

  const BookingDetailPage({
    super.key,
    required this.dormName,
    required this.roomType,
    required this.price,
    required this.imageUrl,
    required this.roomId,
  });

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final BookingService _bookingService = BookingService();
  bool _isSlipAttached = false;
  String _slipFileName = '';
  bool _isSubmitting = false;

  // Mock tenant data (can eventually come from a database/auth)
  final String _tenantName = 'สมชาย ใจดี';
  final String _tenantPhone = '081-234-5678';
  final String _tenantAddress = '123 ถ.สุขุมวิท กทม.';
  final String _contractDate = '01/06/2567';

  // Perform booking confirmation
  Future<void> _confirmBooking() async {
    if (!_isSlipAttached) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'กรุณาแนบสลิปการชำระเงินก่อนกดยืนยันการจอง',
                style: TextStyle(fontFamily: 'Kanit'),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // 1. Create booking
      final bookingId = await _bookingService.createBooking(
        roomId: widget.roomId,
        moveInDate: '2024-06-01', // Example date
        note: 'Mock Note',
      );

      // 2. Submit payment slip (using mock url for now)
      await _bookingService.submitPaymentSlip(
        bookingId, 
        'https://example.com/mock_slip.jpg'
      );

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

      // Show booking success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated green check circle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F8F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF1ABC9C),
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ยืนยันการจองสำเร็จ!',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ทางเราได้รับสลิปการชำระเงินและรายละเอียดการจองของคุณเรียบร้อยแล้ว เจ้าของหอพักจะตรวจสอบสัญญาภายใน 24 ชม.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13.5,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Summary card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.04)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('หอพัก', style: TextStyle(fontFamily: 'Kanit', color: Colors.grey)),
                            Text(widget.dormName, style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('ประเภทห้อง', style: TextStyle(fontFamily: 'Kanit', color: Colors.grey)),
                            Text(widget.roomType, style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('ราคารวมสัญญา', style: TextStyle(fontFamily: 'Kanit', color: Colors.grey)),
                            const Text('฿3,000', style: TextStyle(fontFamily: 'Kanit', color: Color(0xFFE0A926), fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4274E6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        // Pop back to home page and go to tab 1 (การจอง)
                        Navigator.of(context)
                          ..pop() // Pop BookingDetailPage
                          ..pop() // Pop RoomTypesPage
                          ..pop(1); // Pop DormDetailPage with index 1 (การจอง tab)
                      },
                      child: const Text(
                        'ตกลง (ดูรายการจอง)',
                        style: TextStyle(fontFamily: 'Kanit', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาดในการจอง กรุณาลองใหม่', style: TextStyle(fontFamily: 'Kanit')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Pick/Attach Mock Slip
  void _attachMockSlip() {
    setState(() {
      _isSlipAttached = true;
      _slipFileName = 'PaySlip_ref_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.png';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'แนบสลิป "$_slipFileName" สำเร็จ',
              style: const TextStyle(fontFamily: 'Kanit'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2ECC71),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4274E6);
    const textDarkColor = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'รายละเอียดการจอง',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
                  // CARD 1: Dorm Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.black.withOpacity(0.02)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey.shade100,
                                child: const Icon(Icons.apartment_rounded, color: Colors.black26, size: 40),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.dormName,
                                style: const TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textDarkColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '1 ห้อง • ${widget.roomType}',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                'เราท์เตอร์ไวไฟ • เฟอร์นิเจอร์บิวอิน',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                  children: [
                                    const TextSpan(text: 'ราคา '),
                                    TextSpan(
                                      text: widget.price.replaceAll('฿', '').replaceAll('/เดือน', ''),
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: textDarkColor),
                                    ),
                                    const TextSpan(text: ' ต่อเดือน • ค่าประกัน '),
                                    const TextSpan(
                                      text: '6,000',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: textDarkColor),
                                    ),
                                    const TextSpan(text: '\nสัญญา 1 ปี'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CARD 2: Tenant Info Card ("ข้อมูลผู้จอง")
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.black.withOpacity(0.02)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.badge_rounded, color: primaryColor, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'ข้อมูลผู้จอง',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDarkColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTenantRow('ชื่อ-นามสกุล', _tenantName),
                        _buildTenantRow('เบอร์โทรศัพท์', _tenantPhone),
                        _buildTenantRow('ที่อยู่', _tenantAddress),
                        _buildTenantRow(
                          'วันทำสัญญา',
                          _contractDate,
                          isPill: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CARD 3: Payment Channel Card ("ช่องทางชำระเงิน")
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.black.withOpacity(0.02)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.qr_code_scanner_rounded, color: primaryColor, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'ช่องทางชำระเงิน',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDarkColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // QR Code Mockup (Aesthetic centered card image)
                        Center(
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black.withOpacity(0.05)),
                            ),
                            child: Column(
                              children: [
                                // PromtPay Mockup header
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.account_balance_wallet_rounded, color: primaryColor, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      'Prompt Pay',
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // QR code image mockup (Aesthetic minimalist room with QR)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=400',
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 150,
                                      width: 150,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(Icons.qr_code_2_rounded, size: 64, color: Colors.black45),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Error/Warning Text
                        const Text(
                          '*หากผู้ใช้งานทำการชำระเงินไปแล้ว ทางระบบจะไม่มีการคืนเงินทุกกรณี',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            color: Colors.redAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 28),

                        // Attachment Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ยืนยันการชำระเงิน',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textDarkColor,
                              ),
                            ),
                            
                            // Slip upload button
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isSlipAttached ? const Color(0xFF2ECC71) : primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              onPressed: _attachMockSlip,
                              icon: Icon(_isSlipAttached ? Icons.check_circle_outline_rounded : Icons.attach_file_rounded, size: 16),
                              label: Text(
                                _isSlipAttached ? 'แนบแล้ว' : 'แนบสลิป',
                                style: const TextStyle(fontFamily: 'Kanit', fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        // If slip attached, display its name
                        if (_isSlipAttached) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F8F5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF2ECC71).withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.insert_drive_file_outlined, color: Color(0xFF2ECC71), size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _slipFileName,
                                    style: const TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 12,
                                      color: Color(0xFF27AE60),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // BOTTOM CONTROL BAR: Price summary & Booking button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'ราคารวมทั้งสิ้น',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        color: Colors.black45,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          widget.roomType.contains('พัดลม') ? '2,800' : '3,500', // dynamic based on selection
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            color: Color(0xFFE0A926), // Orange-Gold color as in screenshot
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '฿',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            color: Color(0xFFE0A926),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  onPressed: _isSubmitting ? null : _confirmBooking,
                  child: _isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'ยืนยันการจอง',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builder helper for tenant rows
  Widget _buildTenantRow(String label, String value, {bool isPill = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Kanit',
              color: Colors.black45,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: isPill
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Kanit',
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        color: Color(0xFF1F2937),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
