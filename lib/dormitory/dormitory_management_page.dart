import 'package:flutter/material.dart';
import 'package:just_booking/models/room.dart';
import '../models/dormitory.dart';
import '../services/dormitory_service.dart';
import 'add_room_page.dart';
import 'add_dorm_info_page.dart';
import '../services/owner_service.dart';
import '../models/review.dart';
import '../core/localization/localization_extension.dart';

/// ----------------------------------------------------------------------
/// [DormitoryManagementPage]
/// ฟีเจอร์: "หน้ารายละเอียดและจัดการหอพัก (สำหรับเจ้าของ)"
/// หน้านี้จะถูกเปิดขึ้นเมื่อเจ้าของหอพักกดที่รายการหอพักในหน้า Dashboard
/// โดยจะแสดงข้อมูลของหอพักนั้น และรายการ **ประเภทห้องพักทั้งหมด** ที่มีอยู่
/// 
/// การเชื่อมต่อ API หลักในหน้านี้:
/// - DormitoryService.getDormitoryDetail() -> ใช้ดึงข้อมูลล่าสุดของหอพักและห้องทั้งหมด
/// ----------------------------------------------------------------------

/// หน้าจัดการหอพัก สำหรับแก้ไขข้อมูลหอพัก เพิ่มรูปภาพหน้าปก และเข้าสู่หน้าจัดการห้องพัก

class DormitoryManagementPage extends StatefulWidget {
  final Dormitory dormitory;
  const DormitoryManagementPage({super.key, required this.dormitory});

  @override
  State<DormitoryManagementPage> createState() => _DormitoryManagementPageState();
}

