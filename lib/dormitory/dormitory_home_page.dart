import 'package:flutter/material.dart';
import 'add_dorm_info_page.dart';
import 'owner_booking_dashboard.dart';
import 'dormitory_management_page.dart';
import '../models/dormitory.dart';
import '../models/user.dart';
import '../services/owner_service.dart';
import '../services/auth_service.dart';
import '../wellcome/login.dart';

/// ----------------------------------------------------------------------
/// [DormitoryHomePage]
/// หน้า Dashboard หลักสำหรับ "เจ้าของหอพัก" (Owner)
/// ทำหน้าที่เป็นศูนย์กลางรวบรวมฟีเจอร์ต่างๆ ของเจ้าของหอพัก ได้แก่:
/// 1. เมนู "เพิ่มข้อมูลหอพัก" (AddDormInfoPage)
/// 2. เมนู "จัดการคำขอจอง" (OwnerBookingDashboard)
/// 3. แสดงรายการ "หอพักของฉัน" ทั้งหมดที่ดึงมาจาก API (_ownerService.getMyDormitories)
/// 
/// การเชื่อมต่อ API หลักในหน้านี้:
/// - OwnerService.getMyDormitories() -> ดึงรายการหอพักทั้งหมดของ Owner คนนี้
/// - AuthService.getCurrentUser() -> ดึงข้อมูลโปรไฟล์ของ Owner มาแสดงด้านบน
/// ----------------------------------------------------------------------

class DormitoryHomePage extends StatefulWidget {
  const DormitoryHomePage({super.key});

  @override
  State<DormitoryHomePage> createState() => _DormitoryHomePageState();
}

