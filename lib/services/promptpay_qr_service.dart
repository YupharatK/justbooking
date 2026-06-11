import 'package:flutter/material.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';

class PromptPayQrView extends StatelessWidget {
  final String promptPayNumber;
  final double amount;
  final double size;

  const PromptPayQrView({
    super.key,
    required this.promptPayNumber,
    required this.amount,
    this.size = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    // ใช้ Widget ของ package ที่วาด QR Code และมีโลโก้ Thai QR Payment พร้อมแล้ว
    return QRCodeGenerate(
      promptPayId: promptPayNumber,
      amount: amount,
      width: size,
      height: size + 80, // เผื่อพื้นที่ให้โลโก้ด้านบน
      isShowAccountDetail: false,
      isShowAmountDetail: false,
    );
  }
}
