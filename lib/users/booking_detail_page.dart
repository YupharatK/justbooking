import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../models/booking.dart';
import 'payment_section_widget.dart';
import '../core/localization/localization_extension.dart';

/// หน้าแสดงรายละเอียดของคำขอจอง 1 รายการ และเป็นหน้าสำหรับอัปโหลดสลิปชำระเงิน

class BookingDetailPage extends StatefulWidget {
  final String dormName;
  final String roomType;
  final String monthlyPrice;
  final String securityDeposit;
  final String bookingFee;
  final String imageUrl;
  final int roomId;
  final List<String> facilities;
  final String roomNumber;
  final int? ownerId;
  final DateTime? availableFrom;
  final Booking? existingBooking;

  const BookingDetailPage({
    super.key,
    required this.dormName,
    required this.roomType,
    required this.monthlyPrice,
    required this.securityDeposit,
    required this.bookingFee,
    required this.imageUrl,
    required this.roomId,
    required this.facilities,
    required this.roomNumber,
    this.ownerId,
    this.availableFrom,
    this.existingBooking,
  });

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final BookingService _bookingService = BookingService();
  bool _isSlipAttached = false;
  String _slipFileName = '';
  bool _isSubmitting = false;

  User? _currentUser;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  // ฟังก์ชันสำหรับดึงข้อมูลโปรไฟล์ของผู้ใช้งานปัจจุบัน (เพื่อเอาชื่อและเบอร์โทรมาแสดงในฟอร์ม)
  Future<void> _fetchUser() async {
    try {
      // เรียก API ดึงข้อมูล User จากระบบ Authentication
      final user = await AuthService().getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoadingUser = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingUser = false;
        });
      }
    }
  }

  // ฟังก์ชันสำหรับกดยืนยันการจองห้องพัก
  // จะทำงานเมื่อผู้ใช้กดปุ่ม 'ยืนยันการจอง' ด้านล่างจอ
  Future<void> _confirmBooking() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // 1. เรียก API ส่งคำขอจองห้องพัก (createBooking) พร้อมแนบ ID ห้องและวันที่ย้ายเข้า
      final bookingId = await _bookingService.createBooking(
        roomId: widget.roomId,
        moveInDate: widget.availableFrom != null 
          ? widget.availableFrom!.toIso8601String().split('T')[0] 
          : DateTime.now().toIso8601String().split('T')[0],
        note: '',
      );

      // 2. ส่งการแจ้งเตือน (Push Notification) ไปหาเจ้าของหอพัก
      // (ทำงานแบบเบื้องหลัง fire and forget เพื่อไม่ให้แอปค้างระหว่างรอ)
      try {
        if (_currentUser != null && widget.ownerId != null) {
          // Send notification to the actual owner without awaiting
          NotificationService().createBookingNotification(
            _currentUser!.id, 
            widget.ownerId!, 
            widget.dormName, 
            widget.roomType
          ).catchError((e) {
            debugPrint('Notification Error: $e');
          });
        } else {
          debugPrint('Notification Skipped: Missing ownerId or _currentUser');
        }
      } catch (e) {
        debugPrint('Notification Error: $e');
      }

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;
      final l10n = context.l10n;

      // 3. แสดงหน้าต่าง Popup (Dialog) แจ้งเตือนว่า 'ส่งคำขอจองสำเร็จ'
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
                  // สร้างแอนิเมชันไอคอนเครื่องหมายถูก (Check Circle) สีเขียว
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
                  Text(
                    l10n.bookingConfirmSuccessTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.bookingConfirmSuccessDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // กล่องสรุปรายละเอียดการจอง (ชื่อหอพัก, ประเภทห้อง, ยอดเงิน)
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
                            Text(l10n.bookingDormitory, style: const TextStyle(color: Colors.grey)),
                            Text(widget.dormName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.bookingRoomType, style: const TextStyle(color: Colors.grey)),
                            Text(widget.roomType, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.bookingPaymentAmount, style: const TextStyle(color: Colors.grey)),
                            Text(widget.bookingFee, style: const TextStyle(color: Color(0xFFE0A926), fontWeight: FontWeight.w900)),
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
                      child: Text(
                        l10n.bookingOkViewList,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
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
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bookingCreateError, style: const TextStyle()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Pick/Attach Mock Slip removed

  @override
  // ฟังก์ชันสร้างหน้าจอ UI สำหรับแสดงรายละเอียดการจอง และอัปโหลดสลิป
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
        title: Text(
          l10n.bookingDetailTitle,
          style: const TextStyle(
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
                  // กล่องการ์ดที่ 1: สรุปข้อมูลหอพักและห้องพักที่กำลังจอง รวมถึงราคาและค่ามัดจำ
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textDarkColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${l10n.bookingRoom} ${widget.roomNumber} • ${widget.roomType}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                widget.facilities.isNotEmpty ? widget.facilities.join(' • ') : l10n.bookingNoFacilities,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                  children: [
                                    TextSpan(text: l10n.bookingPriceLabel),
                                    TextSpan(
                                      text: widget.monthlyPrice.replaceAll('฿', '').replaceAll('/เดือน', ''),
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: textDarkColor),
                                    ),
                                    TextSpan(text: l10n.bookingPerMonthDeposit),
                                    TextSpan(
                                      text: widget.securityDeposit.replaceAll('฿', ''),
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: textDarkColor),
                                    ),
                                    TextSpan(text: l10n.bookingOneYearContract),
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

                  // กล่องการ์ดที่ 2: ข้อมูลส่วนตัวของผู้เช่าที่จะถูกส่งไปให้เจ้าของหอพิจารณา
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
                        Row(
                          children: [
                            const Icon(Icons.badge_rounded, color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.bookingTenantInfo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDarkColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _isLoadingUser 
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                _buildTenantRow(l10n.bookingTenantName, _currentUser != null ? '${_currentUser!.firstName} ${_currentUser!.lastName}' : l10n.commonLoading),
                                _buildTenantRow(l10n.bookingTenantPhone, _currentUser?.phone ?? '-'),
                                _buildTenantRow(l10n.bookingTenantAddress, _currentUser?.address ?? '-'),
                                _buildTenantRow(
                                  l10n.bookingStartDate,
                                  (widget.existingBooking != null && widget.existingBooking!.moveInDate.isNotEmpty) 
                                      ? widget.existingBooking!.moveInDate.split('T')[0] 
                                      : (widget.availableFrom != null 
                                          ? '${widget.availableFrom!.day.toString().padLeft(2, '0')}/${widget.availableFrom!.month.toString().padLeft(2, '0')}/${widget.availableFrom!.year}'
                                          : 'รอเจ้าของหอกำหนด'),
                                  isPill: true,
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment channel card removed as it's not needed at creation stage
                  if (widget.existingBooking != null && widget.existingBooking!.status == 'pending_payment') ...[
                    const SizedBox(height: 16),
                    PaymentSectionWidget(
                      booking: widget.existingBooking!,
                      price: widget.bookingFee,
                      onPaymentSuccess: () {
                        // Refresh or close page
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // แถบเมนูด้านล่างสุด (Bottom Bar): แสดงยอดรวมที่ต้องจ่าย และปุ่มกดยืนยันการจอง (Only show if creating new)
          if (widget.existingBooking == null)
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
                      Text(
                        l10n.bookingPaymentAmount,
                        style: const TextStyle(
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
                            widget.bookingFee.replaceAll(RegExp(r'[^0-9]'), ''),
                            style: const TextStyle(
                              color: Color(0xFFE0A926), // Orange-Gold color as in screenshot
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '฿',
                            style: TextStyle(
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
                      backgroundColor: const Color(0xFF4274E6),
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
                      : Text(
                          l10n.bookingConfirmButton,
                          style: const TextStyle(
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

  // ฟังก์ชันตัวช่วย (Helper) สำหรับวาดบรรทัดข้อมูลผู้เช่าแต่ละแถว (เช่น ชื่อ, เบอร์โทร)
  // label คือหัวข้อ (เช่น 'ชื่อ-นามสกุล'), value คือค่าที่จะแสดง
  // ถ้า isPill = true จะตีกรอบพื้นหลังสีเทาอ่อนให้ค่า value (เช่น กรอบใส่วันที่)
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
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
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
