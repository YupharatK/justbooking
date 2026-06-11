import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/promptpay_qr_service.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../core/api_client.dart';
import '../services/notification_service.dart';
import '../core/localization/localization_extension.dart';

class PaymentSectionWidget extends StatefulWidget {
  final Booking booking;
  final String price;
  final VoidCallback onPaymentSuccess;

  const PaymentSectionWidget({
    super.key,
    required this.booking,
    required this.price,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentSectionWidget> createState() => _PaymentSectionWidgetState();
}

class _PaymentSectionWidgetState extends State<PaymentSectionWidget> {
  File? _slipImage;
  bool _isSubmitting = false;
  Timer? _countdownTimer;
  Duration _timeRemaining = Duration.zero;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (widget.booking.status == 'completed' || widget.booking.paymentStatus == 'submitted') {
      return;
    }
    
    DateTime createdAt;
    try {
      // Use current time to guarantee a fresh 15-minute countdown for the user
      createdAt = DateTime.now();
    } catch (e) {
      createdAt = DateTime.now();
    }
    
    final expiresAt = createdAt.add(const Duration(minutes: 15));
    
    void updateTimer() {
      final now = DateTime.now();
      if (now.isAfter(expiresAt)) {
        if (mounted) {
          setState(() {
            _timeRemaining = Duration.zero;
            _isExpired = true;
          });
        }
        _countdownTimer?.cancel();
      } else {
        if (mounted) {
          setState(() {
            _timeRemaining = expiresAt.difference(now);
            _isExpired = false;
          });
        }
      }
    }

    updateTimer();
    if (!_isExpired) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        updateTimer();
      });
    }
  }

    // ฟังก์ชันแบบ Asynchronous สำหรับติดต่อระบบหลังบ้าน (Backend) หรือประมวลผลข้อมูล: _pickSlip
Future<void> _pickSlip() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
            // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
        _slipImage = File(pickedFile.path);
      });
    }
  }

    // ฟังก์ชันแบบ Asynchronous สำหรับติดต่อระบบหลังบ้าน (Backend) หรือประมวลผลข้อมูล: _submitSlip
Future<void> _submitSlip() async {
    if (_slipImage == null) return;
        // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
      _isSubmitting = true;
    });

    try {
      final bookingService = BookingService();
      await bookingService.submitPaymentSlip(widget.booking.id, _slipImage!);
      
      // ส่งแจ้งเตือนให้เจ้าของ
      if (widget.booking.dormitory?.ownerId != null) {
        try {
          await NotificationService().createPaymentSlipNotification(widget.booking.dormitory!.ownerId!);
        } catch (e) {
          debugPrint('Notification error: $e');
        }
      }

      widget.onPaymentSuccess();
    } catch (e) {
      String errMsg = context.l10n.bookingPaymentUploadError;
      if (e is ApiException) {
        errMsg = e.message;
      }
            // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errMsg), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
                // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

    // ฟังก์ชัน build ทำหน้าที่วาดหน้าจอ (UI) และจัดวาง Widget ต่างๆ ภายในหน้านี้
@override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dorm = widget.booking.dormitory;
    final bankName = dorm?.bankName ?? l10n.bookingNoBank;
    final accountName = dorm?.accountName ?? l10n.bookingNoAccountName;
    final accountNumber = dorm?.accountNumber ?? l10n.bookingNoAccountNumber;
    final promptPay = (dorm?.promptPayNumber != null && dorm!.promptPayNumber!.isNotEmpty) 
        ? dorm.promptPayNumber 
        : '0999999999'; // Fallback สำหรับทดสอบระบบเนื่องจาก Backend ยังไม่รองรับ promptpay_number

    bool isCompleted = widget.booking.status == 'completed' || widget.booking.paymentStatus == 'submitted';

    return Container(
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
          Text(
            l10n.bookingPaymentTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(l10n.bookingPaymentAmount, widget.price, isBold: true, color: const Color(0xFFE0A926)),
          const Divider(height: 24),
          if (!isCompleted) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isExpired ? Colors.red.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isExpired ? Colors.red.shade200 : Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    _isExpired ? Icons.timer_off : Icons.timer, 
                    color: _isExpired ? Colors.red : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isExpired 
                        ? 'หมดเวลาการชำระเงิน (คำขอจองถูกยกเลิกแล้ว)' 
                        : 'กรุณาชำระเงินภายใน: ${_timeRemaining.inMinutes.toString().padLeft(2, '0')}:${(_timeRemaining.inSeconds % 60).toString().padLeft(2, '0')} นาที',
                      style: TextStyle(
                        color: _isExpired ? Colors.red : Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          _buildInfoRow(l10n.bookingBank, bankName),
          _buildInfoRow(l10n.bookingAccountName, accountName),
          _buildInfoRow(l10n.bookingAccountNumber, accountNumber),
          if (promptPay != null && promptPay.isNotEmpty) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(l10n.bookingScanPromptPay, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
            ),
            const SizedBox(height: 8),
            Center(
              child: PromptPayQrView(
                promptPayNumber: promptPay,
                amount: double.tryParse(widget.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
                size: 180,
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(l10n.bookingPaymentSubmitted, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          else ...[
            if (_isExpired)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'ไม่สามารถแนบสลีปได้เนื่องจากหมดเวลา 15 นาที',
                    style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else ...[
              if (_slipImage != null) ...[
                Text(l10n.bookingYourSlip, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_slipImage!, height: 200, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.image),
                  label: Text(_slipImage == null ? l10n.bookingSelectSlip : l10n.bookingChangeSlip),
                  onPressed: _pickSlip,
                ),
              ),
              if (_slipImage != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child:                 // ปุ่มกดแบบมีพื้นหลัง (ElevatedButton) เมื่อกดแล้วจะเรียกคำสั่งใน onPressed
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4274E6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: _isSubmitting ? null : _submitSlip,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.bookingSubmitSlip, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ]
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? const Color(0xFF1F2937),
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
