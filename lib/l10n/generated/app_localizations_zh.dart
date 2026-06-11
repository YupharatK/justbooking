// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Just Booking';

  @override
  String get profileEdit => '编辑个人资料';

  @override
  String get profileFavorites => '收藏夹';

  @override
  String get profileChangeLanguage => '改变语言';

  @override
  String get profileLogout => '登出';

  @override
  String get profileLogoutConfirmTitle => '登出';

  @override
  String get profileLogoutConfirmDesc => '您确定要退出此帐户吗？';

  @override
  String get profileLogoutCancel => '取消';

  @override
  String get profileLogoutConfirmBtn => '确认登出';

  @override
  String get profileCameraToast => '正在打开相机以更改个人资料图片...';

  @override
  String get profileLoadError => '加载用户数据时出错';

  @override
  String get profileUnknownUser => '系统用户';

  @override
  String get languageTitle => '改变语言';

  @override
  String get languageThai => 'ภาษาไทย';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get languageConfirm => '确认';

  @override
  String get homeTab => '主页';

  @override
  String get bookingTab => '预订';

  @override
  String get messageTab => '消息';

  @override
  String get notificationTab => '通知';

  @override
  String get homeSearchHint => '搜索宿舍、地点或价格..';

  @override
  String get homeRecentSearches => '最近搜索';

  @override
  String get homeSeeAll => '查看全部';

  @override
  String get homeNoDormsFound => '未找到宿舍';

  @override
  String get homePopularDorms => '热门宿舍';

  @override
  String get homeRecommended => '推荐宿舍';

  @override
  String get homeAvailable => '空房';

  @override
  String get homePerMonth => '/月';

  @override
  String homeRoomsLeft(int count) {
    return '剩余 $count 间';
  }

  @override
  String get homeFull => '已满';

  @override
  String homeDistanceFromUni(String dist) {
    return '距大学 $dist 公里';
  }

  @override
  String get homeAirConFan => '空调 / 风扇';

  @override
  String get homeNotificationsTitle => '通知';

  @override
  String get homeReadAll => '全部已读';

  @override
  String get bookingStatusPendingOwnerApproval => '等待房东批准';

  @override
  String get bookingStatusPendingPayment => '待付款';

  @override
  String get bookingStatusCompleted => '已完成';

  @override
  String get bookingStatusRejected => '已拒绝';

  @override
  String get bookingStatusCancelled => '已取消';

  @override
  String get bookingPaymentUploadError => '上传付款凭证时出错';

  @override
  String get bookingNoBank => '未指定银行';

  @override
  String get bookingNoAccountName => '未指定账户名称';

  @override
  String get bookingNoAccountNumber => '未指定账号';

  @override
  String get bookingPaymentTitle => '预订付款';

  @override
  String get bookingPaymentAmount => '金额';

  @override
  String get bookingBank => '银行';

  @override
  String get bookingAccountName => '账户名称';

  @override
  String get bookingAccountNumber => '账号';

  @override
  String get bookingScanPromptPay => '扫码付款 (PromptPay)';

  @override
  String get bookingPaymentSubmitted => '已付款 (等待房东核实)';

  @override
  String get bookingYourSlip => '您的凭证:';

  @override
  String get bookingSelectSlip => '选择付款凭证';

  @override
  String get bookingChangeSlip => '更换凭证';

  @override
  String get bookingSubmitSlip => '提交付款证明';

  @override
  String get bookingConfirmSuccessTitle => '预订成功!';

  @override
  String get bookingConfirmSuccessDesc => '我们已收到您的付款凭证和预订详情。房东将在 24 小时内审核合同。';

  @override
  String get bookingDormitory => '宿舍';

  @override
  String get bookingRoomType => '房型';

  @override
  String get bookingOkViewList => '确定 (查看预订)';

  @override
  String get bookingCreateError => '预订出错。请重试。';

  @override
  String get bookingDetailTitle => '预订详情';

  @override
  String get bookingRoom => '房间';

  @override
  String get bookingNoFacilities => '无设施信息';

  @override
  String get bookingPriceLabel => '价格 ';

  @override
  String get bookingPerMonthDeposit => ' /月 • 押金 [needs review] ';

  @override
  String get bookingOneYearContract => '\n1年合同 [needs review]';

  @override
  String get bookingTenantInfo => '租客信息';

  @override
  String get commonLoading => '加载中...';

  @override
  String get bookingTenantName => '姓名';

  @override
  String get bookingTenantPhone => '电话号码';

  @override
  String get bookingTenantAddress => '地址';

  @override
  String get bookingStartDate => '开始日期';

  @override
  String get bookingConfirmButton => '确认预订';

  @override
  String get bookingHistoryTitle => '您的预订';

  @override
  String get bookingHistorySubtitle => '跟踪您的预订状态和合同';

  @override
  String get bookingHistoryEmpty => '没有过往预订记录';

  @override
  String get bookingNoDormName => '未指定宿舍';

  @override
  String get bookingNoRoomInfo => '无房间信息';

  @override
  String get bookingIdPrefix => '预订编号 #JB';

  @override
  String get bookingDepositFee => '押金 [needs review]';

  @override
  String get bookingWaitingOwnerConfirm => '等待房东确认';

  @override
  String get bookingSlipRejected => '凭证被拒绝，请重新附加。';

  @override
  String get bookingAttachSlip => '附加付款凭证';

  @override
  String get bookingStatusPendingPaymentVerification => '等待付款验证';

  @override
  String get ownerBookingTitle => '管理预订 [needs review]';

  @override
  String get ownerBookingEmpty => '暂无预订请求';

  @override
  String get ownerBookingFetchError => '获取预订数据时出错';

  @override
  String get ownerBookingUpdateSuccess => '状态更新成功';

  @override
  String get ownerBookingUpdateError => '错误: ';

  @override
  String get ownerBookingTenant => '租客: ';

  @override
  String get ownerBookingPhone => '电话: ';

  @override
  String get ownerBookingAddress => '地址: ';

  @override
  String get ownerBookingEmail => '电子邮件: ';

  @override
  String get ownerBookingDorm => '宿舍: ';

  @override
  String get ownerBookingRoom => '房间: ';

  @override
  String get ownerBookingMoveIn => '入住日期: ';

  @override
  String get ownerBookingDate => '预订日期: ';

  @override
  String get ownerBookingSlip => '付款凭证:';

  @override
  String get ownerBookingReject => '拒绝';

  @override
  String get ownerBookingApprove => '批准';

  @override
  String get ownerBookingRejectSlip => '拒绝凭证';

  @override
  String get ownerBookingVerifySlip => '确认付款';

  @override
  String get ownerBookingConfirmTitle => '确认';

  @override
  String get ownerBookingConfirmApprove => '您确定要批准此预订吗？';

  @override
  String get ownerBookingConfirmReject => '您确定要拒绝此预订吗？';

  @override
  String get ownerBookingCancel => '取消';

  @override
  String get ownerBookingConfirmSlipTitle => '确认付款凭证';

  @override
  String get ownerBookingConfirmSlipVerify => '您确定要确认此付款吗？';

  @override
  String get ownerBookingConfirmSlipReject => '您确定要拒绝此凭证吗？';

  @override
  String get ownerBookingSlipUpdateSuccess => '凭证更新成功';

  @override
  String get dormManageDeleteConfirmTitle => '确认删除';

  @override
  String get dormManageDeleteConfirmDesc => '您确定要删除此宿舍吗？此操作无法撤销。';

  @override
  String get dormManageDeleteSuccess => '宿舍删除成功';

  @override
  String get dormManageDeleteError => '无法删除宿舍';

  @override
  String get dormManageEditTooltip => '编辑宿舍';

  @override
  String get dormManageDeleteTooltip => '删除宿舍';

  @override
  String get dormManageRoomTypesTitle => '所有房型';

  @override
  String get dormManageRoomUnit => ' 间';

  @override
  String get dormManageNoRooms => '暂无房间数据';

  @override
  String get dormManageAddRoomHint => '请点击下方按钮添加房间';

  @override
  String get dormManageReviewsTitle => '租客评价';

  @override
  String get dormManageReviewUnit => ' 条评价';

  @override
  String get dormManageNoReviews => '暂无评价';

  @override
  String get dormManageAddRoomBtn => '添加房间';

  @override
  String get dormManageStatusPending => '审核中';

  @override
  String get dormManageStatusApproved => '已批准';

  @override
  String get dormManageStatusRejected => '已拒绝';

  @override
  String get dormManageRoomTypeLabel => '房型';

  @override
  String get dormManageAvailable => '空闲 ';

  @override
  String get dormManageFull => '已满';

  @override
  String get dormManageDeleteRoomConfirm => '您确定要删除此房间吗？';

  @override
  String get dormManageEdit => '编辑';

  @override
  String get dormManageDelete => '删除';

  @override
  String get dormManageDeleteRoomSuccess => '房间删除成功';

  @override
  String get dormManageDeleteRoomError => '无法删除房间';

  @override
  String get dormManagePerMonth => ' / 月';

  @override
  String get dormManageUserUnknown => '用户';

  @override
  String get dormManageYourReply => '您的回复';

  @override
  String get dormManageReplyBtn => '回复';

  @override
  String get dormManageReplyTitle => '回复评价';

  @override
  String get dormManageReplyHint => '在此输入您的回复...';

  @override
  String get dormManageReplyEmptyError => '请输入回复内容';

  @override
  String get dormManageReplySuccess => '回复发送成功';

  @override
  String get dormManageReplyError => '发送回复时出错';

  @override
  String get dormManageSendReplyBtn => '发送回复';

  @override
  String get searchError => '搜索时出错';

  @override
  String get searchFilterTitle => '搜索过滤器';

  @override
  String get searchFilterClear => '清除过滤器';

  @override
  String get searchFilterPrice => '价格 (最高 ฿';

  @override
  String get searchFilterPricePerMonth => '/月)';

  @override
  String get searchFilterDistance => '距大学距离 (最远 ';

  @override
  String get searchFilterDistanceKm => ' 公里)';

  @override
  String get searchFilterApply => '应用';

  @override
  String get searchPageTitle => '寻找您的宿舍';

  @override
  String get searchHint => '搜索宿舍名称...';

  @override
  String get searchResultCountTitle => '搜索结果 (';

  @override
  String get searchNoResults => '未找到符合条件的宿舍';

  @override
  String get searchPriceLabel => '价格 ';

  @override
  String get searchDistanceLabel => '距离 ';

  @override
  String get searchAvailable => '空闲';

  @override
  String get searchFull => '已满';

  @override
  String get addRoomAc => '空调';

  @override
  String get addRoomFan => '风扇';

  @override
  String get addRoomSingleBed => '单人床';

  @override
  String get addRoomDoubleBed => '双人床';

  @override
  String get addRoomValidationPriceError => '请输入价格和可用房间数';

  @override
  String get addRoomValidationImageError => '请至少选择 1 张房间图片';

  @override
  String get addRoomSuccess => '房间添加成功';

  @override
  String get addRoomError => '发生错误。请重试。';

  @override
  String get addRoomTitleAdd => '添加房间';

  @override
  String get addRoomTitleEdit => '编辑房间';

  @override
  String get addRoomPhotos => '房间照片';

  @override
  String get addRoomPhotoLimit => ' / 5 张';

  @override
  String get addRoomPhotoAdd => '添加图片 (最多 5 张)';

  @override
  String get addRoomNumberTitle => '房间号 / 类型名称';

  @override
  String get addRoomNumberHint => '例如 A101 或 标准间';

  @override
  String get addRoomAvailableTitle => '可用房间数';

  @override
  String get addRoomAvailableHint => '例如 5';

  @override
  String get addRoomCoolingTitle => '制冷系统';

  @override
  String get addRoomCoolingAc => '空调房';

  @override
  String get addRoomCoolingFan => '风扇房';

  @override
  String get addRoomBedTitle => '床型';

  @override
  String get addRoomPriceTitle => '起步价 (泰铢/月)';

  @override
  String get addRoomPriceHint => '例如 4500';

  @override
  String get addRoomFacilitiesTitle => '设施';

  @override
  String get addRoomSaveBtn => '保存信息';

  @override
  String get addDormTitleAdd => '添加宿舍信息';

  @override
  String get addDormTitleEdit => '编辑宿舍信息';

  @override
  String get addDormCoverImage => '宿舍封面图片';

  @override
  String get addDormImageHint => '点击选择图片';

  @override
  String get addDormNameTitle => '宿舍名称';

  @override
  String get addDormNameHint => '输入您的宿舍名称';

  @override
  String get addDormTypeTitle => '宿舍类型';

  @override
  String get addDormTypeMixed => '混合';

  @override
  String get addDormTypeMale => '仅限男性';

  @override
  String get addDormTypeFemale => '仅限女性';

  @override
  String get addDormAddressTitle => '地址与位置';

  @override
  String get addDormAddressHint => '输入门牌号、街道、区县...';

  @override
  String get addDormMapChange => '在地图上更改位置';

  @override
  String get addDormMapSelect => '在地图上选择位置';

  @override
  String get addDormStatusTitle => '状态及准备情况';

  @override
  String get addDormStatusReady => '可随时入住';

  @override
  String get addDormStatusOneMonth => '1个月内可用';

  @override
  String get addDormAvailableCountTitle => '可用房间';

  @override
  String get addDormRoomUnit => '房间';

  @override
  String get addDormRulesTitle => '租赁条件和规则';

  @override
  String get addDormRulesHint => '例如，2个月押金，1年合同，禁止携带宠物...';

  @override
  String get addDormPaymentTitle => '收款账户信息 (用于预订/押金)';

  @override
  String get addDormBankHint => '银行 (例如 泰国开泰银行)';

  @override
  String get addDormAccountNameHint => '账户名';

  @override
  String get addDormAccountNumberHint => '账号';

  @override
  String get addDormPromptPayHint => 'PromptPay (手机号或身份证)';

  @override
  String get addDormSaveBtn => '保存信息';

  @override
  String get addDormValidationError => '请输入宿舍名称和地址';

  @override
  String get addDormAddSuccess => '宿舍信息添加成功';

  @override
  String get addDormEditSuccess => '宿舍信息更新成功';

  @override
  String get addDormError => '发生错误。请重试。';

  @override
  String get chatNoDormitory => '您还没有任何宿舍';

  @override
  String get chatTitlePrefix => '聊天 - ';

  @override
  String get chatErrorLoading => '加载聊天出错';

  @override
  String get chatNoMessages => '暂无消息';

  @override
  String get chatUserUnknown => '用户';

  @override
  String get chatFailedUserInfo => '加载用户信息失败';

  @override
  String get chatFailedSendMessage => '发送消息失败';

  @override
  String get chatErrorTitle => '错误';

  @override
  String get chatLoginRequired => '请登录以聊天';

  @override
  String get chatStartConversation => '开始对话吧！';

  @override
  String get chatHintText => '输入消息...';

  @override
  String get dormDetailMapNotFound => '[needs review] 未找到地图坐标';

  @override
  String get dormDetailMapLaunchError => '[needs review] 无法启动地图';

  @override
  String get dormDetailWriteReview => '[needs review] 写评论';

  @override
  String get dormDetailRateDorm => '[needs review] 给宿舍评分';

  @override
  String get dormDetailComment => '[needs review] 评论';

  @override
  String get dormDetailCommentHint => '[needs review] 分享您的经历...';

  @override
  String get dormDetailCommentRequired => '[needs review] 请输入评论';

  @override
  String get dormDetailReviewSuccess => '[needs review] 评论提交成功';

  @override
  String get dormDetailReviewError => '[needs review] 发生错误，请重试';

  @override
  String get dormDetailSubmitReview => '[needs review] 提交评论';

  @override
  String get dormDetailLoadingError => '[needs review] 加载数据出错';

  @override
  String get dormDetailBack => '[needs review] 返回';

  @override
  String get dormDetailNotFound => '[needs review] 未找到宿舍';

  @override
  String get dormDetailAvailableRooms => '[needs review] 可用房间：';

  @override
  String get dormDetailRoomTypes => '[needs review] 房间类型';

  @override
  String get dormDetailNoData => '[needs review] 无数据';

  @override
  String get dormDetailAmenities => '[needs review] 便利设施';

  @override
  String get dormDetailRules => '[needs review] 宿舍规则';

  @override
  String get dormDetailLocation => '[needs review] 位置';

  @override
  String get dormDetailDirections => '[needs review] 获取路线';

  @override
  String dormDetailDistanceFromUni(String dist) {
    return '[needs review] 距大学的距离：$dist 公里';
  }

  @override
  String get dormDetailTenantReviews => '[needs review] 租户评论';

  @override
  String get dormDetailNoReviews => '[needs review] 暂无评论。\n成为第一个评论的人！';

  @override
  String get dormDetailOwnerReply => '[needs review] 房东回复';

  @override
  String get dormDetailStartingPrice => '[needs review] 起价';

  @override
  String get dormDetailCurrency => '[needs review] 泰铢';

  @override
  String get dormDetailCurrencyPerMonth => '[needs review] 泰铢/月';

  @override
  String get dormDetailChatTooltip => '[needs review] 聊天咨询';

  @override
  String get dormDetailViewRooms => '[needs review] 查看房间';

  @override
  String get dormDetailSaveSuccess => '[needs review] 已保存至收藏';

  @override
  String get dormDetailUnsaveSuccess => '[needs review] 已取消收藏';

  @override
  String get dormDetailSaveError => '[needs review] 保存出错';

  @override
  String get facilityWifi => 'Wi-Fi';

  @override
  String get facilityWaterHeater => '热水器';

  @override
  String get facilityBalcony => '阳台';

  @override
  String get facilityTv => '电视';
}
