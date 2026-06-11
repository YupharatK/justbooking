const fs = require('fs');

let file = 'lib/users/booking_detail_page.dart';
if (fs.existsSync(file)) {
  let content = fs.readFileSync(file, 'utf8');

  content = content.replace(
    "Future<void> _submitPaymentSlip() async {",
    "// ฟังก์ชันสำหรับส่ง (Upload) สลิปการโอนเงินไปยังเซิร์ฟเวอร์\n  // จะทำงานเมื่อผู้ใช้กดปุ่ม 'ส่งสลิปชำระเงิน'\n  Future<void> _submitPaymentSlip() async {"
  );

  content = content.replace(
    "Future<void> _pickImage() async {",
    "// ฟังก์ชันสำหรับเปิดแกลลอรี่ให้ผู้ใช้เลือกรูปภาพสลิปโอนเงิน\n  // ใช้ไลบรารี image_picker\n  Future<void> _pickImage() async {"
  );

  content = content.replace(
    "Widget build(BuildContext context) {",
    "// ฟังก์ชันสร้างหน้าจอ UI สำหรับแสดงรายละเอียดการจอง และอัปโหลดสลิป\n  @override\n  Widget build(BuildContext context) {"
  ).replace("  @override\n// ฟังก์ชัน", "// ฟังก์ชัน");

  content = content.replace(
    "Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {",
    "// ฟังก์ชันแยก (Helper) สำหรับสร้างบรรทัดแสดงสรุปยอดเงิน (เช่น ค่าห้อง: 5000 บาท)\n  // หากเป็นยอดรวม (isTotal = true) จะแสดงตัวหนังสือตัวหนาและใหญ่ขึ้น\n  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {"
  );

  fs.writeFileSync(file, content);
  console.log('Detailed comments added to booking_detail_page.dart');
}