class _DormitoryHomePageState extends State<DormitoryHomePage> {
  int _currentIndex = 0;
  final OwnerService _ownerService = OwnerService();
  final AuthService _authService = AuthService();
  List<Dormitory> _dorms = [];
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchDormitories();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> _fetchDormitories() async {
    try {
      final dorms = await _ownerService.getMyDormitories();
      if (mounted) {
        setState(() {
          _dorms = dorms;
        });
      }
    } catch (e) {
      debugPrint('Error fetching dormitories: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF8F9FB);
    const primaryColor = Color(0xFF3F6DE3);
    const textDarkColor = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Welcome & Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ยินดีต้อนรับกลับ 👋',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'สวัสดี, ${_currentUser?.firstName ?? 'เจ้าของหอพัก'}',
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: textDarkColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: NetworkImage(
                                  _currentUser?.profileImageUrl ?? 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200'),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.logout_rounded, color: Colors.red),
                        onPressed: () async {
                          bool confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('ออกจากระบบ', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
                                  content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?', style: TextStyle(fontFamily: 'Kanit')),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('ยกเลิก', style: TextStyle(fontFamily: 'Kanit', color: Colors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('ยืนยัน', style: TextStyle(fontFamily: 'Kanit', color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ) ??
                              false;

                          if (confirm && mounted) {
                            await _authService.logout();
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen(isOwner: true)),
                                (route) => false,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // 2. Main Menu Section
              Row(
                children: [
                  Icon(Icons.grid_view_rounded, color: primaryColor.withOpacity(0.8), size: 22),
                  const SizedBox(width: 10),
                  const Text(
                    'เมนูหลัก',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    // ฟีเจอร์: การเพิ่มหอพักใหม่
                    // เมื่อกดจะเปิดหน้า AddDormInfoPage เพื่อกรอกข้อมูลหอพัก
                    child: _buildMainMenuCard(
                      icon: Icons.storefront_outlined,
                      title: 'เพิ่มข้อมูลหอพัก',
                      subtitle: 'ลงทะเบียนใหม่',
                      iconBgColor: const Color(0xFFEEF2FF),
                      iconColor: primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddDormInfoPage()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    // ฟีเจอร์: จัดการคำขอจอง
                    // เมื่อกดจะเปิดหน้า OwnerBookingDashboard เพื่อดูคำขอที่ผู้เช่าส่งมา
                    child: _buildMainMenuCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'จัดการคำขอจอง',
                      subtitle: 'อนุมัติ/ปฏิเสธ',
                      iconBgColor: const Color(0xFFF0FDF4),
                      iconColor: const Color(0xFF22C55E),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OwnerBookingDashboard()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 3. My Dormitories Section (ส่วนแสดงรายการหอพักทั้งหมดของฉัน)
              // ฟีเจอร์: เรียกดูรายชื่อหอพักที่เราเป็นเจ้าของ
              // วนลูป (ListView) นำ _dorms แต่ละตัวมาแสดงเป็น _buildStatusCard
              // เมื่อกดที่การ์ดจะพาไปหน้าจัดการหอพักนั้นๆ (DormitoryManagementPage)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.business_rounded, color: primaryColor.withOpacity(0.8), size: 22),
                      const SizedBox(width: 10),
                      const Text(
                        'หอพักของฉัน',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _dorms.isNotEmpty 
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _dorms.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return _buildStatusCard(_dorms[index]);
                          },
                        )
                      : const Center(
                          child: Text(
                            'คุณยังไม่มีข้อมูลหอพัก',
                            style: TextStyle(fontFamily: 'Kanit', color: Colors.grey),
                          ),
                        ),
            ],
          ),
        ),
      ),
      // 4. Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kanit'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Kanit'),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: _currentIndex == 0
                    ? const Text(
                        'home',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          height: 1,
                        ),
                      )
                    : const Icon(Icons.home_outlined, size: 26),
              ),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none_rounded, size: 26),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              label: 'การแจ้งเตือน',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.chat_bubble_outline_rounded, size: 24),
              ),
              label: 'ข้อความ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Kanit',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ฟีเจอร์: สร้าง Card แสดงข้อมูลของแต่ละหอพัก
  /// หากคลิกที่การ์ด ระบบจะส่ง object [dorm] ตัวนี้ไปให้หน้า [DormitoryManagementPage] 
  /// เพื่อแสดงรายละเอียดและจัดการเพิ่มห้องพักต่อไป
  Widget _buildStatusCard(Dormitory dorm) {
    final bool isApproved = dorm.status == 'approved';
    bool isRejected = dorm.status == 'rejected';

    String statusText = 'REVIEWING';
    Color statusColor = const Color(0xFFF97316);
    Color statusBgColor = const Color(0xFFFFF7ED);

    if (isApproved) {
      statusText = 'APPROVED';
      statusColor = const Color(0xFF22C55E);
      statusBgColor = const Color(0xFFF0FDF4);
    } else if (isRejected) {
      statusText = 'REJECTED';
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DormitoryManagementPage(dormitory: dorm),
          ),
        ).then((_) => _fetchDormitories());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header of Status Card
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  dorm.coverImageUrl ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=150',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dorm.name,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: #DORM-${dorm.id}',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Progress Tracker
          Stack(
            alignment: Alignment.center,
            children: [
              // Connecting Lines
              Positioned(
                top: 20,
                left: 30,
                right: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: const Color(0xFFEEF2FF), // Very light blue
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isApproved ? const Color(0xFFEEF2FF) : Colors.grey.shade100,
                      ),
                    ),
                  ],
                ),
              ),
              // Steps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressStep(
                    icon: Icons.check_rounded,
                    label: 'ยื่นเรื่อง',
                    isActive: true,
                    isCompleted: true,
                    activeColor: const Color(0xFF22C55E),
                  ),
                  _buildProgressStep(
                    icon: isRejected ? Icons.close_rounded : Icons.hourglass_empty_rounded,
                    label: isRejected ? 'ถูกปฏิเสธ' : 'กำลังตรวจ',
                    isActive: true,
                    isCompleted: isApproved || isRejected,
                    activeColor: isRejected ? Colors.red : const Color(0xFF3B82F6),
                  ),
                  _buildProgressStep(
                    icon: Icons.verified_outlined,
                    label: 'อนุมัติ',
                    isActive: isApproved,
                    isCompleted: isApproved,
                    activeColor: const Color(0xFF22C55E),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildProgressStep({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isCompleted,
    required Color activeColor,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.grey.shade200,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey.shade400,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 12,
            fontWeight: isActive && !isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isActive && !isCompleted ? activeColor : (isCompleted ? const Color(0xFF1F2937) : Colors.grey.shade500),
          ),
        ),
      ],
    );
  }
}
