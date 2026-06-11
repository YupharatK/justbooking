const fs = require('fs');

const commentsData = {
  'lib/dormitory/dormitory_home_page.dart': {
    'class DormitoryHomePage': '/// หน้าจอหลัก (Dashboard) ของฝั่งเจ้าของหอพัก แสดงรายการหอพักทั้งหมดที่เปิดให้เช่า',
    'Future<void> _fetchUserData': '  // ฟังก์ชันดึงข้อมูลโปรไฟล์ของเจ้าของหอพัก (ชื่อ, รูปโปรไฟล์)',
    'Future<void> _fetchDormitories': '  // ฟังก์ชันดึงข้อมูลรายชื่อหอพักที่เจ้าของคนนี้ดูแลอยู่',
  },
  'lib/dormitory/dormitory_management_page.dart': {
    'class DormitoryManagementPage': '/// หน้าจัดการหอพัก สำหรับแก้ไขข้อมูลหอพัก เพิ่มรูปภาพหน้าปก และเข้าสู่หน้าจัดการห้องพัก',
    'Future<void> _fetchRooms': '  // ฟังก์ชันดึงข้อมูลรายการห้องพักทั้งหมดภายในหอพักนี้',
    'Future<void> _pickAndUploadCoverImage': '  // ฟังก์ชันเลือกรูปภาพจากเครื่องและอัปโหลดเป็นภาพหน้าปกของหอพัก',
  },
  'lib/dormitory/add_dorm_info_page.dart': {
    'class AddDormInfoPage': '/// หน้าฟอร์มสำหรับลงทะเบียนเพิ่มหอพักใหม่เข้าสู่ระบบ',
    'Future<void> _saveDormitory': '  // ฟังก์ชันสำหรับบันทึกข้อมูลหอพักใหม่ส่งไปยัง Backend',
  },
  'lib/dormitory/map_picker_page.dart': {
    'class MapPickerPage': '/// หน้าจอแผนที่เพื่อให้เจ้าของหอพักปักหมุดตำแหน่ง (Latitude, Longitude) ของหอพัก',
    'Future<void> _moveToCurrentLocation': '  // ฟังก์ชันเลื่อนกล้องแผนที่ไปยังตำแหน่งปัจจุบันของผู้ใช้',
    'Future<void> _searchAndNavigate': '  // ฟังก์ชันค้นหาสถานที่บนแผนที่ด้วยชื่อ',
  },
  'lib/dormitory/add_room_page.dart': {
    'class AddRoomPage': '/// หน้าฟอร์มสำหรับเพิ่มประเภทห้องพักใหม่ (เช่น ห้องมาตรฐาน, ห้อง VIP)',
    'Future<void> _pickImages': '  // ฟังก์ชันเลือกรูปภาพห้องพักจากเครื่องมือถือ',
    'Future<void> _saveRoom': '  // ฟังก์ชันบันทึกข้อมูลประเภทห้องพักและอัปโหลดรูปภาพ',
  },
  'lib/dormitory/owner_booking_dashboard.dart': {
    'class OwnerBookingDashboard': '/// หน้าแสดงรายการคำขอจองห้องพักทั้งหมด เพื่อให้เจ้าของหอพักพิจารณาอนุมัติหรือปฏิเสธ',
    'Future<void> _fetchBookings': '  // ฟังก์ชันดึงรายการคำขอจองห้องพักทั้งหมดของหอพักตนเอง',
    'Future<void> _approveBooking': '  // ฟังก์ชันกดยืนยัน/อนุมัติการจองห้องพักให้ผู้เช่า',
    'Future<void> _rejectBooking': '  // ฟังก์ชันปฏิเสธคำขอจองห้องพัก',
    'Future<void> _confirmPayment': '  // ฟังก์ชันยืนยันว่าได้รับเงินตามสลิปโอนเงินแล้ว',
    'Future<void> _rejectPayment': '  // ฟังก์ชันปฏิเสธสลิปโอนเงิน',
  },
  'lib/dormitory/owner_chat_dashboard.dart': {
    'class OwnerChatDashboard': '/// หน้าจอรวมแชทของเจ้าของหอพัก แสดงรายชื่อผู้เช่าที่ทักเข้ามาสอบถาม',
  },
  
  // Users files
  'lib/users/home_page.dart': {
    'class UserHomePage': '/// หน้าจอแรกของฝั่งผู้เช่า (User) แสดงหมวดหมู่และหอพักแนะนำ',
    'Future<void> _fetchInitialData': '  // ฟังก์ชันดึงข้อมูลโปรไฟล์ผู้ใช้และข้อมูลหอพักเบื้องต้นเพื่อนำมาแสดง',
  },
  'lib/users/search_page.dart': {
    'class SearchPage': '/// หน้าค้นหาหอพัก พร้อมตัวกรอง (Filter) แบบละเอียด เช่น ราคา ระยะทาง ประเภทห้อง',
    'Future<void> _searchDormitories': '  // ฟังก์ชันส่งคำค้นหาและตัวกรองไปยัง Backend เพื่อค้นหาหอพัก',
  },
  'lib/users/dorm_detail_page.dart': {
    'class DormDetailPage': '/// หน้าแสดงรายละเอียดแบบเจาะลึกของหอพัก 1 แห่ง รวมถึงรายการห้องพัก สิ่งอำนวยความสะดวก และรีวิว',
    'Future<void> _fetchDormDetail': '  // ฟังก์ชันดึงรายละเอียดทั้งหมดของหอพักนี้จาก API',
    'Future<void> _toggleFavorite': '  // ฟังก์ชันสำหรับกดหัวใจเพื่อบันทึกหรือยกเลิกรายการโปรด',
  },
  'lib/users/room_types_page.dart': {
    'class RoomTypesPage': '/// หน้าแสดงรายการประเภทห้องพักทั้งหมดที่มีในหอพักนี้ (เช่น ห้องพัดลม, ห้องแอร์)',
    'Future<void> _showBookingModal': '  // ฟังก์ชันเปิดหน้าต่างสำหรับยืนยันการจองห้องพักและเลือกวันที่ย้ายเข้า',
  },
  'lib/users/booking_history_tab.dart': {
    'class BookingHistoryTab': '/// หน้าแสดงประวัติการจองห้องพักทั้งหมดของผู้ใช้งาน พร้อมบอกสถานะการจอง',
    'Future<void> _fetchBookings': '  // ฟังก์ชันดึงประวัติการจองทั้งหมดของผู้ใช้',
  },
  'lib/users/booking_detail_page.dart': {
    'class BookingDetailPage': '/// หน้าแสดงรายละเอียดของคำขอจอง 1 รายการ และเป็นหน้าสำหรับอัปโหลดสลิปชำระเงิน',
    'Future<void> _pickImage': '  // ฟังก์ชันเลือกรูปภาพสลิปโอนเงิน',
    'Future<void> _submitPaymentSlip': '  // ฟังก์ชันอัปโหลดรูปภาพสลิปโอนเงินเพื่อยืนยันการชำระเงิน',
  },
  'lib/users/chat_screen.dart': {
    'class ChatScreen': '/// หน้าห้องแชทสนทนาระหว่างผู้เช่าและเจ้าของหอพัก',
    'Future<void> _sendMessage': '  // ฟังก์ชันส่งข้อความแชทไปหาคู่สนทนา',
  },
  'lib/users/message_page.dart': {
    'class MessagePage': '/// หน้าจอรวมรายการห้องแชททั้งหมดของผู้ใช้งาน',
  },
  'lib/users/profile_page.dart': {
    'class ProfilePage': '/// หน้าจอแสดงโปรไฟล์ของผู้ใช้งาน เมนูตั้งค่าภาษา และปุ่มออกจากระบบ',
    'Future<void> _fetchProfile': '  // ฟังก์ชันดึงข้อมูลโปรไฟล์ผู้ใช้งานปัจจุบัน',
  },
  'lib/users/edit_profile_page.dart': {
    'class EditProfilePage': '/// หน้าฟอร์มสำหรับแก้ไขข้อมูลส่วนตัว เช่น ชื่อ เบอร์โทร ที่อยู่ และรูปโปรไฟล์',
    'Future<void> _saveProfile': '  // ฟังก์ชันบันทึกข้อมูลโปรไฟล์ใหม่ที่แก้ไข',
  },
  'lib/users/favorites_page.dart': {
    'class FavoritesPage': '/// หน้าแสดงรายการหอพักทั้งหมดที่ผู้ใช้เคยกดหัวใจบันทึกเป็นรายการโปรดไว้',
    'Future<void> _fetchFavorites': '  // ฟังก์ชันดึงข้อมูลหอพักที่บันทึกเป็นรายการโปรด',
  }
};

for (const [filePath, markers] of Object.entries(commentsData)) {
  if (!fs.existsSync(filePath)) continue;
  
  let content = fs.readFileSync(filePath, 'utf8');
  let changed = false;
  
  for (const [key, comment] of Object.entries(markers)) {
    // If it's a class comment, we don't need indentation
    let indent = key.startsWith('class') ? '' : '  ';
    
    // Check if comment already exists (or similar)
    if (!content.includes(comment.trim())) {
      // Escape for regex if needed, but simple string replace works for exact match
      // Problem: exact match needs to preserve indentation and space
      // Let's use regex to find the line containing the key
      const regex = new RegExp(`^(\\s*)${key.replace(/\(/g, '\\(').replace(/\)/g, '\\)')}`, 'm');
      const match = content.match(regex);
      if (match) {
        content = content.replace(regex, `$1${comment.trim()}\n$1${key}`);
        changed = true;
      }
    }
  }
  
  if (changed) {
    fs.writeFileSync(filePath, content);
    console.log(`Injected comments into ${filePath}`);
  }
}
