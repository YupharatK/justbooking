import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';

class PdfService {
  static Future<void> generateAndShareBookingReceipt(Booking booking) async {
    final doc = pw.Document();

    // โหลดฟอนต์ภาษาไทย (Sarabun)
    final fontRegular = await PdfGoogleFonts.sarabunRegular();
    final fontBold = await PdfGoogleFonts.sarabunBold();

    // โหลดฟอร์แมตวันที่แบบไทย
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final shortDateFormat = DateFormat('dd/MM/yyyy');
    
    DateTime? txDate;
    try {
      txDate = DateTime.parse(booking.createdAt).toLocal();
    } catch (_) {}

    final transactionDateStr = txDate != null ? dateFormat.format(txDate) : '-';
    
    DateTime? moveInDate;
    if (booking.moveInDate.isNotEmpty) {
      try {
        moveInDate = DateTime.parse(booking.moveInDate).toLocal();
      } catch (_) {}
    }
    final moveInStr = moveInDate != null ? shortDateFormat.format(moveInDate) : 'รอกำหนด';

    final customerName = '${booking.user?.firstName ?? ''} ${booking.user?.lastName ?? ''}'.trim();
    final customerPhone = booking.user?.phone ?? '-';
    final dormName = booking.dormitory?.name ?? 'ไม่ระบุชื่อหอพัก';
    final roomNumber = booking.room?.roomNumber ?? 'ไม่ระบุ';
    final roomType = booking.room?.roomType ?? 'ไม่ระบุ';
    final depositAmount = booking.room?.bookingFee ?? 0.0;
    
    // โลโก้แอป (ถ้ามี) แบบเป็นตัวอักษรหรือ icon
    
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Justbooking', style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.blue800)),
                      pw.SizedBox(height: 4),
                      pw.Text('ใบจองหอพัก (Booking Receipt)', style: pw.TextStyle(font: fontBold, fontSize: 20)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('เลขที่ใบจอง', style: pw.TextStyle(font: fontRegular, fontSize: 12, color: PdfColors.grey700)),
                      pw.Text('JB-${booking.id}', style: pw.TextStyle(font: fontBold, fontSize: 14)),
                      pw.SizedBox(height: 4),
                      pw.Text('วันที่ทำรายการ', style: pw.TextStyle(font: fontRegular, fontSize: 12, color: PdfColors.grey700)),
                      pw.Text(transactionDateStr, style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                    ]
                  ),
                ],
              ),
              
              pw.SizedBox(height: 30),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 20),

              // Dorm & Room Info Section
              pw.Text('ข้อมูลหอพักและห้องพัก', style: pw.TextStyle(font: fontBold, fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  children: [
                    _buildInfoRow('ชื่อหอพัก:', dormName, fontRegular, fontBold),
                    pw.SizedBox(height: 8),
                    _buildInfoRow('ประเภทห้อง:', roomType, fontRegular, fontBold),
                    pw.SizedBox(height: 8),
                    _buildInfoRow('เลขห้อง:', roomNumber, fontRegular, fontBold),
                  ]
                ),
              ),

              pw.SizedBox(height: 20),

              // Customer Info Section
              pw.Text('ข้อมูลผู้จอง', style: pw.TextStyle(font: fontBold, fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  children: [
                    _buildInfoRow('ชื่อ-นามสกุล:', customerName.isNotEmpty ? customerName : '-', fontRegular, fontBold),
                    pw.SizedBox(height: 8),
                    _buildInfoRow('เบอร์โทรศัพท์:', customerPhone, fontRegular, fontRegular),
                  ]
                ),
              ),

              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 20),

              // Summary Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('วันที่เข้าอยู่ได้:', style: pw.TextStyle(font: fontBold, fontSize: 14)),
                  pw.Text(moveInStr, style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blue800)),
                ]
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('ค่ามัดจำ (เงินจอง) ที่ชำระแล้ว:', style: pw.TextStyle(font: fontBold, fontSize: 16)),
                  pw.Text('฿${NumberFormat('#,##0').format(depositAmount)}', style: pw.TextStyle(font: fontBold, fontSize: 18, color: PdfColors.green700)),
                ]
              ),

              pw.Spacer(),

              // Footer Notes
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 1),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Icon(const pw.IconData(0xe88e), color: PdfColors.orange700, size: 20), // info icon equivalent
                    pw.SizedBox(width: 8),
                    pw.Expanded(
                      child: pw.Text(
                        'ใบจองนี้ใช้เป็นหลักฐานในการทำสัญญาเช่าฉบับจริงในวันที่ย้ายเข้า กรุณาแสดงใบจองนี้และบัตรประชาชนตัวจริงต่อผู้ดูแลหอพัก',
                        style: pw.TextStyle(font: fontRegular, fontSize: 12, color: PdfColors.grey800),
                        textAlign: pw.TextAlign.left,
                      ),
                    ),
                  ]
                ),
              ),
              
            ],
          );
        },
      ),
    );

    final Uint8List pdfBytes = await doc.save();
    
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'booking_receipt_JB-${booking.id}.pdf',
    );
  }

  static pw.Widget _buildInfoRow(String label, String value, pw.Font labelFont, pw.Font valueFont) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(label, style: pw.TextStyle(font: labelFont, fontSize: 14, color: PdfColors.grey700)),
        ),
        pw.Expanded(
          child: pw.Text(value, style: pw.TextStyle(font: valueFont, fontSize: 14)),
        ),
      ]
    );
  }
}
