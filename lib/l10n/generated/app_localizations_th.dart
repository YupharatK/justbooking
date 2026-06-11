// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Just Booking';

  @override
  String get profileEdit => 'แก้ไขโปรไฟล์';

  @override
  String get profileFavorites => 'รายการโปรด';

  @override
  String get profileChangeLanguage => 'เปลี่ยนภาษา';

  @override
  String get profileLogout => 'ออกจากระบบ';

  @override
  String get profileLogoutConfirmTitle => 'ออกจากระบบ';

  @override
  String get profileLogoutConfirmDesc =>
      'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบบัญชีผู้ใช้นี้?';

  @override
  String get profileLogoutCancel => 'ยกเลิก';

  @override
  String get profileLogoutConfirmBtn => 'ยืนยันการออกจากระบบ';

  @override
  String get profileCameraToast =>
      'กำลังเปิดกล้องถ่ายรูปเพื่อเปลี่ยนโปรไฟล์...';

  @override
  String get profileLoadError => 'เกิดข้อผิดพลาดในการโหลดข้อมูลผู้ใช้';

  @override
  String get profileUnknownUser => 'ผู้ใช้งานระบบ';

  @override
  String get languageTitle => 'เปลี่ยนภาษา';

  @override
  String get languageThai => 'ภาษาไทย';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get languageConfirm => 'ยืนยัน';

  @override
  String get homeTab => 'หน้าหลัก';

  @override
  String get bookingTab => 'การจอง';

  @override
  String get messageTab => 'ข้อความ';

  @override
  String get notificationTab => 'แจ้งเตือน';

  @override
  String get homeSearchHint => 'ค้นหาหอพัก, ทำเล, หรือราคา..';

  @override
  String get homeRecentSearches => 'ค้นหาล่าสุด';

  @override
  String get homeSeeAll => 'ดูทั้งหมด';

  @override
  String get homeNoDormsFound => 'ไม่พบข้อมูลหอพัก';

  @override
  String get homePopularDorms => 'หอพักที่เป็นที่นิยม';

  @override
  String get homeRecommended => 'แนะนำเพิ่มเติม';

  @override
  String get homeAvailable => 'ว่าง';

  @override
  String get homePerMonth => '/เดือน';

  @override
  String homeRoomsLeft(int count) {
    return 'ว่าง $count ห้อง';
  }

  @override
  String get homeFull => 'เต็มแล้ว';

  @override
  String homeDistanceFromUni(String dist) {
    return '$dist กม. จาก ม.';
  }

  @override
  String get homeAirConFan => 'แอร์/พัดลม';

  @override
  String get homeNotificationsTitle => 'การแจ้งเตือน';

  @override
  String get homeReadAll => 'อ่านทั้งหมด';

  @override
  String get bookingStatusPendingOwnerApproval => 'รอเจ้าของอนุมัติ';

  @override
  String get bookingStatusPendingPayment => 'รอชำระเงิน';

  @override
  String get bookingStatusCompleted => 'เสร็จสิ้น';

  @override
  String get bookingStatusRejected => 'ถูกปฏิเสธ';

  @override
  String get bookingStatusCancelled => 'ยกเลิก';

  @override
  String get bookingPaymentUploadError => 'เกิดข้อผิดพลาดในการอัปโหลดสลิป';

  @override
  String get bookingNoBank => 'ไม่ระบุธนาคาร';

  @override
  String get bookingNoAccountName => 'ไม่ระบุชื่อบัญชี';

  @override
  String get bookingNoAccountNumber => 'ไม่ระบุเลขบัญชี';

  @override
  String get bookingPaymentTitle => 'ชำระเงินค่าจอง';

  @override
  String get bookingPaymentAmount => 'ยอดชำระ';

  @override
  String get bookingBank => 'ธนาคาร';

  @override
  String get bookingAccountName => 'ชื่อบัญชี';

  @override
  String get bookingAccountNumber => 'เลขบัญชี';

  @override
  String get bookingScanPromptPay => 'สแกนเพื่อชำระเงิน (PromptPay)';

  @override
  String get bookingPaymentSubmitted =>
      'ชำระเงินเรียบร้อยแล้ว (รอเจ้าของตรวจสอบสลิป)';

  @override
  String get bookingYourSlip => 'ภาพสลิปของคุณ:';

  @override
  String get bookingSelectSlip => 'เลือกสลิปโอนเงิน';

  @override
  String get bookingChangeSlip => 'เปลี่ยนรูปสลิป';

  @override
  String get bookingSubmitSlip => 'ส่งหลักฐานการชำระเงิน';

  @override
  String get bookingConfirmSuccessTitle => 'ยืนยันการจองสำเร็จ!';

  @override
  String get bookingConfirmSuccessDesc =>
      'จองห้องพักสำเร็จแล้ว กรุณาไปที่หน้ารายการจองของคุณเพื่อชำระเงินและแนบสลิปการโอนเงิน';

  @override
  String get bookingDormitory => 'หอพัก';

  @override
  String get bookingRoomType => 'ประเภทห้อง';

  @override
  String get bookingOkViewList => 'ตกลง (ดูรายการจอง)';

  @override
  String get bookingCreateError => 'เกิดข้อผิดพลาดในการจอง กรุณาลองใหม่';

  @override
  String get bookingDetailTitle => 'รายละเอียดการจอง';

  @override
  String get bookingRoom => 'ห้อง';

  @override
  String get bookingNoFacilities => 'ไม่มีข้อมูลสิ่งอำนวยความสะดวก';

  @override
  String get bookingPriceLabel => 'ราคา ';

  @override
  String get bookingPerMonthDeposit => ' ต่อเดือน • ค่าประกัน ';

  @override
  String get bookingOneYearContract => '\nสัญญา 1 ปี';

  @override
  String get bookingTenantInfo => 'ข้อมูลผู้จอง';

  @override
  String get commonLoading => 'กำลังโหลด...';

  @override
  String get bookingTenantName => 'ชื่อ-นามสกุล';

  @override
  String get bookingTenantPhone => 'เบอร์โทรศัพท์';

  @override
  String get bookingTenantAddress => 'ที่อยู่';

  @override
  String get bookingStartDate => 'วันที่เริ่มจอง';

  @override
  String get bookingConfirmButton => 'ยืนยันการจอง';

  @override
  String get bookingHistoryTitle => 'การจองของคุณ';

  @override
  String get bookingHistorySubtitle => 'ติดตามสถานะการจองและการทำสัญญาหอพัก';

  @override
  String get bookingHistoryEmpty => 'ไม่มีประวัติการจองก่อนหน้านี้';

  @override
  String get bookingNoDormName => 'ไม่ระบุชื่อหอพัก';

  @override
  String get bookingNoRoomInfo => 'ไม่มีข้อมูลห้อง';

  @override
  String get bookingIdPrefix => 'รหัสการจอง #JB';

  @override
  String get bookingDepositFee => 'ค่ามัดจำสัญญา';

  @override
  String get bookingWaitingOwnerConfirm => 'รอเจ้าของยืนยัน';

  @override
  String get bookingSlipRejected => 'สลิปถูกปฏิเสธ กรุณาแนบใหม่';

  @override
  String get bookingAttachSlip => 'แนบสลิปชำระเงิน';

  @override
  String get bookingStatusPendingPaymentVerification => 'รอตรวจสอบชำระเงิน';

  @override
  String get ownerBookingTitle => 'จัดการคำขอจอง';

  @override
  String get ownerBookingEmpty => 'ยังไม่มีคำขอจอง';

  @override
  String get ownerBookingFetchError => 'เกิดข้อผิดพลาดในการดึงข้อมูลการจอง';

  @override
  String get ownerBookingUpdateSuccess => 'อัปเดตสถานะสำเร็จ';

  @override
  String get ownerBookingUpdateError => 'เกิดข้อผิดพลาด: ';

  @override
  String get ownerBookingTenant => 'ผู้จอง: ';

  @override
  String get ownerBookingPhone => 'เบอร์โทรศัพท์: ';

  @override
  String get ownerBookingAddress => 'ที่อยู่: ';

  @override
  String get ownerBookingEmail => 'อีเมล: ';

  @override
  String get ownerBookingDorm => 'หอพัก: ';

  @override
  String get ownerBookingRoom => 'ห้อง: ';

  @override
  String get ownerBookingMoveIn => 'วันที่เข้าอยู่: ';

  @override
  String get ownerBookingDate => 'วันที่จอง: ';

  @override
  String get ownerBookingSlip => 'หลักฐานการโอนเงิน:';

  @override
  String get ownerBookingReject => 'ปฏิเสธ';

  @override
  String get ownerBookingApprove => 'อนุมัติ';

  @override
  String get ownerBookingRejectSlip => 'ปฏิเสธสลิป';

  @override
  String get ownerBookingVerifySlip => 'ยืนยันรับเงิน';

  @override
  String get ownerBookingConfirmTitle => 'ยืนยัน';

  @override
  String get ownerBookingConfirmApprove =>
      'คุณต้องการอนุมัติการจองนี้ใช่หรือไม่?';

  @override
  String get ownerBookingConfirmReject =>
      'คุณต้องการปฏิเสธการจองนี้ใช่หรือไม่?';

  @override
  String get ownerBookingCancel => 'ยกเลิก';

  @override
  String get ownerBookingConfirmSlipTitle => 'ยืนยันตรวจสอบสลิป';

  @override
  String get ownerBookingConfirmSlipVerify =>
      'คุณต้องการยืนยันการรับเงินใช่หรือไม่?';

  @override
  String get ownerBookingConfirmSlipReject =>
      'คุณต้องการปฏิเสธสลิปนี้ใช่หรือไม่?';

  @override
  String get ownerBookingSlipUpdateSuccess => 'อัปเดตสลิปสำเร็จ';

  @override
  String get dormManageDeleteConfirmTitle => 'ยืนยันการลบ';

  @override
  String get dormManageDeleteConfirmDesc =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบหอพักนี้? การกระทำนี้ไม่สามารถย้อนกลับได้';

  @override
  String get dormManageDeleteSuccess => 'ลบหอพักสำเร็จ';

  @override
  String get dormManageDeleteError => 'ลบหอพักไม่สำเร็จ';

  @override
  String get dormManageEditTooltip => 'แก้ไขข้อมูลหอพัก';

  @override
  String get dormManageDeleteTooltip => 'ลบหอพัก';

  @override
  String get dormManageRoomTypesTitle => 'ประเภทห้องพักทั้งหมด';

  @override
  String get dormManageRoomUnit => ' ห้อง';

  @override
  String get dormManageNoRooms => 'ยังไม่มีข้อมูลห้องพัก';

  @override
  String get dormManageAddRoomHint => 'กรุณากดปุ่มเพิ่มห้องพักด้านล่าง';

  @override
  String get dormManageReviewsTitle => 'รีวิวจากผู้เช่า';

  @override
  String get dormManageReviewUnit => ' รีวิว';

  @override
  String get dormManageNoReviews => 'ยังไม่มีรีวิว';

  @override
  String get dormManageAddRoomBtn => 'เพิ่มห้องพัก';

  @override
  String get dormManageStatusPending => 'กำลังตรวจสอบ';

  @override
  String get dormManageStatusApproved => 'อนุมัติแล้ว';

  @override
  String get dormManageStatusRejected => 'ถูกปฏิเสธ';

  @override
  String get dormManageRoomTypeLabel => 'ประเภทห้อง';

  @override
  String get dormManageAvailable => 'ว่าง ';

  @override
  String get dormManageFull => 'เต็มแล้ว';

  @override
  String get dormManageDeleteRoomConfirm => 'คุณต้องการลบห้องพักนี้ใช่หรือไม่?';

  @override
  String get dormManageEdit => 'แก้ไข';

  @override
  String get dormManageDelete => 'ลบ';

  @override
  String get dormManageDeleteRoomSuccess => 'ลบห้องพักสำเร็จ';

  @override
  String get dormManageDeleteRoomError => 'ลบห้องพักไม่สำเร็จ';

  @override
  String get dormManagePerMonth => ' / เดือน';

  @override
  String get dormManageUserUnknown => 'ผู้ใช้งาน';

  @override
  String get dormManageYourReply => 'การตอบกลับของคุณ';

  @override
  String get dormManageReplyBtn => 'ตอบกลับ';

  @override
  String get dormManageReplyTitle => 'ตอบกลับรีวิว';

  @override
  String get dormManageReplyHint => 'พิมพ์ข้อความตอบกลับของคุณที่นี่...';

  @override
  String get dormManageReplyEmptyError => 'กรุณาพิมพ์ข้อความตอบกลับ';

  @override
  String get dormManageReplySuccess => 'ส่งข้อความตอบกลับสำเร็จ';

  @override
  String get dormManageReplyError => 'เกิดข้อผิดพลาดในการตอบกลับ';

  @override
  String get dormManageSendReplyBtn => 'ส่งข้อความตอบกลับ';

  @override
  String get searchError => 'เกิดข้อผิดพลาดในการค้นหา';

  @override
  String get searchFilterTitle => 'ตัวกรองการค้นหา';

  @override
  String get searchFilterClear => 'ล้างตัวกรอง';

  @override
  String get searchFilterPrice => 'ราคา (ไม่เกิน ฿';

  @override
  String get searchFilterPricePerMonth => '/เดือน)';

  @override
  String get searchFilterDistance => 'ระยะห่างจาก ม. (ไม่เกิน ';

  @override
  String get searchFilterDistanceKm => ' กม.)';

  @override
  String get searchFilterApply => 'ตกลง';

  @override
  String get searchPageTitle => 'ค้นหาหอพักที่ใช่';

  @override
  String get searchHint => 'ค้นหาชื่อหอพัก...';

  @override
  String get searchResultCountTitle => 'ผลการค้นหา (';

  @override
  String get searchNoResults => 'ไม่พบหอพักที่ตรงกับเงื่อนไข';

  @override
  String get searchPriceLabel => 'ราคา ';

  @override
  String get searchDistanceLabel => 'ห่าง ม. ';

  @override
  String get searchAvailable => 'ว่าง';

  @override
  String get searchFull => 'เต็ม';

  @override
  String get addRoomAc => 'แอร์';

  @override
  String get addRoomFan => 'พัดลม';

  @override
  String get addRoomSingleBed => 'เตียงเดี่ยว';

  @override
  String get addRoomDoubleBed => 'เตียงคู่';

  @override
  String get addRoomValidationPriceError => 'กรุณากรอกราคาและจำนวนห้องว่าง';

  @override
  String get addRoomValidationImageError =>
      'กรุณาเลือกรูปห้องตัวอย่างอย่างน้อย 1 รูป';

  @override
  String get addRoomSuccess => 'เพิ่มข้อมูลห้องพักสำเร็จ';

  @override
  String get addRoomError => 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';

  @override
  String get addRoomTitleAdd => 'เพิ่มห้องพัก';

  @override
  String get addRoomTitleEdit => 'แก้ไขห้องพัก';

  @override
  String get addRoomPhotos => 'รูปถ่ายห้องพัก';

  @override
  String get addRoomPhotoLimit => ' / 5 รูป';

  @override
  String get addRoomPhotoAdd => 'เพิ่มรูปภาพ (สูงสุด 5 รูป)';

  @override
  String get addRoomNumberTitle => 'หมายเลขห้อง / ชื่อประเภทห้อง';

  @override
  String get addRoomNumberHint => 'เช่น A101 หรือ ห้องสแตนดาร์ด';

  @override
  String get addRoomAvailableTitle => 'จำนวนห้องที่ว่าง (ห้อง)';

  @override
  String get addRoomAvailableHint => 'ระบุจำนวนห้องว่าง เช่น 5';

  @override
  String get addRoomCoolingTitle => 'ประเภทระบบทำความเย็น';

  @override
  String get addRoomCoolingAc => 'ห้องแอร์';

  @override
  String get addRoomCoolingFan => 'ห้องพัดลม';

  @override
  String get addRoomBedTitle => 'ประเภทเตียง';

  @override
  String get addRoomPriceTitle => 'ราคาเริ่มต้น (บาท/เดือน)';

  @override
  String get addRoomPriceHint => 'เช่น 4500';

  @override
  String get addRoomFacilitiesTitle => 'สิ่งอำนวยความสะดวก';

  @override
  String get addRoomSaveBtn => 'บันทึกข้อมูล';

  @override
  String get addDormTitleAdd => 'เพิ่มข้อมูลหอพัก';

  @override
  String get addDormTitleEdit => 'แก้ไขข้อมูลหอพัก';

  @override
  String get addDormCoverImage => 'รูปหน้าปกหอพัก';

  @override
  String get addDormImageHint => 'แตะเพื่อเลือกรูปภาพ';

  @override
  String get addDormNameTitle => 'ชื่อหอพัก';

  @override
  String get addDormNameHint => 'ระบุชื่อหอพักของคุณ';

  @override
  String get addDormTypeTitle => 'ประเภทหอพัก';

  @override
  String get addDormTypeMixed => 'หอพักรวม';

  @override
  String get addDormTypeMale => 'หอพักชาย';

  @override
  String get addDormTypeFemale => 'หอพักหญิง';

  @override
  String get addDormAddressTitle => 'ที่อยู่และพิกัด';

  @override
  String get addDormAddressHint => 'ระบุเลขที่บ้าน ถนน แขวง/ตำบล...';

  @override
  String get addDormMapChange => 'เปลี่ยนพิกัดบนแผนที่';

  @override
  String get addDormMapSelect => 'เลือกพิกัดจากแผนที่';

  @override
  String get addDormStatusTitle => 'สถานะและความพร้อม';

  @override
  String get addDormStatusReady => 'พร้อมเข้าอยู่';

  @override
  String get addDormStatusOneMonth => 'ว่างภายใน 1 เดือน';

  @override
  String get addDormAvailableCountTitle => 'จำนวนห้องพักที่ว่าง';

  @override
  String get addDormRoomUnit => 'ห้อง';

  @override
  String get addDormRulesTitle => 'เงื่อนไขในการเช่าและกฎระเบียบ';

  @override
  String get addDormRulesHint =>
      'เช่น ค่ามัดจำ 2 เดือน, สัญญา 1 ปี, ห้ามเลี้ยงสัตว์...';

  @override
  String get addDormPaymentTitle =>
      'ข้อมูลบัญชีรับเงิน (สำหรับรับค่าจอง/มัดจำ)';

  @override
  String get addDormBankHint => 'ธนาคาร (เช่น กสิกรไทย)';

  @override
  String get addDormAccountNameHint => 'ชื่อบัญชี (เช่น นายสมชาย ใจดี)';

  @override
  String get addDormAccountNumberHint => 'เลขบัญชี';

  @override
  String get addDormPromptPayHint => 'PromptPay (เบอร์โทร หรือ เลขบัตรประชาชน)';

  @override
  String get addDormSaveBtn => 'บันทึกข้อมูล';

  @override
  String get addDormValidationError => 'กรุณากรอกชื่อและที่อยู่หอพัก';

  @override
  String get addDormAddSuccess => 'เพิ่มข้อมูลหอพักสำเร็จ';

  @override
  String get addDormEditSuccess => 'อัปเดตข้อมูลหอพักสำเร็จ';

  @override
  String get addDormError => 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';

  @override
  String get chatNoDormitory => 'คุณยังไม่มีหอพัก';

  @override
  String get chatTitlePrefix => 'แชท - ';

  @override
  String get chatErrorLoading => 'เกิดข้อผิดพลาดในการโหลดแชท';

  @override
  String get chatNoMessages => 'ยังไม่มีข้อความ';

  @override
  String get chatUserUnknown => 'ผู้ใช้';

  @override
  String get chatFailedUserInfo => 'โหลดข้อมูลผู้ใช้ล้มเหลว';

  @override
  String get chatFailedSendMessage => 'ส่งข้อความล้มเหลว';

  @override
  String get chatErrorTitle => 'เกิดข้อผิดพลาด';

  @override
  String get chatLoginRequired => 'กรุณาเข้าสู่ระบบเพื่อใช้แชท';

  @override
  String get chatStartConversation => 'เริ่มการสนทนาได้เลย!';

  @override
  String get chatHintText => 'พิมพ์ข้อความ...';

  @override
  String get dormDetailMapNotFound => 'ไม่พบพิกัดของหอพักนี้บนแผนที่';

  @override
  String get dormDetailMapLaunchError => 'ไม่สามารถเปิดแผนที่ได้';

  @override
  String get dormDetailWriteReview => 'เขียนรีวิว';

  @override
  String get dormDetailRateDorm => 'ให้คะแนนหอพักนี้';

  @override
  String get dormDetailComment => 'ความคิดเห็น';

  @override
  String get dormDetailCommentHint => 'แบ่งปันประสบการณ์ของคุณกับหอพักนี้...';

  @override
  String get dormDetailCommentRequired => 'กรุณากรอกความคิดเห็น';

  @override
  String get dormDetailReviewSuccess => 'ส่งรีวิวเรียบร้อยแล้ว';

  @override
  String get dormDetailReviewError => 'เกิดข้อผิดพลาด กรุณาลองใหม่';

  @override
  String get dormDetailSubmitReview => 'ส่งรีวิว';

  @override
  String get dormDetailLoadingError => 'เกิดข้อผิดพลาดในการโหลดข้อมูล';

  @override
  String get dormDetailBack => 'กลับ';

  @override
  String get dormDetailNotFound => 'ไม่พบข้อมูลหอพัก';

  @override
  String get dormDetailAvailableRooms => 'จำนวนห้องว่าง ';

  @override
  String get dormDetailRoomTypes => 'ประเภทห้องพัก';

  @override
  String get dormDetailNoData => 'ไม่มีข้อมูล';

  @override
  String get dormDetailAmenities => 'สิ่งอำนวยความสะดวก';

  @override
  String get dormDetailRules => 'กฎระเบียบของหอพัก';

  @override
  String get dormDetailLocation => 'สถานที่ตั้ง';

  @override
  String get dormDetailDirections => 'ดูเส้นทาง';

  @override
  String dormDetailDistanceFromUni(String dist) {
    return 'ระยะกระจัดจากมหาวิทยาลัย: $dist กม.';
  }

  @override
  String get dormDetailTenantReviews => 'รีวิวจากผู้เช่า';

  @override
  String get dormDetailNoReviews =>
      'ยังไม่มีรีวิวสำหรับหอพักนี้\nมาเป็นคนแรกที่รีวิวกันเถอะ!';

  @override
  String get dormDetailOwnerReply => 'การตอบกลับจากเจ้าของหอพัก';

  @override
  String get dormDetailStartingPrice => 'ราคาเริ่มต้น';

  @override
  String get dormDetailCurrency => 'บาท';

  @override
  String get dormDetailCurrencyPerMonth => 'บาท/เดือน';

  @override
  String get dormDetailChatTooltip => 'แชทสอบถาม';

  @override
  String get dormDetailViewRooms => 'ดูห้องพัก';

  @override
  String get dormDetailSaveSuccess => 'บันทึกหอพักนี้เรียบร้อยแล้ว';

  @override
  String get dormDetailUnsaveSuccess => 'ยกเลิกการบันทึกหอพักเรียบร้อยแล้ว';

  @override
  String get dormDetailSaveError => 'เกิดข้อผิดพลาดในการบันทึก';

  @override
  String get facilityWifi => 'Wi-Fi';

  @override
  String get facilityWaterHeater => 'เครื่องทำน้ำอุ่น';

  @override
  String get facilityBalcony => 'ระเบียง';

  @override
  String get facilityTv => 'ทีวี';
}
