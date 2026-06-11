const fs = require('fs');

let file = 'lib/users/booking_detail_page.dart';
let content = fs.readFileSync(file, 'utf8');

content = content.replace(
  "Future<void> _fetchUser() async {",
  "// ฟังก์ชันสำหรับดึงข้อมูลโปรไฟล์ของผู้ใช้งานปัจจุบัน (เพื่อเอาชื่อและเบอร์โทรมาแสดงในฟอร์ม)\n  Future<void> _fetchUser() async {"
);

content = content.replace(
  "final user = await AuthService().getCurrentUser();",
  "// เรียก API ดึงข้อมูล User จากระบบ Authentication\n      final user = await AuthService().getCurrentUser();"
);

content = content.replace(
  "// Perform booking confirmation\n  Future<void> _confirmBooking() async {",
  "// ฟังก์ชันสำหรับกดยืนยันการจองห้องพัก\n  // จะทำงานเมื่อผู้ใช้กดปุ่ม 'ยืนยันการจอง' ด้านล่างจอ\n  Future<void> _confirmBooking() async {"
);

content = content.replace(
  "// 1. Create booking\n      final bookingId = await _bookingService.createBooking(",
  "// 1. เรียก API ส่งคำขอจองห้องพัก (createBooking) พร้อมแนบ ID ห้องและวันที่ย้ายเข้า\n      final bookingId = await _bookingService.createBooking("
);

content = content.replace(
  "// 3. Trigger Notification (fire and forget so it doesn't block UI)",
  "// 2. ส่งการแจ้งเตือน (Push Notification) ไปหาเจ้าของหอพัก\n      // (ทำงานแบบเบื้องหลัง fire and forget เพื่อไม่ให้แอปค้างระหว่างรอ)"
);

content = content.replace(
  "// Show booking success dialog\n      showDialog(",
  "// 3. แสดงหน้าต่าง Popup (Dialog) แจ้งเตือนว่า 'ส่งคำขอจองสำเร็จ'\n      showDialog("
);

content = content.replace(
  "// Animated green check circle",
  "// สร้างแอนิเมชันไอคอนเครื่องหมายถูก (Check Circle) สีเขียว"
);

content = content.replace(
  "// Summary card\n                  Container(",
  "// กล่องสรุปรายละเอียดการจอง (ชื่อหอพัก, ประเภทห้อง, ยอดเงิน)\n                  Container("
);

content = content.replace(
  "// Builder helper for tenant rows\n  Widget _buildTenantRow",
  "// ฟังก์ชันตัวช่วย (Helper) สำหรับวาดบรรทัดข้อมูลผู้เช่าแต่ละแถว (เช่น ชื่อ, เบอร์โทร)\n  // label คือหัวข้อ (เช่น 'ชื่อ-นามสกุล'), value คือค่าที่จะแสดง\n  // ถ้า isPill = true จะตีกรอบพื้นหลังสีเทาอ่อนให้ค่า value (เช่น กรอบใส่วันที่)\n  Widget _buildTenantRow"
);

content = content.replace(
  "// CARD 1: Dorm Summary Card",
  "// กล่องการ์ดที่ 1: สรุปข้อมูลหอพักและห้องพักที่กำลังจอง รวมถึงราคาและค่ามัดจำ"
);

content = content.replace(
  "// CARD 2: Tenant Info Card (\"ข้อมูลผู้จอง\")",
  "// กล่องการ์ดที่ 2: ข้อมูลส่วนตัวของผู้เช่าที่จะถูกส่งไปให้เจ้าของหอพิจารณา"
);

content = content.replace(
  "// BOTTOM CONTROL BAR: Price summary & Booking button",
  "// แถบเมนูด้านล่างสุด (Bottom Bar): แสดงยอดรวมที่ต้องจ่าย และปุ่มกดยืนยันการจอง"
);

fs.writeFileSync(file, content);
console.log('Finished commenting booking_detail_page.dart');
