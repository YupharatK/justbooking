import 'package:flutter/material.dart';
import 'package:just_booking/models/room.dart';
import '../models/dormitory.dart';
import '../services/dormitory_service.dart';
import 'add_room_page.dart';

/// ----------------------------------------------------------------------
/// [DormitoryManagementPage]
/// ฟีเจอร์: "หน้ารายละเอียดและจัดการหอพัก (สำหรับเจ้าของ)"
/// หน้านี้จะถูกเปิดขึ้นเมื่อเจ้าของหอพักกดที่รายการหอพักในหน้า Dashboard
/// โดยจะแสดงข้อมูลของหอพักนั้น และรายการ **ประเภทห้องพักทั้งหมด** ที่มีอยู่
/// 
/// การเชื่อมต่อ API หลักในหน้านี้:
/// - DormitoryService.getDormitoryDetail() -> ใช้ดึงข้อมูลล่าสุดของหอพักและห้องทั้งหมด
/// ----------------------------------------------------------------------

class DormitoryManagementPage extends StatefulWidget {
  final Dormitory dormitory;
  const DormitoryManagementPage({super.key, required this.dormitory});

  @override
  State<DormitoryManagementPage> createState() => _DormitoryManagementPageState();
}

class _DormitoryManagementPageState extends State<DormitoryManagementPage> {
  final DormitoryService _dormitoryService = DormitoryService();
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
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        centerTitle: true,
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
                      const Text(
                        'ประเภทห้องพักทั้งหมด',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                      Text(
                        '${_dormitory.rooms?.length ?? 0} ห้อง',
                        style: TextStyle(
                          fontFamily: 'Kanit',
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
                            'ยังไม่มีข้อมูลห้องพัก',
                            style: TextStyle(fontFamily: 'Kanit', color: Colors.grey.shade500, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'กรุณากดปุ่มเพิ่มห้องพักด้านล่าง',
                            style: TextStyle(fontFamily: 'Kanit', color: Colors.grey.shade400, fontSize: 14),
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
        label: const Text(
          'เพิ่มห้องพัก',
          style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDormitoryInfoCard() {
    final bool isApproved = _dormitory.status == 'approved';
    final bool isRejected = _dormitory.status == 'rejected';
    
    String statusText = 'กำลังตรวจสอบ';
    Color statusColor = const Color(0xFFF59E0B);
    Color statusBgColor = const Color(0xFFFEF3C7);

    if (isApproved) {
      statusText = 'อนุมัติแล้ว';
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFD1FAE5);
    } else if (isRejected) {
      statusText = 'ถูกปฏิเสธ';
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
                        fontFamily: 'Kanit',
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
                          fontFamily: 'Kanit',
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
                    fontFamily: 'Kanit',
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
                    Text(
                      room.roomNumber ?? 'ประเภทห้อง',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: room.availableCount > 0 ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        room.availableCount > 0 ? 'ว่าง ${room.availableCount} ห้อง' : 'เต็มแล้ว',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: room.availableCount > 0 ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  room.roomType,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '฿${room.price.toStringAsFixed(0)} / เดือน',
                  style: const TextStyle(
                    fontFamily: 'Kanit',
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
}
