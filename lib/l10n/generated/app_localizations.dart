import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In th, this message translates to:
  /// **'Just Booking'**
  String get appTitle;

  /// No description provided for @profileEdit.
  ///
  /// In th, this message translates to:
  /// **'แก้ไขโปรไฟล์'**
  String get profileEdit;

  /// No description provided for @profileFavorites.
  ///
  /// In th, this message translates to:
  /// **'รายการโปรด'**
  String get profileFavorites;

  /// No description provided for @profileChangeLanguage.
  ///
  /// In th, this message translates to:
  /// **'เปลี่ยนภาษา'**
  String get profileChangeLanguage;

  /// No description provided for @profileLogout.
  ///
  /// In th, this message translates to:
  /// **'ออกจากระบบ'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In th, this message translates to:
  /// **'ออกจากระบบ'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmDesc.
  ///
  /// In th, this message translates to:
  /// **'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบบัญชีผู้ใช้นี้?'**
  String get profileLogoutConfirmDesc;

  /// No description provided for @profileLogoutCancel.
  ///
  /// In th, this message translates to:
  /// **'ยกเลิก'**
  String get profileLogoutCancel;

  /// No description provided for @profileLogoutConfirmBtn.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันการออกจากระบบ'**
  String get profileLogoutConfirmBtn;

  /// No description provided for @profileCameraToast.
  ///
  /// In th, this message translates to:
  /// **'กำลังเปิดกล้องถ่ายรูปเพื่อเปลี่ยนโปรไฟล์...'**
  String get profileCameraToast;

  /// No description provided for @profileLoadError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการโหลดข้อมูลผู้ใช้'**
  String get profileLoadError;

  /// No description provided for @profileUnknownUser.
  ///
  /// In th, this message translates to:
  /// **'ผู้ใช้งานระบบ'**
  String get profileUnknownUser;

  /// No description provided for @languageTitle.
  ///
  /// In th, this message translates to:
  /// **'เปลี่ยนภาษา'**
  String get languageTitle;

  /// No description provided for @languageThai.
  ///
  /// In th, this message translates to:
  /// **'ภาษาไทย'**
  String get languageThai;

  /// No description provided for @languageEnglish.
  ///
  /// In th, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In th, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageConfirm.
  ///
  /// In th, this message translates to:
  /// **'ยืนยัน'**
  String get languageConfirm;

  /// No description provided for @homeTab.
  ///
  /// In th, this message translates to:
  /// **'หน้าหลัก'**
  String get homeTab;

  /// No description provided for @bookingTab.
  ///
  /// In th, this message translates to:
  /// **'การจอง'**
  String get bookingTab;

  /// No description provided for @messageTab.
  ///
  /// In th, this message translates to:
  /// **'ข้อความ'**
  String get messageTab;

  /// No description provided for @notificationTab.
  ///
  /// In th, this message translates to:
  /// **'แจ้งเตือน'**
  String get notificationTab;

  /// No description provided for @homeSearchHint.
  ///
  /// In th, this message translates to:
  /// **'ค้นหาหอพัก, ทำเล, หรือราคา..'**
  String get homeSearchHint;

  /// No description provided for @homeRecentSearches.
  ///
  /// In th, this message translates to:
  /// **'ค้นหาล่าสุด'**
  String get homeRecentSearches;

  /// No description provided for @homeSeeAll.
  ///
  /// In th, this message translates to:
  /// **'ดูทั้งหมด'**
  String get homeSeeAll;

  /// No description provided for @homeNoDormsFound.
  ///
  /// In th, this message translates to:
  /// **'ไม่พบข้อมูลหอพัก'**
  String get homeNoDormsFound;

  /// No description provided for @homePopularDorms.
  ///
  /// In th, this message translates to:
  /// **'หอพักที่เป็นที่นิยม'**
  String get homePopularDorms;

  /// No description provided for @homeRecommended.
  ///
  /// In th, this message translates to:
  /// **'แนะนำเพิ่มเติม'**
  String get homeRecommended;

  /// No description provided for @homeAvailable.
  ///
  /// In th, this message translates to:
  /// **'ว่าง'**
  String get homeAvailable;

  /// No description provided for @homePerMonth.
  ///
  /// In th, this message translates to:
  /// **'/เดือน'**
  String get homePerMonth;

  /// No description provided for @homeRoomsLeft.
  ///
  /// In th, this message translates to:
  /// **'ว่าง {count} ห้อง'**
  String homeRoomsLeft(int count);

  /// No description provided for @homeFull.
  ///
  /// In th, this message translates to:
  /// **'เต็มแล้ว'**
  String get homeFull;

  /// No description provided for @homeDistanceFromUni.
  ///
  /// In th, this message translates to:
  /// **'{dist} กม. จาก ม.'**
  String homeDistanceFromUni(String dist);

  /// No description provided for @homeAirConFan.
  ///
  /// In th, this message translates to:
  /// **'แอร์/พัดลม'**
  String get homeAirConFan;

  /// No description provided for @homeNotificationsTitle.
  ///
  /// In th, this message translates to:
  /// **'การแจ้งเตือน'**
  String get homeNotificationsTitle;

  /// No description provided for @homeReadAll.
  ///
  /// In th, this message translates to:
  /// **'อ่านทั้งหมด'**
  String get homeReadAll;

  /// No description provided for @bookingStatusPendingOwnerApproval.
  ///
  /// In th, this message translates to:
  /// **'รอเจ้าของอนุมัติ'**
  String get bookingStatusPendingOwnerApproval;

  /// No description provided for @bookingStatusPendingPayment.
  ///
  /// In th, this message translates to:
  /// **'รอชำระเงิน'**
  String get bookingStatusPendingPayment;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In th, this message translates to:
  /// **'เสร็จสิ้น'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusRejected.
  ///
  /// In th, this message translates to:
  /// **'ถูกปฏิเสธ'**
  String get bookingStatusRejected;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In th, this message translates to:
  /// **'ยกเลิก'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingPaymentUploadError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการอัปโหลดสลิป'**
  String get bookingPaymentUploadError;

  /// No description provided for @bookingNoBank.
  ///
  /// In th, this message translates to:
  /// **'ไม่ระบุธนาคาร'**
  String get bookingNoBank;

  /// No description provided for @bookingNoAccountName.
  ///
  /// In th, this message translates to:
  /// **'ไม่ระบุชื่อบัญชี'**
  String get bookingNoAccountName;

  /// No description provided for @bookingNoAccountNumber.
  ///
  /// In th, this message translates to:
  /// **'ไม่ระบุเลขบัญชี'**
  String get bookingNoAccountNumber;

  /// No description provided for @bookingPaymentTitle.
  ///
  /// In th, this message translates to:
  /// **'ชำระเงินค่าจอง'**
  String get bookingPaymentTitle;

  /// No description provided for @bookingPaymentAmount.
  ///
  /// In th, this message translates to:
  /// **'ยอดชำระ'**
  String get bookingPaymentAmount;

  /// No description provided for @bookingBank.
  ///
  /// In th, this message translates to:
  /// **'ธนาคาร'**
  String get bookingBank;

  /// No description provided for @bookingAccountName.
  ///
  /// In th, this message translates to:
  /// **'ชื่อบัญชี'**
  String get bookingAccountName;

  /// No description provided for @bookingAccountNumber.
  ///
  /// In th, this message translates to:
  /// **'เลขบัญชี'**
  String get bookingAccountNumber;

  /// No description provided for @bookingScanPromptPay.
  ///
  /// In th, this message translates to:
  /// **'สแกนเพื่อชำระเงิน (PromptPay)'**
  String get bookingScanPromptPay;

  /// No description provided for @bookingPaymentSubmitted.
  ///
  /// In th, this message translates to:
  /// **'ชำระเงินเรียบร้อยแล้ว (รอเจ้าของตรวจสอบสลิป)'**
  String get bookingPaymentSubmitted;

  /// No description provided for @bookingYourSlip.
  ///
  /// In th, this message translates to:
  /// **'ภาพสลิปของคุณ:'**
  String get bookingYourSlip;

  /// No description provided for @bookingSelectSlip.
  ///
  /// In th, this message translates to:
  /// **'เลือกสลิปโอนเงิน'**
  String get bookingSelectSlip;

  /// No description provided for @bookingChangeSlip.
  ///
  /// In th, this message translates to:
  /// **'เปลี่ยนรูปสลิป'**
  String get bookingChangeSlip;

  /// No description provided for @bookingSubmitSlip.
  ///
  /// In th, this message translates to:
  /// **'ส่งหลักฐานการชำระเงิน'**
  String get bookingSubmitSlip;

  /// No description provided for @bookingConfirmSuccessTitle.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันการจองสำเร็จ!'**
  String get bookingConfirmSuccessTitle;

  /// No description provided for @bookingConfirmSuccessDesc.
  ///
  /// In th, this message translates to:
  /// **'จองห้องพักสำเร็จแล้ว กรุณาไปที่หน้ารายการจองของคุณเพื่อชำระเงินและแนบสลิปการโอนเงิน'**
  String get bookingConfirmSuccessDesc;

  /// No description provided for @bookingDormitory.
  ///
  /// In th, this message translates to:
  /// **'หอพัก'**
  String get bookingDormitory;

  /// No description provided for @bookingRoomType.
  ///
  /// In th, this message translates to:
  /// **'ประเภทห้อง'**
  String get bookingRoomType;

  /// No description provided for @bookingOkViewList.
  ///
  /// In th, this message translates to:
  /// **'ตกลง (ดูรายการจอง)'**
  String get bookingOkViewList;

  /// No description provided for @bookingCreateError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการจอง กรุณาลองใหม่'**
  String get bookingCreateError;

  /// No description provided for @bookingDetailTitle.
  ///
  /// In th, this message translates to:
  /// **'รายละเอียดการจอง'**
  String get bookingDetailTitle;

  /// No description provided for @bookingRoom.
  ///
  /// In th, this message translates to:
  /// **'ห้อง'**
  String get bookingRoom;

  /// No description provided for @bookingNoFacilities.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีข้อมูลสิ่งอำนวยความสะดวก'**
  String get bookingNoFacilities;

  /// No description provided for @bookingPriceLabel.
  ///
  /// In th, this message translates to:
  /// **'ราคา '**
  String get bookingPriceLabel;

  /// No description provided for @bookingPerMonthDeposit.
  ///
  /// In th, this message translates to:
  /// **' ต่อเดือน • ค่าประกัน '**
  String get bookingPerMonthDeposit;

  /// No description provided for @bookingOneYearContract.
  ///
  /// In th, this message translates to:
  /// **'\nสัญญา 1 ปี'**
  String get bookingOneYearContract;

  /// No description provided for @bookingTenantInfo.
  ///
  /// In th, this message translates to:
  /// **'ข้อมูลผู้จอง'**
  String get bookingTenantInfo;

  /// No description provided for @commonLoading.
  ///
  /// In th, this message translates to:
  /// **'กำลังโหลด...'**
  String get commonLoading;

  /// No description provided for @bookingTenantName.
  ///
  /// In th, this message translates to:
  /// **'ชื่อ-นามสกุล'**
  String get bookingTenantName;

  /// No description provided for @bookingTenantPhone.
  ///
  /// In th, this message translates to:
  /// **'เบอร์โทรศัพท์'**
  String get bookingTenantPhone;

  /// No description provided for @bookingTenantAddress.
  ///
  /// In th, this message translates to:
  /// **'ที่อยู่'**
  String get bookingTenantAddress;

  /// No description provided for @bookingStartDate.
  ///
  /// In th, this message translates to:
  /// **'วันที่เริ่มจอง'**
  String get bookingStartDate;

  /// No description provided for @bookingConfirmButton.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันการจอง'**
  String get bookingConfirmButton;

  /// No description provided for @bookingHistoryTitle.
  ///
  /// In th, this message translates to:
  /// **'การจองของคุณ'**
  String get bookingHistoryTitle;

  /// No description provided for @bookingHistorySubtitle.
  ///
  /// In th, this message translates to:
  /// **'ติดตามสถานะการจองและการทำสัญญาหอพัก'**
  String get bookingHistorySubtitle;

  /// No description provided for @bookingHistoryEmpty.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีประวัติการจองก่อนหน้านี้'**
  String get bookingHistoryEmpty;

  /// No description provided for @bookingNoDormName.
  ///
  /// In th, this message translates to:
  /// **'ไม่ระบุชื่อหอพัก'**
  String get bookingNoDormName;

  /// No description provided for @bookingNoRoomInfo.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีข้อมูลห้อง'**
  String get bookingNoRoomInfo;

  /// No description provided for @bookingIdPrefix.
  ///
  /// In th, this message translates to:
  /// **'รหัสการจอง #JB'**
  String get bookingIdPrefix;

  /// No description provided for @bookingDepositFee.
  ///
  /// In th, this message translates to:
  /// **'ค่ามัดจำสัญญา'**
  String get bookingDepositFee;

  /// No description provided for @bookingWaitingOwnerConfirm.
  ///
  /// In th, this message translates to:
  /// **'รอเจ้าของยืนยัน'**
  String get bookingWaitingOwnerConfirm;

  /// No description provided for @bookingSlipRejected.
  ///
  /// In th, this message translates to:
  /// **'สลิปถูกปฏิเสธ กรุณาแนบใหม่'**
  String get bookingSlipRejected;

  /// No description provided for @bookingAttachSlip.
  ///
  /// In th, this message translates to:
  /// **'แนบสลิปชำระเงิน'**
  String get bookingAttachSlip;

  /// No description provided for @bookingStatusPendingPaymentVerification.
  ///
  /// In th, this message translates to:
  /// **'รอตรวจสอบชำระเงิน'**
  String get bookingStatusPendingPaymentVerification;

  /// No description provided for @ownerBookingTitle.
  ///
  /// In th, this message translates to:
  /// **'จัดการคำขอจอง'**
  String get ownerBookingTitle;

  /// No description provided for @ownerBookingEmpty.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีคำขอจอง'**
  String get ownerBookingEmpty;

  /// No description provided for @ownerBookingFetchError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการดึงข้อมูลการจอง'**
  String get ownerBookingFetchError;

  /// No description provided for @ownerBookingUpdateSuccess.
  ///
  /// In th, this message translates to:
  /// **'อัปเดตสถานะสำเร็จ'**
  String get ownerBookingUpdateSuccess;

  /// No description provided for @ownerBookingUpdateError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาด: '**
  String get ownerBookingUpdateError;

  /// No description provided for @ownerBookingTenant.
  ///
  /// In th, this message translates to:
  /// **'ผู้จอง: '**
  String get ownerBookingTenant;

  /// No description provided for @ownerBookingPhone.
  ///
  /// In th, this message translates to:
  /// **'เบอร์โทรศัพท์: '**
  String get ownerBookingPhone;

  /// No description provided for @ownerBookingAddress.
  ///
  /// In th, this message translates to:
  /// **'ที่อยู่: '**
  String get ownerBookingAddress;

  /// No description provided for @ownerBookingEmail.
  ///
  /// In th, this message translates to:
  /// **'อีเมล: '**
  String get ownerBookingEmail;

  /// No description provided for @ownerBookingDorm.
  ///
  /// In th, this message translates to:
  /// **'หอพัก: '**
  String get ownerBookingDorm;

  /// No description provided for @ownerBookingRoom.
  ///
  /// In th, this message translates to:
  /// **'ห้อง: '**
  String get ownerBookingRoom;

  /// No description provided for @ownerBookingMoveIn.
  ///
  /// In th, this message translates to:
  /// **'วันที่เข้าอยู่: '**
  String get ownerBookingMoveIn;

  /// No description provided for @ownerBookingDate.
  ///
  /// In th, this message translates to:
  /// **'วันที่จอง: '**
  String get ownerBookingDate;

  /// No description provided for @ownerBookingSlip.
  ///
  /// In th, this message translates to:
  /// **'หลักฐานการโอนเงิน:'**
  String get ownerBookingSlip;

  /// No description provided for @ownerBookingReject.
  ///
  /// In th, this message translates to:
  /// **'ปฏิเสธ'**
  String get ownerBookingReject;

  /// No description provided for @ownerBookingApprove.
  ///
  /// In th, this message translates to:
  /// **'อนุมัติ'**
  String get ownerBookingApprove;

  /// No description provided for @ownerBookingRejectSlip.
  ///
  /// In th, this message translates to:
  /// **'ปฏิเสธสลิป'**
  String get ownerBookingRejectSlip;

  /// No description provided for @ownerBookingVerifySlip.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันรับเงิน'**
  String get ownerBookingVerifySlip;

  /// No description provided for @ownerBookingConfirmTitle.
  ///
  /// In th, this message translates to:
  /// **'ยืนยัน'**
  String get ownerBookingConfirmTitle;

  /// No description provided for @ownerBookingConfirmApprove.
  ///
  /// In th, this message translates to:
  /// **'คุณต้องการอนุมัติการจองนี้ใช่หรือไม่?'**
  String get ownerBookingConfirmApprove;

  /// No description provided for @ownerBookingConfirmReject.
  ///
  /// In th, this message translates to:
  /// **'คุณต้องการปฏิเสธการจองนี้ใช่หรือไม่?'**
  String get ownerBookingConfirmReject;

  /// No description provided for @ownerBookingCancel.
  ///
  /// In th, this message translates to:
  /// **'ยกเลิก'**
  String get ownerBookingCancel;

  /// No description provided for @ownerBookingConfirmSlipTitle.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันตรวจสอบสลิป'**
  String get ownerBookingConfirmSlipTitle;

  /// No description provided for @ownerBookingConfirmSlipVerify.
  ///
  /// In th, this message translates to:
  /// **'คุณต้องการยืนยันการรับเงินใช่หรือไม่?'**
  String get ownerBookingConfirmSlipVerify;

  /// No description provided for @ownerBookingConfirmSlipReject.
  ///
  /// In th, this message translates to:
  /// **'คุณต้องการปฏิเสธสลิปนี้ใช่หรือไม่?'**
  String get ownerBookingConfirmSlipReject;

  /// No description provided for @ownerBookingSlipUpdateSuccess.
  ///
  /// In th, this message translates to:
  /// **'อัปเดตสลิปสำเร็จ'**
  String get ownerBookingSlipUpdateSuccess;

  /// No description provided for @dormManageDeleteConfirmTitle.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันการลบ'**
  String get dormManageDeleteConfirmTitle;

  /// No description provided for @dormManageDeleteConfirmDesc.
  ///
  /// In th, this message translates to:
  /// **'คุณแน่ใจหรือไม่ว่าต้องการลบหอพักนี้? การกระทำนี้ไม่สามารถย้อนกลับได้'**
  String get dormManageDeleteConfirmDesc;

  /// No description provided for @dormManageDeleteSuccess.
  ///
  /// In th, this message translates to:
  /// **'ลบหอพักสำเร็จ'**
  String get dormManageDeleteSuccess;

  /// No description provided for @dormManageDeleteError.
  ///
  /// In th, this message translates to:
  /// **'ลบหอพักไม่สำเร็จ'**
  String get dormManageDeleteError;

  /// No description provided for @dormManageEditTooltip.
  ///
  /// In th, this message translates to:
  /// **'แก้ไขข้อมูลหอพัก'**
  String get dormManageEditTooltip;

  /// No description provided for @dormManageDeleteTooltip.
  ///
  /// In th, this message translates to:
  /// **'ลบหอพัก'**
  String get dormManageDeleteTooltip;

  /// No description provided for @dormManageRoomTypesTitle.
  ///
  /// In th, this message translates to:
  /// **'ประเภทห้องพักทั้งหมด'**
  String get dormManageRoomTypesTitle;

  /// No description provided for @dormManageRoomUnit.
  ///
  /// In th, this message translates to:
  /// **' ห้อง'**
  String get dormManageRoomUnit;

  /// No description provided for @dormManageNoRooms.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีข้อมูลห้องพัก'**
  String get dormManageNoRooms;

  /// No description provided for @dormManageAddRoomHint.
  ///
  /// In th, this message translates to:
  /// **'กรุณากดปุ่มเพิ่มห้องพักด้านล่าง'**
  String get dormManageAddRoomHint;

  /// No description provided for @dormManageReviewsTitle.
  ///
  /// In th, this message translates to:
  /// **'รีวิวจากผู้เช่า'**
  String get dormManageReviewsTitle;

  /// No description provided for @dormManageReviewUnit.
  ///
  /// In th, this message translates to:
  /// **' รีวิว'**
  String get dormManageReviewUnit;

  /// No description provided for @dormManageNoReviews.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีรีวิว'**
  String get dormManageNoReviews;

  /// No description provided for @dormManageAddRoomBtn.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มห้องพัก'**
  String get dormManageAddRoomBtn;

  /// No description provided for @dormManageStatusPending.
  ///
  /// In th, this message translates to:
  /// **'กำลังตรวจสอบ'**
  String get dormManageStatusPending;

  /// No description provided for @dormManageStatusApproved.
  ///
  /// In th, this message translates to:
  /// **'อนุมัติแล้ว'**
  String get dormManageStatusApproved;

  /// No description provided for @dormManageStatusRejected.
  ///
  /// In th, this message translates to:
  /// **'ถูกปฏิเสธ'**
  String get dormManageStatusRejected;

  /// No description provided for @dormManageRoomTypeLabel.
  ///
  /// In th, this message translates to:
  /// **'ประเภทห้อง'**
  String get dormManageRoomTypeLabel;

  /// No description provided for @dormManageAvailable.
  ///
  /// In th, this message translates to:
  /// **'ว่าง '**
  String get dormManageAvailable;

  /// No description provided for @dormManageFull.
  ///
  /// In th, this message translates to:
  /// **'เต็มแล้ว'**
  String get dormManageFull;

  /// No description provided for @dormManageDeleteRoomConfirm.
  ///
  /// In th, this message translates to:
  /// **'คุณต้องการลบห้องพักนี้ใช่หรือไม่?'**
  String get dormManageDeleteRoomConfirm;

  /// No description provided for @dormManageEdit.
  ///
  /// In th, this message translates to:
  /// **'แก้ไข'**
  String get dormManageEdit;

  /// No description provided for @dormManageDelete.
  ///
  /// In th, this message translates to:
  /// **'ลบ'**
  String get dormManageDelete;

  /// No description provided for @dormManageDeleteRoomSuccess.
  ///
  /// In th, this message translates to:
  /// **'ลบห้องพักสำเร็จ'**
  String get dormManageDeleteRoomSuccess;

  /// No description provided for @dormManageDeleteRoomError.
  ///
  /// In th, this message translates to:
  /// **'ลบห้องพักไม่สำเร็จ'**
  String get dormManageDeleteRoomError;

  /// No description provided for @dormManagePerMonth.
  ///
  /// In th, this message translates to:
  /// **' / เดือน'**
  String get dormManagePerMonth;

  /// No description provided for @dormManageUserUnknown.
  ///
  /// In th, this message translates to:
  /// **'ผู้ใช้งาน'**
  String get dormManageUserUnknown;

  /// No description provided for @dormManageYourReply.
  ///
  /// In th, this message translates to:
  /// **'การตอบกลับของคุณ'**
  String get dormManageYourReply;

  /// No description provided for @dormManageReplyBtn.
  ///
  /// In th, this message translates to:
  /// **'ตอบกลับ'**
  String get dormManageReplyBtn;

  /// No description provided for @dormManageReplyTitle.
  ///
  /// In th, this message translates to:
  /// **'ตอบกลับรีวิว'**
  String get dormManageReplyTitle;

  /// No description provided for @dormManageReplyHint.
  ///
  /// In th, this message translates to:
  /// **'พิมพ์ข้อความตอบกลับของคุณที่นี่...'**
  String get dormManageReplyHint;

  /// No description provided for @dormManageReplyEmptyError.
  ///
  /// In th, this message translates to:
  /// **'กรุณาพิมพ์ข้อความตอบกลับ'**
  String get dormManageReplyEmptyError;

  /// No description provided for @dormManageReplySuccess.
  ///
  /// In th, this message translates to:
  /// **'ส่งข้อความตอบกลับสำเร็จ'**
  String get dormManageReplySuccess;

  /// No description provided for @dormManageReplyError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการตอบกลับ'**
  String get dormManageReplyError;

  /// No description provided for @dormManageSendReplyBtn.
  ///
  /// In th, this message translates to:
  /// **'ส่งข้อความตอบกลับ'**
  String get dormManageSendReplyBtn;

  /// No description provided for @searchError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการค้นหา'**
  String get searchError;

  /// No description provided for @searchFilterTitle.
  ///
  /// In th, this message translates to:
  /// **'ตัวกรองการค้นหา'**
  String get searchFilterTitle;

  /// No description provided for @searchFilterClear.
  ///
  /// In th, this message translates to:
  /// **'ล้างตัวกรอง'**
  String get searchFilterClear;

  /// No description provided for @searchFilterPrice.
  ///
  /// In th, this message translates to:
  /// **'ราคา (ไม่เกิน ฿'**
  String get searchFilterPrice;

  /// No description provided for @searchFilterPricePerMonth.
  ///
  /// In th, this message translates to:
  /// **'/เดือน)'**
  String get searchFilterPricePerMonth;

  /// No description provided for @searchFilterDistance.
  ///
  /// In th, this message translates to:
  /// **'ระยะห่างจาก ม. (ไม่เกิน '**
  String get searchFilterDistance;

  /// No description provided for @searchFilterDistanceKm.
  ///
  /// In th, this message translates to:
  /// **' กม.)'**
  String get searchFilterDistanceKm;

  /// No description provided for @searchFilterApply.
  ///
  /// In th, this message translates to:
  /// **'ตกลง'**
  String get searchFilterApply;

  /// No description provided for @searchPageTitle.
  ///
  /// In th, this message translates to:
  /// **'ค้นหาหอพักที่ใช่'**
  String get searchPageTitle;

  /// No description provided for @searchHint.
  ///
  /// In th, this message translates to:
  /// **'ค้นหาชื่อหอพัก...'**
  String get searchHint;

  /// No description provided for @searchResultCountTitle.
  ///
  /// In th, this message translates to:
  /// **'ผลการค้นหา ('**
  String get searchResultCountTitle;

  /// No description provided for @searchNoResults.
  ///
  /// In th, this message translates to:
  /// **'ไม่พบหอพักที่ตรงกับเงื่อนไข'**
  String get searchNoResults;

  /// No description provided for @searchPriceLabel.
  ///
  /// In th, this message translates to:
  /// **'ราคา '**
  String get searchPriceLabel;

  /// No description provided for @searchDistanceLabel.
  ///
  /// In th, this message translates to:
  /// **'ห่าง ม. '**
  String get searchDistanceLabel;

  /// No description provided for @searchAvailable.
  ///
  /// In th, this message translates to:
  /// **'ว่าง'**
  String get searchAvailable;

  /// No description provided for @searchFull.
  ///
  /// In th, this message translates to:
  /// **'เต็ม'**
  String get searchFull;

  /// No description provided for @addRoomAc.
  ///
  /// In th, this message translates to:
  /// **'แอร์'**
  String get addRoomAc;

  /// No description provided for @addRoomFan.
  ///
  /// In th, this message translates to:
  /// **'พัดลม'**
  String get addRoomFan;

  /// No description provided for @addRoomSingleBed.
  ///
  /// In th, this message translates to:
  /// **'เตียงเดี่ยว'**
  String get addRoomSingleBed;

  /// No description provided for @addRoomDoubleBed.
  ///
  /// In th, this message translates to:
  /// **'เตียงคู่'**
  String get addRoomDoubleBed;

  /// No description provided for @addRoomValidationPriceError.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกราคาและจำนวนห้องว่าง'**
  String get addRoomValidationPriceError;

  /// No description provided for @addRoomValidationImageError.
  ///
  /// In th, this message translates to:
  /// **'กรุณาเลือกรูปห้องตัวอย่างอย่างน้อย 1 รูป'**
  String get addRoomValidationImageError;

  /// No description provided for @addRoomSuccess.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มข้อมูลห้องพักสำเร็จ'**
  String get addRoomSuccess;

  /// No description provided for @addRoomError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง'**
  String get addRoomError;

  /// No description provided for @addRoomTitleAdd.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มห้องพัก'**
  String get addRoomTitleAdd;

  /// No description provided for @addRoomTitleEdit.
  ///
  /// In th, this message translates to:
  /// **'แก้ไขห้องพัก'**
  String get addRoomTitleEdit;

  /// No description provided for @addRoomPhotos.
  ///
  /// In th, this message translates to:
  /// **'รูปถ่ายห้องพัก'**
  String get addRoomPhotos;

  /// No description provided for @addRoomPhotoLimit.
  ///
  /// In th, this message translates to:
  /// **' / 5 รูป'**
  String get addRoomPhotoLimit;

  /// No description provided for @addRoomPhotoAdd.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มรูปภาพ (สูงสุด 5 รูป)'**
  String get addRoomPhotoAdd;

  /// No description provided for @addRoomNumberTitle.
  ///
  /// In th, this message translates to:
  /// **'หมายเลขห้อง / ชื่อประเภทห้อง'**
  String get addRoomNumberTitle;

  /// No description provided for @addRoomNumberHint.
  ///
  /// In th, this message translates to:
  /// **'เช่น A101 หรือ ห้องสแตนดาร์ด'**
  String get addRoomNumberHint;

  /// No description provided for @addRoomAvailableTitle.
  ///
  /// In th, this message translates to:
  /// **'จำนวนห้องที่ว่าง (ห้อง)'**
  String get addRoomAvailableTitle;

  /// No description provided for @addRoomAvailableHint.
  ///
  /// In th, this message translates to:
  /// **'ระบุจำนวนห้องว่าง เช่น 5'**
  String get addRoomAvailableHint;

  /// No description provided for @addRoomCoolingTitle.
  ///
  /// In th, this message translates to:
  /// **'ประเภทระบบทำความเย็น'**
  String get addRoomCoolingTitle;

  /// No description provided for @addRoomCoolingAc.
  ///
  /// In th, this message translates to:
  /// **'ห้องแอร์'**
  String get addRoomCoolingAc;

  /// No description provided for @addRoomCoolingFan.
  ///
  /// In th, this message translates to:
  /// **'ห้องพัดลม'**
  String get addRoomCoolingFan;

  /// No description provided for @addRoomBedTitle.
  ///
  /// In th, this message translates to:
  /// **'ประเภทเตียง'**
  String get addRoomBedTitle;

  /// No description provided for @addRoomPriceTitle.
  ///
  /// In th, this message translates to:
  /// **'ราคาเริ่มต้น (บาท/เดือน)'**
  String get addRoomPriceTitle;

  /// No description provided for @addRoomPriceHint.
  ///
  /// In th, this message translates to:
  /// **'เช่น 4500'**
  String get addRoomPriceHint;

  /// No description provided for @addRoomFacilitiesTitle.
  ///
  /// In th, this message translates to:
  /// **'สิ่งอำนวยความสะดวก'**
  String get addRoomFacilitiesTitle;

  /// No description provided for @addRoomSaveBtn.
  ///
  /// In th, this message translates to:
  /// **'บันทึกข้อมูล'**
  String get addRoomSaveBtn;

  /// No description provided for @addDormTitleAdd.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มข้อมูลหอพัก'**
  String get addDormTitleAdd;

  /// No description provided for @addDormTitleEdit.
  ///
  /// In th, this message translates to:
  /// **'แก้ไขข้อมูลหอพัก'**
  String get addDormTitleEdit;

  /// No description provided for @addDormCoverImage.
  ///
  /// In th, this message translates to:
  /// **'รูปหน้าปกหอพัก'**
  String get addDormCoverImage;

  /// No description provided for @addDormImageHint.
  ///
  /// In th, this message translates to:
  /// **'แตะเพื่อเลือกรูปภาพ'**
  String get addDormImageHint;

  /// No description provided for @addDormNameTitle.
  ///
  /// In th, this message translates to:
  /// **'ชื่อหอพัก'**
  String get addDormNameTitle;

  /// No description provided for @addDormNameHint.
  ///
  /// In th, this message translates to:
  /// **'ระบุชื่อหอพักของคุณ'**
  String get addDormNameHint;

  /// No description provided for @addDormTypeTitle.
  ///
  /// In th, this message translates to:
  /// **'ประเภทหอพัก'**
  String get addDormTypeTitle;

  /// No description provided for @addDormTypeMixed.
  ///
  /// In th, this message translates to:
  /// **'หอพักรวม'**
  String get addDormTypeMixed;

  /// No description provided for @addDormTypeMale.
  ///
  /// In th, this message translates to:
  /// **'หอพักชาย'**
  String get addDormTypeMale;

  /// No description provided for @addDormTypeFemale.
  ///
  /// In th, this message translates to:
  /// **'หอพักหญิง'**
  String get addDormTypeFemale;

  /// No description provided for @addDormAddressTitle.
  ///
  /// In th, this message translates to:
  /// **'ที่อยู่และพิกัด'**
  String get addDormAddressTitle;

  /// No description provided for @addDormAddressHint.
  ///
  /// In th, this message translates to:
  /// **'ระบุเลขที่บ้าน ถนน แขวง/ตำบล...'**
  String get addDormAddressHint;

  /// No description provided for @addDormMapChange.
  ///
  /// In th, this message translates to:
  /// **'เปลี่ยนพิกัดบนแผนที่'**
  String get addDormMapChange;

  /// No description provided for @addDormMapSelect.
  ///
  /// In th, this message translates to:
  /// **'เลือกพิกัดจากแผนที่'**
  String get addDormMapSelect;

  /// No description provided for @addDormStatusTitle.
  ///
  /// In th, this message translates to:
  /// **'สถานะและความพร้อม'**
  String get addDormStatusTitle;

  /// No description provided for @addDormStatusReady.
  ///
  /// In th, this message translates to:
  /// **'พร้อมเข้าอยู่'**
  String get addDormStatusReady;

  /// No description provided for @addDormStatusOneMonth.
  ///
  /// In th, this message translates to:
  /// **'ว่างภายใน 1 เดือน'**
  String get addDormStatusOneMonth;

  /// No description provided for @addDormAvailableCountTitle.
  ///
  /// In th, this message translates to:
  /// **'จำนวนห้องพักที่ว่าง'**
  String get addDormAvailableCountTitle;

  /// No description provided for @addDormRoomUnit.
  ///
  /// In th, this message translates to:
  /// **'ห้อง'**
  String get addDormRoomUnit;

  /// No description provided for @addDormRulesTitle.
  ///
  /// In th, this message translates to:
  /// **'เงื่อนไขในการเช่าและกฎระเบียบ'**
  String get addDormRulesTitle;

  /// No description provided for @addDormRulesHint.
  ///
  /// In th, this message translates to:
  /// **'เช่น ค่ามัดจำ 2 เดือน, สัญญา 1 ปี, ห้ามเลี้ยงสัตว์...'**
  String get addDormRulesHint;

  /// No description provided for @addDormPaymentTitle.
  ///
  /// In th, this message translates to:
  /// **'ข้อมูลบัญชีรับเงิน (สำหรับรับค่าจอง/มัดจำ)'**
  String get addDormPaymentTitle;

  /// No description provided for @addDormBankHint.
  ///
  /// In th, this message translates to:
  /// **'ธนาคาร (เช่น กสิกรไทย)'**
  String get addDormBankHint;

  /// No description provided for @addDormAccountNameHint.
  ///
  /// In th, this message translates to:
  /// **'ชื่อบัญชี (เช่น นายสมชาย ใจดี)'**
  String get addDormAccountNameHint;

  /// No description provided for @addDormAccountNumberHint.
  ///
  /// In th, this message translates to:
  /// **'เลขบัญชี'**
  String get addDormAccountNumberHint;

  /// No description provided for @addDormPromptPayHint.
  ///
  /// In th, this message translates to:
  /// **'PromptPay (เบอร์โทร หรือ เลขบัตรประชาชน)'**
  String get addDormPromptPayHint;

  /// No description provided for @addDormSaveBtn.
  ///
  /// In th, this message translates to:
  /// **'บันทึกข้อมูล'**
  String get addDormSaveBtn;

  /// No description provided for @addDormValidationError.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกชื่อและที่อยู่หอพัก'**
  String get addDormValidationError;

  /// No description provided for @addDormAddSuccess.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มข้อมูลหอพักสำเร็จ'**
  String get addDormAddSuccess;

  /// No description provided for @addDormEditSuccess.
  ///
  /// In th, this message translates to:
  /// **'อัปเดตข้อมูลหอพักสำเร็จ'**
  String get addDormEditSuccess;

  /// No description provided for @addDormError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง'**
  String get addDormError;

  /// No description provided for @chatNoDormitory.
  ///
  /// In th, this message translates to:
  /// **'คุณยังไม่มีหอพัก'**
  String get chatNoDormitory;

  /// No description provided for @chatTitlePrefix.
  ///
  /// In th, this message translates to:
  /// **'แชท - '**
  String get chatTitlePrefix;

  /// No description provided for @chatErrorLoading.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการโหลดแชท'**
  String get chatErrorLoading;

  /// No description provided for @chatNoMessages.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีข้อความ'**
  String get chatNoMessages;

  /// No description provided for @chatUserUnknown.
  ///
  /// In th, this message translates to:
  /// **'ผู้ใช้'**
  String get chatUserUnknown;

  /// No description provided for @chatFailedUserInfo.
  ///
  /// In th, this message translates to:
  /// **'โหลดข้อมูลผู้ใช้ล้มเหลว'**
  String get chatFailedUserInfo;

  /// No description provided for @chatFailedSendMessage.
  ///
  /// In th, this message translates to:
  /// **'ส่งข้อความล้มเหลว'**
  String get chatFailedSendMessage;

  /// No description provided for @chatErrorTitle.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาด'**
  String get chatErrorTitle;

  /// No description provided for @chatLoginRequired.
  ///
  /// In th, this message translates to:
  /// **'กรุณาเข้าสู่ระบบเพื่อใช้แชท'**
  String get chatLoginRequired;

  /// No description provided for @chatStartConversation.
  ///
  /// In th, this message translates to:
  /// **'เริ่มการสนทนาได้เลย!'**
  String get chatStartConversation;

  /// No description provided for @chatHintText.
  ///
  /// In th, this message translates to:
  /// **'พิมพ์ข้อความ...'**
  String get chatHintText;

  /// No description provided for @dormDetailMapNotFound.
  ///
  /// In th, this message translates to:
  /// **'ไม่พบพิกัดของหอพักนี้บนแผนที่'**
  String get dormDetailMapNotFound;

  /// No description provided for @dormDetailMapLaunchError.
  ///
  /// In th, this message translates to:
  /// **'ไม่สามารถเปิดแผนที่ได้'**
  String get dormDetailMapLaunchError;

  /// No description provided for @dormDetailWriteReview.
  ///
  /// In th, this message translates to:
  /// **'เขียนรีวิว'**
  String get dormDetailWriteReview;

  /// No description provided for @dormDetailRateDorm.
  ///
  /// In th, this message translates to:
  /// **'ให้คะแนนหอพักนี้'**
  String get dormDetailRateDorm;

  /// No description provided for @dormDetailComment.
  ///
  /// In th, this message translates to:
  /// **'ความคิดเห็น'**
  String get dormDetailComment;

  /// No description provided for @dormDetailCommentHint.
  ///
  /// In th, this message translates to:
  /// **'แบ่งปันประสบการณ์ของคุณกับหอพักนี้...'**
  String get dormDetailCommentHint;

  /// No description provided for @dormDetailCommentRequired.
  ///
  /// In th, this message translates to:
  /// **'กรุณากรอกความคิดเห็น'**
  String get dormDetailCommentRequired;

  /// No description provided for @dormDetailReviewSuccess.
  ///
  /// In th, this message translates to:
  /// **'ส่งรีวิวเรียบร้อยแล้ว'**
  String get dormDetailReviewSuccess;

  /// No description provided for @dormDetailReviewError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาด กรุณาลองใหม่'**
  String get dormDetailReviewError;

  /// No description provided for @dormDetailSubmitReview.
  ///
  /// In th, this message translates to:
  /// **'ส่งรีวิว'**
  String get dormDetailSubmitReview;

  /// No description provided for @dormDetailLoadingError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการโหลดข้อมูล'**
  String get dormDetailLoadingError;

  /// No description provided for @dormDetailBack.
  ///
  /// In th, this message translates to:
  /// **'กลับ'**
  String get dormDetailBack;

  /// No description provided for @dormDetailNotFound.
  ///
  /// In th, this message translates to:
  /// **'ไม่พบข้อมูลหอพัก'**
  String get dormDetailNotFound;

  /// No description provided for @dormDetailAvailableRooms.
  ///
  /// In th, this message translates to:
  /// **'จำนวนห้องว่าง '**
  String get dormDetailAvailableRooms;

  /// No description provided for @dormDetailRoomTypes.
  ///
  /// In th, this message translates to:
  /// **'ประเภทห้องพัก'**
  String get dormDetailRoomTypes;

  /// No description provided for @dormDetailNoData.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีข้อมูล'**
  String get dormDetailNoData;

  /// No description provided for @dormDetailAmenities.
  ///
  /// In th, this message translates to:
  /// **'สิ่งอำนวยความสะดวก'**
  String get dormDetailAmenities;

  /// No description provided for @dormDetailRules.
  ///
  /// In th, this message translates to:
  /// **'กฎระเบียบของหอพัก'**
  String get dormDetailRules;

  /// No description provided for @dormDetailLocation.
  ///
  /// In th, this message translates to:
  /// **'สถานที่ตั้ง'**
  String get dormDetailLocation;

  /// No description provided for @dormDetailDirections.
  ///
  /// In th, this message translates to:
  /// **'ดูเส้นทาง'**
  String get dormDetailDirections;

  /// No description provided for @dormDetailDistanceFromUni.
  ///
  /// In th, this message translates to:
  /// **'ระยะกระจัดจากมหาวิทยาลัย: {dist} กม.'**
  String dormDetailDistanceFromUni(String dist);

  /// No description provided for @dormDetailTenantReviews.
  ///
  /// In th, this message translates to:
  /// **'รีวิวจากผู้เช่า'**
  String get dormDetailTenantReviews;

  /// No description provided for @dormDetailNoReviews.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีรีวิวสำหรับหอพักนี้\nมาเป็นคนแรกที่รีวิวกันเถอะ!'**
  String get dormDetailNoReviews;

  /// No description provided for @dormDetailOwnerReply.
  ///
  /// In th, this message translates to:
  /// **'การตอบกลับจากเจ้าของหอพัก'**
  String get dormDetailOwnerReply;

  /// No description provided for @dormDetailStartingPrice.
  ///
  /// In th, this message translates to:
  /// **'ราคาเริ่มต้น'**
  String get dormDetailStartingPrice;

  /// No description provided for @dormDetailCurrency.
  ///
  /// In th, this message translates to:
  /// **'บาท'**
  String get dormDetailCurrency;

  /// No description provided for @dormDetailCurrencyPerMonth.
  ///
  /// In th, this message translates to:
  /// **'บาท/เดือน'**
  String get dormDetailCurrencyPerMonth;

  /// No description provided for @dormDetailChatTooltip.
  ///
  /// In th, this message translates to:
  /// **'แชทสอบถาม'**
  String get dormDetailChatTooltip;

  /// No description provided for @dormDetailViewRooms.
  ///
  /// In th, this message translates to:
  /// **'ดูห้องพัก'**
  String get dormDetailViewRooms;

  /// No description provided for @dormDetailSaveSuccess.
  ///
  /// In th, this message translates to:
  /// **'บันทึกหอพักนี้เรียบร้อยแล้ว'**
  String get dormDetailSaveSuccess;

  /// No description provided for @dormDetailUnsaveSuccess.
  ///
  /// In th, this message translates to:
  /// **'ยกเลิกการบันทึกหอพักเรียบร้อยแล้ว'**
  String get dormDetailUnsaveSuccess;

  /// No description provided for @dormDetailSaveError.
  ///
  /// In th, this message translates to:
  /// **'เกิดข้อผิดพลาดในการบันทึก'**
  String get dormDetailSaveError;

  /// No description provided for @facilityWifi.
  ///
  /// In th, this message translates to:
  /// **'Wi-Fi'**
  String get facilityWifi;

  /// No description provided for @facilityWaterHeater.
  ///
  /// In th, this message translates to:
  /// **'เครื่องทำน้ำอุ่น'**
  String get facilityWaterHeater;

  /// No description provided for @facilityBalcony.
  ///
  /// In th, this message translates to:
  /// **'ระเบียง'**
  String get facilityBalcony;

  /// No description provided for @facilityTv.
  ///
  /// In th, this message translates to:
  /// **'ทีวี'**
  String get facilityTv;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
