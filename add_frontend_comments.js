const fs = require('fs');
const path = require('path');

const comments = {
  // admin_service.dart
  'getUsers': '// ฟังก์ชันสำหรับดึงข้อมูลผู้ใช้งานทั้งหมดในระบบ (สำหรับ Admin)',
  'updateUserStatus': '// ฟังก์ชันสำหรับอัปเดตสถานะของผู้ใช้งาน เช่น ระงับบัญชี หรือเปิดใช้งาน (สำหรับ Admin)',
  'getPendingDormitories': '// ฟังก์ชันสำหรับดึงรายการหอพักที่รอการอนุมัติ (สำหรับ Admin)',
  'approveDormitory': '// ฟังก์ชันสำหรับอนุมัติหอพักให้แสดงในระบบ (สำหรับ Admin)',
  'rejectDormitory': '// ฟังก์ชันสำหรับปฏิเสธการลงทะเบียนหอพักพร้อมระบุเหตุผล (สำหรับ Admin)',
  'getBookings': '// ฟังก์ชันสำหรับดึงข้อมูลการจองทั้งหมดในระบบ (สำหรับ Admin)',
  'hideReview': '// ฟังก์ชันสำหรับซ่อนรีวิวที่ไม่เหมาะสม (สำหรับ Admin)',
  
  // auth_service.dart
  'login': '// ฟังก์ชันสำหรับตรวจสอบอีเมลและรหัสผ่านเพื่อเข้าสู่ระบบ',
  'register': '// ฟังก์ชันสำหรับลงทะเบียนผู้ใช้ใหม่ (ทั้งผู้เช่าและเจ้าของหอพัก)',
  'getCurrentUser': '// ฟังก์ชันสำหรับดึงข้อมูลโปรไฟล์ของผู้ใช้งานที่เข้าสู่ระบบอยู่',
  'updateProfile': '// ฟังก์ชันสำหรับอัปเดตข้อมูลโปรไฟล์ส่วนตัว',
  'logout': '// ฟังก์ชันสำหรับออกจากระบบและลบ token ที่บันทึกไว้',
  'isLoggedIn': '// ฟังก์ชันสำหรับตรวจสอบว่าผู้ใช้ได้เข้าสู่ระบบไว้หรือไม่',

  // booking_service.dart
  'createBooking': '// ฟังก์ชันสำหรับส่งคำขอจองห้องพักไปยังเจ้าของหอพัก',
  'getMyBookings': '// ฟังก์ชันสำหรับดึงประวัติการจองทั้งหมดของผู้ใช้',
  'submitPaymentSlip': '// ฟังก์ชันสำหรับอัปโหลดภาพสลิปโอนเงินเพื่อยืนยันการชำระเงิน',

  // chat_service.dart
  'sendMessage': '// ฟังก์ชันสำหรับส่งข้อความแชทไปหาเจ้าของหอพักหรือผู้เช่า',
  'markAsRead': '// ฟังก์ชันสำหรับทำเครื่องหมายว่าอ่านข้อความในแชทแล้ว',

  // dormitory_service.dart
  'searchDormitories': '// ฟังก์ชันสำหรับค้นหาและกรองรายการหอพัก',
  'getDormitoryDetail': '// ฟังก์ชันสำหรับดึงรายละเอียดแบบเจาะลึกของหอพักและห้องพักทั้งหมด',
  'getFavorites': '// ฟังก์ชันสำหรับดึงรายการหอพักที่บันทึกเป็นรายการโปรดไว้',
  'addFavorite': '// ฟังก์ชันสำหรับกดหัวใจ (บันทึก) หอพักลงในรายการโปรด',
  'removeFavorite': '// ฟังก์ชันสำหรับยกเลิกการบันทึกหอพักออกจากรายการโปรด',
  'createReview': '// ฟังก์ชันสำหรับเขียนรีวิวและให้คะแนนหอพัก',

  // map_search_service.dart
  'searchPlace': '// ฟังก์ชันสำหรับค้นหาสถานที่บนแผนที่ด้วยชื่อหรือที่อยู่',

  // notification_service.dart
  'init': '// ฟังก์ชันสำหรับเตรียมความพร้อมและขอสิทธิ์การแจ้งเตือน',
  'getToken': '// ฟังก์ชันสำหรับดึง FCM Token ของเครื่องเพื่อใช้ส่ง Push Notification',
  'createBookingNotification': '// ฟังก์ชันสำหรับสร้างการแจ้งเตือนเมื่อมีการจองห้องพักใหม่',
  'createApprovalNotification': '// ฟังก์ชันสำหรับสร้างการแจ้งเตือนเมื่อเจ้าของหอพักอนุมัติการจอง',
  'createPaymentSlipNotification': '// ฟังก์ชันสำหรับสร้างการแจ้งเตือนเมื่อผู้เช่าส่งสลิปชำระเงิน',

  // owner_service.dart
  'getMyDormitories': '// ฟังก์ชันสำหรับดึงรายการหอพักทั้งหมดที่เจ้าของดูแลอยู่',
  'createDormitory': '// ฟังก์ชันสำหรับลงทะเบียนเพิ่มหอพักใหม่เข้าสู่ระบบ',
  'updateDormitory': '// ฟังก์ชันสำหรับแก้ไขข้อมูลหอพัก',
  'deleteDormitory': '// ฟังก์ชันสำหรับลบข้อมูลหอพักออกจากระบบ',
  'uploadDormitoryCoverImage': '// ฟังก์ชันสำหรับอัปโหลดรูปภาพหน้าปกของหอพัก',
  'createRoom': '// ฟังก์ชันสำหรับเพิ่มประเภทห้องพักใหม่ในหอพัก',
  'updateRoom': '// ฟังก์ชันสำหรับแก้ไขข้อมูลและราคาห้องพัก',
  'deleteRoom': '// ฟังก์ชันสำหรับลบประเภทห้องพัก',
  'uploadRoomImages': '// ฟังก์ชันสำหรับอัปโหลดรูปภาพหลายๆ รูปของห้องพัก',
  'getOwnerBookings': '// ฟังก์ชันสำหรับดึงรายการคำขอจองทั้งหมดที่ส่งเข้ามาที่หอพัก',
  'approveBooking': '// ฟังก์ชันสำหรับอนุมัติคำขอจองห้องพักของผู้เช่า',
  'rejectBooking': '// ฟังก์ชันสำหรับปฏิเสธคำขอจองห้องพัก',
  'confirmPaymentSlip': '// ฟังก์ชันสำหรับตรวจสอบและยืนยันว่าได้รับเงินตามสลิปโอนเงินแล้ว',
  'rejectPaymentSlip': '// ฟังก์ชันสำหรับปฏิเสธสลิปโอนเงิน (กรณีไม่ถูกต้อง)',
  'replyReview': '// ฟังก์ชันสำหรับให้เจ้าของหอพักตอบกลับคอมเมนต์รีวิวของผู้เช่า',
};

const dir = 'lib/services';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.dart'));

for (const file of files) {
  const filePath = path.join(dir, file);
  let content = fs.readFileSync(filePath, 'utf8');
  let changed = false;

  for (const [funcName, comment] of Object.entries(comments)) {
    // Matches: Future<Return> funcName(
    // or static Future<Return> funcName(
    const regex = new RegExp(`(Future\\s*<[^>]+>\\s+${funcName}\\s*\\()`, 'g');
    
    // Check if it already has the comment to avoid duplicates
    if (content.match(regex) && !content.includes(comment)) {
      content = content.replace(regex, `  ${comment}\n  $1`);
      changed = true;
    }
  }

  if (changed) {
    fs.writeFileSync(filePath, content);
    console.log(`Updated ${file}`);
  }
}
