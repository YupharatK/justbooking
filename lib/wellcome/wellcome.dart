import 'package:flutter/material.dart';
import 'login.dart';
import '../services/auth_service.dart';
import '../users/home_page.dart';
import '../dormitory/dormitory_home_page.dart';

class WellcomePage extends StatefulWidget {
  const WellcomePage({super.key});

  @override
  State<WellcomePage> createState() => _WellcomePageState();
}

class _WellcomePageState extends State<WellcomePage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authService.getCurrentUser();
        if (!mounted) return;
        
        if (user.role == 'owner') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DormitoryHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserHomePage()),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF5A84ED),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA), // Light background color
      body: Stack(
        children: [
          // Blue Header Background
          Container(
            height: MediaQuery.of(context).size.height * 0.42,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF5A84ED), // A shade of blue similar to image
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Text Section
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'คุณคือใคร ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'เลือกตัวเลือกที่ตรงกับ\nความต้องการของคุณ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48), // Space before first card
                
                // Cards Section
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // General user login text
                          const Padding(
                            padding: EdgeInsets.only(left: 16, bottom: 12),
                            child: Text(
                              'ลงชื่อเข้าใช้สำหรับผู้ใช้งานทั่วไป',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          // General user card
                          _buildOptionCard(
                            icon: Icons.person,
                            title: 'ผู้ใช้งานทั่วไป',
                            subtitle: 'ค้นหาและจองหอพัก',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen(isOwner: false)),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Owner user login text
                          const Padding(
                            padding: EdgeInsets.only(left: 16, bottom: 12),
                            child: Text(
                              'ลงชื่อเข้าใช้สำหรับเจ้าของหอพัก',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          // Owner user card
                          _buildOptionCard(
                            icon: Icons.business,
                            title: 'เจ้าของหอพัก',
                            subtitle: 'จัดการหอพักของคุณ',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen(isOwner: true)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Bottom Help text
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ต้องการความช่วยเหลือ? ',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to Contact us
                        },
                        child: const Text(
                          'ติดต่อเรา',
                          style: TextStyle(
                            color: Color(0xFF5A84ED),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5A84ED).withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF), // Very light blue
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF5A84ED),
                size: 32,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937), // Dark text
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280), // Gray subtitle
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
