import 'package:flutter/material.dart';
import 'add_dorm_info_page.dart';
import 'owner_booking_dashboard.dart';
import 'dormitory_management_page.dart';
import '../models/dormitory.dart';
import '../models/user.dart';
import '../services/owner_service.dart';
import '../services/auth_service.dart';
import '../wellcome/login.dart';
import 'owner_chat_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';
import '../users/edit_profile_page.dart';
import 'owner_tenants_page.dart';

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

/// หน้าจอหลัก (Dashboard) ของฝั่งเจ้าของหอพัก แสดงรายการหอพักทั้งหมดที่เปิดให้เช่า

class DormitoryHomePage extends StatefulWidget {
  const DormitoryHomePage({super.key});

  @override
  State<DormitoryHomePage> createState() => _DormitoryHomePageState();
}

class _DormitoryHomePageState extends State<DormitoryHomePage> {
  int _currentIndex = 0;
  final OwnerService _ownerService = OwnerService();
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  List<Dormitory> _dorms = [];
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchDormitories();
  }

  // ฟังก์ชันดึงข้อมูลโปรไฟล์ของเจ้าของหอพัก (ชื่อ, รูปโปรไฟล์)

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

  // ฟังก์ชันดึงข้อมูลรายชื่อหอพักที่เจ้าของคนนี้ดูแลอยู่

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
        child: _currentIndex == 2 
          ? OwnerChatDashboard(dormitories: _dorms)
          : _currentIndex == 1
              ? _buildNotificationTab()
              : SingleChildScrollView(
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
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'สวัสดี, ${_currentUser?.firstName ?? 'เจ้าของหอพัก'}',
                          style: const TextStyle(
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
                      GestureDetector(
                        onTap: () {
                          if (_currentUser == null) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfilePage(
                                currentName: '${_currentUser!.firstName ?? ''} ${_currentUser!.lastName ?? ''}'.trim(),
                                currentPhone: _currentUser!.phone ?? '',
                                currentAddress: _currentUser!.address ?? '',
                                imageUrl: _currentUser!.profileImageUrl ?? 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200',
                              ),
                            ),
                          ).then((value) {
                            if (value == true) {
                              _fetchUserData();
                            }
                          });
                        },
                        child: Stack(
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
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.logout_rounded, color: Colors.red),
                        onPressed: () async {
                          bool confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('ออกจากระบบ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?', style: TextStyle()),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('ยืนยัน', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                        ).then((_) => _fetchDormitories());
                      },
                    ),
                  ),
                  Expanded(
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMainMenuCard(
                      icon: Icons.people_alt_outlined,
                      title: 'ประวัติผู้เช่า',
                      subtitle: 'รีวิว & จัดการผู้เช่า',
                      iconBgColor: const Color(0xFFFFFBEB),
                      iconColor: const Color(0xFFF59E0B),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OwnerTenantsPage()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(), // Empty space for layout balance
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 3. My Dormitories Section
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
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
            ],
          ),
        ),
      ),
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
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: _currentIndex == 0
                    ? const Icon(Icons.home_rounded, size: 26, color: primaryColor)
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
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
            fontSize: 12,
            fontWeight: isActive && !isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isActive && !isCompleted ? activeColor : (isCompleted ? const Color(0xFF1F2937) : Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  // --- TAB 1: NOTIFICATIONS ---
  Widget _buildNotificationTab() {
    const primaryColor = Color(0xFF3F6DE3);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'การแจ้งเตือน (เจ้าของ)',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('อ่านทั้งหมด', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _currentUser == null
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: _notificationService.getUserNotifications(_currentUser!.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดแจ้งเตือน', style: TextStyle()));
                      }
                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return const Center(
                          child: Text('ไม่มีการแจ้งเตือน', style: TextStyle(color: Colors.grey)),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final notifData = docs[index].data() as Map<String, dynamic>;
                          final notifId = docs[index].id;
                          
                          final bool isRead = notifData['isRead'] ?? false;
                          final String title = notifData['title'] ?? '';
                          final String desc = notifData['desc'] ?? '';
                          final timestamp = notifData['timestamp'] as Timestamp?;
                          final DateTime time = timestamp?.toDate() ?? DateTime.now();
                          
                          String timeStr;
                          final now = DateTime.now();
                          if (now.difference(time).inDays == 0 && now.day == time.day) {
                            timeStr = DateFormat('HH:mm').format(time);
                          } else if (now.difference(time).inDays == 1 || (now.difference(time).inDays == 0 && now.day != time.day)) {
                            timeStr = 'เมื่อวาน';
                          } else {
                            timeStr = DateFormat('d MMM').format(time);
                          }
                          
                          // Determine icon
                          IconData icon = Icons.notifications_rounded;
                          Color iconColor = primaryColor;
                          if (notifData['type'] == 'booking_success') {
                            icon = Icons.check_circle_rounded;
                            iconColor = const Color(0xFF34C759);
                          } else if (notifData['type'] == 'new_booking') {
                            icon = Icons.celebration_rounded;
                            iconColor = primaryColor;
                          }

                          return GestureDetector(
                            onTap: () {
                              if (!isRead) {
                                _notificationService.markAsRead(notifId);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: isRead ? Colors.transparent : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isRead
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.02),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                border: Border.all(
                                  color: isRead ? Colors.grey.shade200 : primaryColor.withOpacity(0.06),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: iconColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icon, color: iconColor, size: 20),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: isRead ? FontWeight.bold : FontWeight.w800,
                                                  color: const Color(0xFF1F2937),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              timeStr,
                                              style: const TextStyle(
                                                color: Colors.black38,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          desc,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12.5,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
