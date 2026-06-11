// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Just Booking';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileFavorites => 'Favorites';

  @override
  String get profileChangeLanguage => 'Change Language';

  @override
  String get profileLogout => 'Logout';

  @override
  String get profileLogoutConfirmTitle => 'Logout';

  @override
  String get profileLogoutConfirmDesc =>
      'Are you sure you want to log out of this account?';

  @override
  String get profileLogoutCancel => 'Cancel';

  @override
  String get profileLogoutConfirmBtn => 'Confirm Logout';

  @override
  String get profileCameraToast =>
      'Opening camera to change profile picture...';

  @override
  String get profileLoadError => 'Error loading user data';

  @override
  String get profileUnknownUser => 'System User';

  @override
  String get languageTitle => 'Change Language';

  @override
  String get languageThai => 'ภาษาไทย';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get languageConfirm => 'Confirm';

  @override
  String get homeTab => 'Home';

  @override
  String get bookingTab => 'Bookings';

  @override
  String get messageTab => 'Messages';

  @override
  String get notificationTab => 'Alerts';

  @override
  String get homeSearchHint => 'Search dorms, location, or price..';

  @override
  String get homeRecentSearches => 'Recent Searches';

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homeNoDormsFound => 'No dormitories found';

  @override
  String get homePopularDorms => 'Popular Dorms';

  @override
  String get homeRecommended => 'Recommended';

  @override
  String get homeAvailable => 'Available';

  @override
  String get homePerMonth => '/month';

  @override
  String homeRoomsLeft(int count) {
    return '$count rooms left';
  }

  @override
  String get homeFull => 'Full';

  @override
  String homeDistanceFromUni(String dist) {
    return '$dist km from Uni';
  }

  @override
  String get homeAirConFan => 'A/C / Fan';

  @override
  String get homeNotificationsTitle => 'Notifications';

  @override
  String get homeReadAll => 'Read All';

  @override
  String get bookingStatusPendingOwnerApproval => 'Pending Owner Approval';

  @override
  String get bookingStatusPendingPayment => 'Pending Payment';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusRejected => 'Rejected';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get bookingPaymentUploadError => 'Error uploading payment slip';

  @override
  String get bookingNoBank => 'Bank not specified';

  @override
  String get bookingNoAccountName => 'Account name not specified';

  @override
  String get bookingNoAccountNumber => 'Account number not specified';

  @override
  String get bookingPaymentTitle => 'Booking Payment';

  @override
  String get bookingPaymentAmount => 'Amount';

  @override
  String get bookingBank => 'Bank';

  @override
  String get bookingAccountName => 'Account Name';

  @override
  String get bookingAccountNumber => 'Account Number';

  @override
  String get bookingScanPromptPay => 'Scan to Pay (PromptPay)';

  @override
  String get bookingPaymentSubmitted =>
      'Payment completed (Waiting for owner verification)';

  @override
  String get bookingYourSlip => 'Your slip:';

  @override
  String get bookingSelectSlip => 'Select payment slip';

  @override
  String get bookingChangeSlip => 'Change slip';

  @override
  String get bookingSubmitSlip => 'Submit payment evidence';

  @override
  String get bookingConfirmSuccessTitle => 'Booking Confirmed!';

  @override
  String get bookingConfirmSuccessDesc =>
      'Booking successful. Please go to your bookings list to pay and upload your payment slip.';

  @override
  String get bookingDormitory => 'Dormitory';

  @override
  String get bookingRoomType => 'Room Type';

  @override
  String get bookingOkViewList => 'OK (View Bookings)';

  @override
  String get bookingCreateError => 'Booking error. Please try again.';

  @override
  String get bookingDetailTitle => 'Booking Details';

  @override
  String get bookingRoom => 'Room';

  @override
  String get bookingNoFacilities => 'No facility information';

  @override
  String get bookingPriceLabel => 'Price ';

  @override
  String get bookingPerMonthDeposit => ' /month • Deposit ';

  @override
  String get bookingOneYearContract => '\n1 Year Contract';

  @override
  String get bookingTenantInfo => 'Tenant Information';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get bookingTenantName => 'Full Name';

  @override
  String get bookingTenantPhone => 'Phone Number';

  @override
  String get bookingTenantAddress => 'Address';

  @override
  String get bookingStartDate => 'Start Date';

  @override
  String get bookingConfirmButton => 'Confirm Booking';

  @override
  String get bookingHistoryTitle => 'Your Bookings';

  @override
  String get bookingHistorySubtitle =>
      'Track your booking status and contracts';

  @override
  String get bookingHistoryEmpty => 'No previous booking history';

  @override
  String get bookingNoDormName => 'Dormitory not specified';

  @override
  String get bookingNoRoomInfo => 'No room info';

  @override
  String get bookingIdPrefix => 'Booking ID #JB';

  @override
  String get bookingDepositFee => 'Deposit Fee';

  @override
  String get bookingWaitingOwnerConfirm => 'Waiting for owner';

  @override
  String get bookingSlipRejected => 'Slip rejected. Please attach a new one.';

  @override
  String get bookingAttachSlip => 'Attach payment slip';

  @override
  String get bookingStatusPendingPaymentVerification =>
      'Pending Payment Verification';

  @override
  String get ownerBookingTitle => 'Manage Bookings';

  @override
  String get ownerBookingEmpty => 'No booking requests yet';

  @override
  String get ownerBookingFetchError => 'Error fetching booking data';

  @override
  String get ownerBookingUpdateSuccess => 'Status updated successfully';

  @override
  String get ownerBookingUpdateError => 'Error: ';

  @override
  String get ownerBookingTenant => 'Tenant: ';

  @override
  String get ownerBookingPhone => 'Phone: ';

  @override
  String get ownerBookingAddress => 'Address: ';

  @override
  String get ownerBookingEmail => 'Email: ';

  @override
  String get ownerBookingDorm => 'Dormitory: ';

  @override
  String get ownerBookingRoom => 'Room: ';

  @override
  String get ownerBookingMoveIn => 'Move-in date: ';

  @override
  String get ownerBookingDate => 'Booking date: ';

  @override
  String get ownerBookingSlip => 'Payment Slip:';

  @override
  String get ownerBookingReject => 'Reject';

  @override
  String get ownerBookingApprove => 'Approve';

  @override
  String get ownerBookingRejectSlip => 'Reject Slip';

  @override
  String get ownerBookingVerifySlip => 'Verify Payment';

  @override
  String get ownerBookingConfirmTitle => 'Confirm';

  @override
  String get ownerBookingConfirmApprove =>
      'Are you sure you want to approve this booking?';

  @override
  String get ownerBookingConfirmReject =>
      'Are you sure you want to reject this booking?';

  @override
  String get ownerBookingCancel => 'Cancel';

  @override
  String get ownerBookingConfirmSlipTitle => 'Confirm Payment Slip';

  @override
  String get ownerBookingConfirmSlipVerify =>
      'Are you sure you want to verify this payment?';

  @override
  String get ownerBookingConfirmSlipReject =>
      'Are you sure you want to reject this slip?';

  @override
  String get ownerBookingSlipUpdateSuccess => 'Slip updated successfully';

  @override
  String get dormManageDeleteConfirmTitle => 'Confirm Deletion';

  @override
  String get dormManageDeleteConfirmDesc =>
      'Are you sure you want to delete this dormitory? This action cannot be undone.';

  @override
  String get dormManageDeleteSuccess => 'Dormitory deleted successfully';

  @override
  String get dormManageDeleteError => 'Failed to delete dormitory';

  @override
  String get dormManageEditTooltip => 'Edit Dormitory';

  @override
  String get dormManageDeleteTooltip => 'Delete Dormitory';

  @override
  String get dormManageRoomTypesTitle => 'All Room Types';

  @override
  String get dormManageRoomUnit => ' Rooms';

  @override
  String get dormManageNoRooms => 'No room data available';

  @override
  String get dormManageAddRoomHint =>
      'Please add a room using the button below';

  @override
  String get dormManageReviewsTitle => 'Tenant Reviews';

  @override
  String get dormManageReviewUnit => ' Reviews';

  @override
  String get dormManageNoReviews => 'No reviews yet';

  @override
  String get dormManageAddRoomBtn => 'Add Room';

  @override
  String get dormManageStatusPending => 'Under Review';

  @override
  String get dormManageStatusApproved => 'Approved';

  @override
  String get dormManageStatusRejected => 'Rejected';

  @override
  String get dormManageRoomTypeLabel => 'Room Type';

  @override
  String get dormManageAvailable => 'Available ';

  @override
  String get dormManageFull => 'Full';

  @override
  String get dormManageDeleteRoomConfirm =>
      'Are you sure you want to delete this room?';

  @override
  String get dormManageEdit => 'Edit';

  @override
  String get dormManageDelete => 'Delete';

  @override
  String get dormManageDeleteRoomSuccess => 'Room deleted successfully';

  @override
  String get dormManageDeleteRoomError => 'Failed to delete room';

  @override
  String get dormManagePerMonth => ' / month';

  @override
  String get dormManageUserUnknown => 'User';

  @override
  String get dormManageYourReply => 'Your Reply';

  @override
  String get dormManageReplyBtn => 'Reply';

  @override
  String get dormManageReplyTitle => 'Reply to Review';

  @override
  String get dormManageReplyHint => 'Type your reply here...';

  @override
  String get dormManageReplyEmptyError => 'Please enter a reply';

  @override
  String get dormManageReplySuccess => 'Reply sent successfully';

  @override
  String get dormManageReplyError => 'Error sending reply';

  @override
  String get dormManageSendReplyBtn => 'Send Reply';

  @override
  String get searchError => 'Error during search';

  @override
  String get searchFilterTitle => 'Search Filters';

  @override
  String get searchFilterClear => 'Clear Filters';

  @override
  String get searchFilterPrice => 'Price (Up to ฿';

  @override
  String get searchFilterPricePerMonth => '/month)';

  @override
  String get searchFilterDistance => 'Distance from Uni (Up to ';

  @override
  String get searchFilterDistanceKm => ' km)';

  @override
  String get searchFilterApply => 'Apply';

  @override
  String get searchPageTitle => 'Find Your Dormitory';

  @override
  String get searchHint => 'Search dormitory name...';

  @override
  String get searchResultCountTitle => 'Search Results (';

  @override
  String get searchNoResults => 'No dormitories found matching your criteria';

  @override
  String get searchPriceLabel => 'Price ';

  @override
  String get searchDistanceLabel => 'Distance ';

  @override
  String get searchAvailable => 'Available';

  @override
  String get searchFull => 'Full';

  @override
  String get addRoomAc => 'AC';

  @override
  String get addRoomFan => 'Fan';

  @override
  String get addRoomSingleBed => 'Single Bed';

  @override
  String get addRoomDoubleBed => 'Double Bed';

  @override
  String get addRoomValidationPriceError =>
      'Please enter price and available room count';

  @override
  String get addRoomValidationImageError =>
      'Please select at least 1 room image';

  @override
  String get addRoomSuccess => 'Room added successfully';

  @override
  String get addRoomError => 'An error occurred. Please try again.';

  @override
  String get addRoomTitleAdd => 'Add Room';

  @override
  String get addRoomTitleEdit => 'Edit Room';

  @override
  String get addRoomPhotos => 'Room Photos';

  @override
  String get addRoomPhotoLimit => ' / 5 Photos';

  @override
  String get addRoomPhotoAdd => 'Add Image (Max 5)';

  @override
  String get addRoomNumberTitle => 'Room Number / Type Name';

  @override
  String get addRoomNumberHint => 'e.g. A101 or Standard Room';

  @override
  String get addRoomAvailableTitle => 'Available Rooms';

  @override
  String get addRoomAvailableHint => 'e.g. 5';

  @override
  String get addRoomCoolingTitle => 'Cooling System';

  @override
  String get addRoomCoolingAc => 'AC Room';

  @override
  String get addRoomCoolingFan => 'Fan Room';

  @override
  String get addRoomBedTitle => 'Bed Type';

  @override
  String get addRoomPriceTitle => 'Starting Price (THB/month)';

  @override
  String get addRoomPriceHint => 'e.g. 4500';

  @override
  String get addRoomFacilitiesTitle => 'Facilities';

  @override
  String get addRoomSaveBtn => 'Save Information';

  @override
  String get addDormTitleAdd => 'Add Dormitory Info';

  @override
  String get addDormTitleEdit => 'Edit Dormitory Info';

  @override
  String get addDormCoverImage => 'Dormitory Cover Image';

  @override
  String get addDormImageHint => 'Tap to select image';

  @override
  String get addDormNameTitle => 'Dormitory Name';

  @override
  String get addDormNameHint => 'Enter your dormitory name';

  @override
  String get addDormTypeTitle => 'Dormitory Type';

  @override
  String get addDormTypeMixed => 'Mixed';

  @override
  String get addDormTypeMale => 'Male only';

  @override
  String get addDormTypeFemale => 'Female only';

  @override
  String get addDormAddressTitle => 'Address & Location';

  @override
  String get addDormAddressHint => 'Enter house no., street, district...';

  @override
  String get addDormMapChange => 'Change location on map';

  @override
  String get addDormMapSelect => 'Select location on map';

  @override
  String get addDormStatusTitle => 'Status & Readiness';

  @override
  String get addDormStatusReady => 'Ready to move in';

  @override
  String get addDormStatusOneMonth => 'Available in 1 month';

  @override
  String get addDormAvailableCountTitle => 'Available Rooms';

  @override
  String get addDormRoomUnit => 'Rooms';

  @override
  String get addDormRulesTitle => 'Rental Conditions & Rules';

  @override
  String get addDormRulesHint =>
      'e.g. 2 months deposit, 1 year contract, no pets...';

  @override
  String get addDormPaymentTitle =>
      'Payment Account Info (For booking/deposit)';

  @override
  String get addDormBankHint => 'Bank (e.g. Kasikorn Bank)';

  @override
  String get addDormAccountNameHint => 'Account Name (e.g. Somchai Jaidee)';

  @override
  String get addDormAccountNumberHint => 'Account Number';

  @override
  String get addDormPromptPayHint => 'PromptPay (Phone or National ID)';

  @override
  String get addDormSaveBtn => 'Save Information';

  @override
  String get addDormValidationError =>
      'Please enter dormitory name and address';

  @override
  String get addDormAddSuccess => 'Dormitory added successfully';

  @override
  String get addDormEditSuccess => 'Dormitory updated successfully';

  @override
  String get addDormError => 'An error occurred. Please try again.';

  @override
  String get chatNoDormitory => 'You don\'t have any dormitories yet';

  @override
  String get chatTitlePrefix => 'Chat - ';

  @override
  String get chatErrorLoading => 'Error loading chats';

  @override
  String get chatNoMessages => 'No messages yet';

  @override
  String get chatUserUnknown => 'User';

  @override
  String get chatFailedUserInfo => 'Failed to load user info';

  @override
  String get chatFailedSendMessage => 'Failed to send message';

  @override
  String get chatErrorTitle => 'Error';

  @override
  String get chatLoginRequired => 'Please login to chat.';

  @override
  String get chatStartConversation => 'Start a conversation!';

  @override
  String get chatHintText => 'Type a message...';

  @override
  String get dormDetailMapNotFound => 'Map coordinates not found';

  @override
  String get dormDetailMapLaunchError => 'Could not launch map';

  @override
  String get dormDetailWriteReview => 'Write a Review';

  @override
  String get dormDetailRateDorm => 'Rate this dormitory';

  @override
  String get dormDetailComment => 'Comment';

  @override
  String get dormDetailCommentHint => 'Share your experience...';

  @override
  String get dormDetailCommentRequired => 'Please enter a comment';

  @override
  String get dormDetailReviewSuccess => 'Review submitted successfully';

  @override
  String get dormDetailReviewError => 'Error occurred. Please try again';

  @override
  String get dormDetailSubmitReview => 'Submit Review';

  @override
  String get dormDetailLoadingError => 'Error loading data';

  @override
  String get dormDetailBack => 'Back';

  @override
  String get dormDetailNotFound => 'Dormitory not found';

  @override
  String get dormDetailAvailableRooms => 'Available rooms: ';

  @override
  String get dormDetailRoomTypes => 'Room Types';

  @override
  String get dormDetailNoData => 'No data';

  @override
  String get dormDetailAmenities => 'Amenities';

  @override
  String get dormDetailRules => 'Dormitory Rules';

  @override
  String get dormDetailLocation => 'Location';

  @override
  String get dormDetailDirections => 'Get Directions';

  @override
  String dormDetailDistanceFromUni(String dist) {
    return 'Distance from university: $dist km';
  }

  @override
  String get dormDetailTenantReviews => 'Tenant Reviews';

  @override
  String get dormDetailNoReviews => 'No reviews yet.\nBe the first to review!';

  @override
  String get dormDetailOwnerReply => 'Owner\'s reply';

  @override
  String get dormDetailStartingPrice => 'Starting price';

  @override
  String get dormDetailCurrency => 'THB';

  @override
  String get dormDetailCurrencyPerMonth => 'THB/Month';

  @override
  String get dormDetailChatTooltip => 'Inquire via Chat';

  @override
  String get dormDetailViewRooms => 'View Rooms';

  @override
  String get dormDetailSaveSuccess => 'Saved to favorites';

  @override
  String get dormDetailUnsaveSuccess => 'Removed from favorites';

  @override
  String get dormDetailSaveError => 'Error saving';

  @override
  String get facilityWifi => 'Wi-Fi';

  @override
  String get facilityWaterHeater => 'Water Heater';

  @override
  String get facilityBalcony => 'Balcony';

  @override
  String get facilityTv => 'TV';
}
