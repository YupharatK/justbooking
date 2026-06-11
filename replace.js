const fs = require('fs');
let file = 'lib/users/dorm_detail_page.dart';
let content = fs.readFileSync(file, 'utf8');

const replacements = [
  // Imports
  ["import '../wellcome/login.dart';", "import '../wellcome/login.dart';\nimport '../core/localization/localization_extension.dart';"],
  
  // ScaffoldMessengers in _openMap
  ["const SnackBar(content: Text('ไม่พบพิกัดของหอพักนี้บนแผนที่', style: TextStyle()))", "SnackBar(content: Text(context.l10n.dormDetailMapNotFound, style: TextStyle()))"],
  ["const SnackBar(content: Text('ไม่สามารถเปิดแผนที่ได้', style: TextStyle()))", "SnackBar(content: Text(context.l10n.dormDetailMapLaunchError, style: TextStyle()))"],
  
  // _openWriteReviewSheet texts
  ["const Text('เขียนรีวิว', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))", "Text(context.l10n.dormDetailWriteReview, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))"],
  ["const Text('ให้คะแนนหอพักนี้'", "Text(context.l10n.dormDetailRateDorm"],
  ["const Text('ความคิดเห็น'", "Text(context.l10n.dormDetailComment"],
  ["hintText: 'แบ่งปันประสบการณ์ของคุณกับหอพักนี้...',", "hintText: context.l10n.dormDetailCommentHint,"],
  ["const SnackBar(content: Text('กรุณากรอกความคิดเห็น', style: TextStyle()))", "SnackBar(content: Text(context.l10n.dormDetailCommentRequired, style: TextStyle()))"],
  ["const SnackBar(content: Text('ส่งรีวิวเรียบร้อยแล้ว', style: TextStyle()))", "SnackBar(content: Text(context.l10n.dormDetailReviewSuccess, style: TextStyle()))"],
  ["const SnackBar(content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่', style: TextStyle()))", "SnackBar(content: Text(context.l10n.dormDetailReviewError, style: TextStyle()))"],
  ["const Text('ส่งรีวิว', style: TextStyle(color: Colors.white", "Text(context.l10n.dormDetailSubmitReview, style: TextStyle(color: Colors.white"],
  
  // FutureBuilder texts
  ["const Text('เกิดข้อผิดพลาดในการโหลดข้อมูล')", "Text(context.l10n.dormDetailLoadingError)"],
  ["const Text('กลับ')", "Text(context.l10n.dormDetailBack)"],
  ["const Center(child: Text('ไม่พบข้อมูลหอพัก'))", "Center(child: Text(context.l10n.dormDetailNotFound))"],
  
  // Favorite messages
  ["'บันทึกหอพักนี้เรียบร้อยแล้ว'", "context.l10n.dormDetailSaveSuccess"],
  ["'ยกเลิกการบันทึกหอพักเรียบร้อยแล้ว'", "context.l10n.dormDetailUnsaveSuccess"],
  ["const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึก', style: TextStyle()))", "SnackBar(content: Text(context.l10n.dormDetailSaveError, style: TextStyle()))"],
  
  // Available Status Tag
  ["isAvailable ? 'ว่าง' : 'เต็ม'", "isAvailable ? context.l10n.searchAvailable : context.l10n.searchFull"],
  
  // Rating and Available Rooms
  ["'(${dorm.reviews?.length ?? 0} รีวิว)'", "'(${dorm.reviews?.length ?? 0} ${context.l10n.dormManageReviewUnit.trim()})'"],
  ["const TextSpan(text: 'จำนวนห้องว่าง ')", "TextSpan(text: context.l10n.dormDetailAvailableRooms)"],
  ["text: '$availableRoomsCount ห้อง',", "text: '$availableRoomsCount ${context.l10n.addDormRoomUnit}',"],
  
  // Room Types Section
  ["const Text(\n                                  'ประเภทห้องพัก',", "Text(\n                                  context.l10n.dormDetailRoomTypes,"],
  ["room.facilities.isNotEmpty ? room.facilities.join(', ') : 'ไม่มีข้อมูล'", "room.facilities.isNotEmpty ? room.facilities.join(', ') : context.l10n.dormDetailNoData"],
  ["available: 'ว่าง ${room.availableCount} ห้อง',", "available: context.l10n.homeRoomsLeft(room.availableCount),"],
  
  // Amenities Section
  ["const Text(\n                                  'สิ่งอำนวยความสะดวก',", "Text(\n                                  context.l10n.dormDetailAmenities,"],
  
  // Rules Section
  ["const Text(\n                                  'กฎระเบียบของหอพัก',", "Text(\n                                  context.l10n.dormDetailRules,"],
  
  // Location Section
  ["const Text(\n                                    'สถานที่ตั้ง',", "Text(\n                                    context.l10n.dormDetailLocation,"],
  ["const Text(\n                                        'ดูเส้นทาง',", "Text(\n                                        context.l10n.dormDetailDirections,"],
  ["'ระยะกระจัดจากมหาวิทยาลัย: ${distanceKm.toStringAsFixed(1)} กม.'", "context.l10n.dormDetailDistanceFromUni(distanceKm.toStringAsFixed(1))"],
  
  // Reviews Section
  ["const Text(\n                                    'รีวิวจากผู้เช่า',", "Text(\n                                    context.l10n.dormDetailTenantReviews,"],
  ["const Text(\n                                      'เขียนรีวิว',", "Text(\n                                      context.l10n.dormDetailWriteReview,"],
  ["const Center(\n                                    child: Text(\n                                      'ยังไม่มีรีวิวสำหรับหอพักนี้\\nมาเป็นคนแรกที่รีวิวกันเถอะ!',", "Center(\n                                    child: Text(\n                                      context.l10n.dormDetailNoReviews,"],
  ["'${review.user?.firstName ?? 'ผู้ใช้งาน'}", "'${review.user?.firstName ?? context.l10n.dormManageUserUnknown}"],
  ["const Text(\n                                                    'การตอบกลับจากเจ้าของหอพัก',", "Text(\n                                                    context.l10n.dormDetailOwnerReply,"],
  
  // Bottom Action Bar
  ["const Text(\n                            'ราคาเริ่มต้น',", "Text(\n                            context.l10n.dormDetailStartingPrice,"],
  ["const Text(\n                                'บาท',", "Text(\n                                context.l10n.dormDetailCurrency,"],
  ["tooltip: 'แชทสอบถาม',", "tooltip: context.l10n.dormDetailChatTooltip,"],
  ["const Text(\n                              'ดูห้องพัก',", "Text(\n                              context.l10n.dormDetailViewRooms,"],
  
  // Bottom Navigation Bar
  ["label: 'หน้าหลัก',", "label: context.l10n.homeTab,"],
  ["label: 'การจอง',", "label: context.l10n.bookingTab,"],
  ["label: 'ข้อความ',", "label: context.l10n.messageTab,"],
  ["label: 'แจ้งเตือน',", "label: context.l10n.notificationTab,"],
  
  // Build Room Type Card
  ["'บาท/เดือน'", "context.l10n.dormDetailCurrencyPerMonth"]
];

for (let [search, replace] of replacements) {
  if (content.includes(search)) {
    content = content.replace(new RegExp(search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), replace);
  } else {
    console.log('Not found:', search);
  }
}

fs.writeFileSync(file, content);
console.log('Replacement done.');