class _DormitoryManagementPageState extends State<DormitoryManagementPage> {
  final DormitoryService _dormitoryService = DormitoryService();
  final OwnerService _ownerService = OwnerService();
  late Dormitory _dormitory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dormitory = widget.dormitory;
    _fetchDormitoryDetail();
  }

  Future<void> _fetchDormitoryDetail() async {
    try {
      final dorm = await _dormitoryService.getDormitoryDetail(widget.dormitory.id);
      if (mounted) {
        setState(() {
          _dormitory = dorm;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.dormManageDeleteConfirmTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(context.l10n.dormManageDeleteConfirmDesc, style: const TextStyle()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.ownerBookingCancel, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.dormManageDelete, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      try {
        await _ownerService.deleteDormitory(_dormitory.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.dormManageDeleteSuccess, style: const TextStyle()), backgroundColor: Colors.green));
          Navigator.pop(context, true); // Pop back with true to refresh parent list
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.dormManageDeleteError, style: const TextStyle()), backgroundColor: Colors.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F6DE3);
    const bgColor = Color(0xFFF8F9FB);
    const textDarkColor = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _dormitory.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddDormInfoPage(dormitoryToEdit: _dormitory),
                ),
              ).then((_) => _fetchDormitoryDetail());
            },
            tooltip: context.l10n.dormManageEditTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
            onPressed: _confirmDelete,
            tooltip: context.l10n.dormManageDeleteTooltip,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDormitoryInfoCard(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.dormManageRoomTypesTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                      Text(
                        '${_dormitory.rooms?.length ?? 0}${context.l10n.dormManageRoomUnit}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_dormitory.rooms == null || _dormitory.rooms!.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bed_outlined, color: Colors.grey.shade300, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.dormManageNoRooms,
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.dormManageAddRoomHint,
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dormitory.rooms!.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildRoomCard(_dormitory.rooms![index]);
                      },
                    ),
                  const SizedBox(height: 32),
                  // Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.dormManageReviewsTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                      Text(
                        '${_dormitory.reviews?.length ?? 0}${context.l10n.dormManageReviewUnit}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_dormitory.reviews == null || _dormitory.reviews!.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.rate_review_outlined, color: Colors.grey.shade300, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.dormManageNoReviews,
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dormitory.reviews!.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildReviewCard(_dormitory.reviews![index]);
                      },
                    ),
                  const SizedBox(height: 100), // spacing for FAB
                ],
              ),
            ),
      /// ฟีเจอร์: ปุ่ม "เพิ่มห้องพัก" (Add Room)
      /// เมื่อกดปุ่ม ระบบจะเปิดหน้า AddRoomPage โดยส่งรหัสหอพัก (dormitoryId) ปัจจุบันไปให้
      /// เพื่อให้เวลาสร้างห้องพักใหม่ API จะรู้ว่าต้องผูกห้องพักนี้เข้ากับหอพักใด (One-to-Many)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddRoomPage(dormitoryId: _dormitory.id),
            ),
          ).then((_) => _fetchDormitoryDetail());
        },
        backgroundColor: primaryColor,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          context.l10n.dormManageAddRoomBtn,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDormitoryInfoCard() {
    final bool isApproved = _dormitory.status == 'approved';
    final bool isRejected = _dormitory.status == 'rejected';
    
    String statusText = context.l10n.dormManageStatusPending;
    Color statusColor = const Color(0xFFF59E0B);
    Color statusBgColor = const Color(0xFFFEF3C7);

    if (isApproved) {
      statusText = context.l10n.dormManageStatusApproved;
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFD1FAE5);
    } else if (isRejected) {
      statusText = context.l10n.dormManageStatusRejected;
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEE2E2);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _dormitory.coverImageUrl ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=150',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dormitory.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isRejected && _dormitory.rejectionReason != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFEF4444), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'เหตุผลที่ปฏิเสธ:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _dormitory.rejectionReason!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.grey.shade400, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _dormitory.address,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (room.images != null && room.images!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                room.images!.first.url,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.image_not_supported_rounded, color: Colors.grey.shade400),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        room.roomNumber.isNotEmpty ? room.roomNumber : context.l10n.dormManageRoomTypeLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: room.availableCount > 0 ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            room.availableCount > 0 ? '${context.l10n.dormManageAvailable}${room.availableCount}${context.l10n.dormManageRoomUnit}' : context.l10n.dormManageFull,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: room.availableCount > 0 ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddRoomPage(
                                    dormitoryId: _dormitory.id,
                                    roomToEdit: room,
                                  ),
                                ),
                              ).then((_) => _fetchDormitoryDetail());
                            } else if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(context.l10n.dormManageDeleteConfirmTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  content: Text(context.l10n.dormManageDeleteRoomConfirm),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text(context.l10n.ownerBookingCancel, style: const TextStyle(color: Colors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text(context.l10n.dormManageDelete, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                try {
                                  await _ownerService.deleteRoom(room.id);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.dormManageDeleteRoomSuccess), backgroundColor: Colors.green));
                                    _fetchDormitoryDetail();
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.dormManageDeleteRoomError), backgroundColor: Colors.red));
                                  }
                                }
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [const Icon(Icons.edit_rounded, size: 20), const SizedBox(width: 8), Text(context.l10n.dormManageEdit)],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [const Icon(Icons.delete_rounded, size: 20, color: Colors.red), const SizedBox(width: 8), Text(context.l10n.dormManageDelete, style: const TextStyle(color: Colors.red))],
                              ),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  room.roomType,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '฿${room.price.toStringAsFixed(0)}${context.l10n.dormManagePerMonth}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F6DE3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF3F6DE3).withOpacity(0.1),
                child: Text(
                  (review.user?.firstName ?? 'U').substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF3F6DE3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${review.user?.firstName ?? context.l10n.dormManageUserUnknown} ${review.user?.lastName ?? ''}'.trim(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          review.rating.toStringAsFixed(1),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.createdAt.split('T').first,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
          ),
          const SizedBox(height: 12),
          if (review.ownerReply != null && review.ownerReply!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.reply_rounded, size: 16, color: Color(0xFF3F6DE3)),
                      const SizedBox(width: 6),
                      Text(
                        context.l10n.dormManageYourReply,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF3F6DE3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.ownerReply!,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
                  ),
                ],
              ),
            ),
          ] else ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _openReplySheet(review),
                icon: const Icon(Icons.reply_rounded, size: 18),
                label: Text(context.l10n.dormManageReplyBtn, style: const TextStyle(fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3F6DE3),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: const Color(0xFF3F6DE3).withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openReplySheet(Review review) {
    final TextEditingController replyController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.dormManageReplyTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      '"${review.comment}"',
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: replyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: context.l10n.dormManageReplyHint,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              if (replyController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.dormManageReplyEmptyError)));
                                return;
                              }
                              setModalState(() => isSubmitting = true);
                              try {
                                await _ownerService.replyReview(review.id, replyController.text.trim());
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.dormManageReplySuccess), backgroundColor: Colors.green));
                                  _fetchDormitoryDetail();
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.dormManageReplyError), backgroundColor: Colors.red));
                                }
                              } finally {
                                setModalState(() => isSubmitting = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F6DE3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(context.l10n.dormManageSendReplyBtn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
