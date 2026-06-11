import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../wellcome/login.dart';
import 'edit_profile_page.dart';
import 'language_page.dart';
import 'favorites_page.dart';
import '../core/localization/localization_extension.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    super.key,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthService _authService = AuthService();
  int _currentIndex = 3; // Selected tab is Profile (index 3)

  User? _currentUser;
  bool _isLoading = true;

  @override
    // ฟังก์ชัน initState จะถูกเรียกใช้งานเป็นสิ่งแรกสุดเมื่อเปิดหน้านี้ขึ้นมา (มักใช้สำหรับดึงข้อมูลเตรียมไว้)
void initState() {
    super.initState();
    _loadUser();
  }

    // ฟังก์ชันแบบ Asynchronous สำหรับติดต่อระบบหลังบ้าน (Backend) หรือประมวลผลข้อมูล: _loadUser
Future<void> _loadUser() async {
    try {
      final user = await _authService.getCurrentUser();
            // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
            // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
        _isLoading = false;
      });
      if (mounted) {
                // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.profileLoadError, style: const TextStyle())),
        );
      }
    }
  }

  // Show log out confirmation bottom sheet
  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 54),
              const SizedBox(height: 16),
              Text(
                context.l10n.profileLogoutConfirmTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.profileLogoutConfirmDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        context.l10n.profileLogoutCancel,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:                     // ปุ่มกดแบบมีพื้นหลัง (ElevatedButton) เมื่อกดแล้วจะเรียกคำสั่งใน onPressed
ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context); // Close bottomsheet
                        try {
                          await _authService.logout();
                        } catch (_) {}
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        context.l10n.profileLogoutConfirmBtn,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

    // ฟังก์ชัน build ทำหน้าที่วาดหน้าจอ (UI) และจัดวาง Widget ต่างๆ ภายในหน้านี้
@override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4274E6);
    const brandColor = Color(0xFF3F6DE3); // Aesthetic blue color for the brand title
    const textDarkColor = Color(0xFF1F2937);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context, true),
          ),
        title: const Text(
          'The Modern Sanctuary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: brandColor,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: primaryColor))
        : _currentUser == null
          ? const Center(child: Text('ไม่พบข้อมูลผู้ใช้งาน', style: TextStyle()))
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                children: [
                  // 1. Profile Avatar & Information Section
                  Center(
                    child: Column(
                      children: [
                        // circular avatar with edit badge
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(_currentUser!.profileImageUrl ?? 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=300'),
                              ),
                            ),
                            // Floating edit badge
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child:                               // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                                onTap: () {
                                                                    // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(context.l10n.profileCameraToast, style: const TextStyle()),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Profile Name
                        Text(
                          _currentUser != null 
                            ? '${_currentUser!.firstName} ${_currentUser!.lastName}' 
                            : context.l10n.profileUnknownUser,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textDarkColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email Subtitle
                        Text(
                          _currentUser!.email,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 2. Menu List Items
                  _buildProfileMenuItem(
                    icon: Icons.edit_outlined,
                    iconBgColor: const Color(0xFFEEF2FF),
                    iconColor: primaryColor,
                    title: context.l10n.profileEdit,
                    onTap: () {
                                            // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(
                            currentName: '${_currentUser!.firstName} ${_currentUser!.lastName}',
                            currentPhone: _currentUser!.phone ?? '',
                            currentAddress: _currentUser!.address ?? '',
                            imageUrl: _currentUser!.profileImageUrl ?? 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=300',
                          ),
                        ),
                      ).then((updatedData) {
                        if (updatedData != null) {
                          _loadUser();
                        }
                      });
                    },
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.favorite_border_rounded,
                    iconBgColor: const Color(0xFFF3E8FF),
                    iconColor: Colors.purple.shade500,
                    title: context.l10n.profileFavorites,
                    onTap: () {
                                            // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoritesPage()),
                      );
                    },
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.translate_rounded,
                    iconBgColor: const Color(0xFFF3F4F6),
                    iconColor: Colors.grey.shade600,
                    title: context.l10n.profileChangeLanguage,
                    onTap: () {
                                            // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LanguagePage()),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 12),

                  // 3. Log out Card Styled as red highlighted card
                  Container(
                    margin: const EdgeInsets.only(bottom: 14.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2), // Very light red/pink
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: ListTile(
                      onTap: () => _showLogoutConfirmation(context),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                      ),
                      title: Text(
                        context.l10n.profileLogout,
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Navigation Bar (Matches Homepage Bottom Bar)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                                // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
                  _currentIndex = index;
                });
                // Pop back to Homepage to switch tabs
                Navigator.pop(context, {
                  'index': index,
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey.shade400,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(),
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.home_rounded, size: 24),
                  ),
                  label: 'หน้าหลัก',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.assignment_turned_in_rounded, size: 24),
                  ),
                  label: 'การจอง',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.chat_bubble_outline_rounded, size: 24),
                  ),
                  label: 'ข้อความ',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.notifications_rounded, size: 24),
                  ),
                  label: 'แจ้งเตือน',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // Builder helper for menu items
  Widget _buildProfileMenuItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.02)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
      ),
    );
  }
}
