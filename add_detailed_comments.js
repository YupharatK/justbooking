const fs = require('fs');

let file = 'lib/users/booking_history_tab.dart';
let content = fs.readFileSync(file, 'utf8');

// We will add detailed comments to the key parts of booking_history_tab.dart
// 1. _fetchBookings
content = content.replace(
  "Future<void> _fetchBookings() async {",
  "// ฟังก์ชันนี้จะติดต่อกับ API ผ่าน BookingService เพื่อดึงข้อมูลการจองทั้งหมดของผู้ใช้\n  // และทำการจัดการสถานะ (State) ว่ากำลังโหลด (isLoading) หรือเกิดข้อผิดพลาด (errorMessage)\n  Future<void> _fetchBookings() async {"
);

content = content.replace(
  "final bookings = await _bookingService.getMyBookings();",
  "// ดึงข้อมูลการจองจากฐานข้อมูลผ่าน Service\n      final bookings = await _bookingService.getMyBookings();"
);

content = content.replace(
  "Widget _buildStatusChip(Booking booking) {",
  "// ฟังก์ชันสร้างป้ายกำกับ (Status Chip) เพื่อแสดงสถานะปัจจุบันของการจอง\n  // มีการแบ่งสีตามสถานะ เช่น รออนุมัติ (สีส้ม), รอชำระเงิน (สีเหลือง/ส้ม), อนุมัติแล้ว (สีเขียว), ปฏิเสธ (สีแดง)\n  Widget _buildStatusChip(Booking booking) {"
);

content = content.replace(
  "return ListView.builder(",
  "// สร้างรายการแสดงประวัติการจองแบบเลื่อนได้ (ListView)\n            return ListView.builder("
);

content = content.replace(
  "final booking = _bookings[index];",
  "// ดึงข้อมูลการจองแต่ละรายการตามตำแหน่ง (index) มาแสดงผล\n              final booking = _bookings[index];"
);

content = content.replace(
  "Widget build(BuildContext context) {",
  "// ฟังก์ชัน build คือส่วนที่ใช้สร้างหน้าจอ UI (User Interface) ทั้งหมดของหน้านี้\n  @override\n  Widget build(BuildContext context) {"
).replace("  @override\n// ฟังก์ชัน", "// ฟังก์ชัน");

content = content.replace(
  "if (_isLoading)",
  "// ตรวจสอบสถานะ หากกำลังโหลด (_isLoading = true) ให้แสดงวงกลมหมุน (CircularProgressIndicator)\n          if (_isLoading)"
);

content = content.replace(
  "else if (_errorMessage != null)",
  "// หากเกิดข้อผิดพลาดในการโหลดข้อมูล ให้แสดงข้อความแจ้งเตือน (Error Message)\n          else if (_errorMessage != null)"
);

content = content.replace(
  "else if (_bookings.isEmpty)",
  "// หากดึงข้อมูลสำเร็จแต่ไม่มีประวัติการจองเลย ให้แสดงหน้าจอว่างเปล่า (Empty State)\n          else if (_bookings.isEmpty)"
);

fs.writeFileSync(file, content);
console.log('Detailed comments added to booking_history_tab.dart');
