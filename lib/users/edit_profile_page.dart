import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentPhone;
  final String currentAddress;
  final String imageUrl;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentPhone,
    required this.currentAddress,
    required this.imageUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late String _imageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);
    _addressController = TextEditingController(text: widget.currentAddress);
    _imageUrl = widget.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Handle Save
  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน', style: TextStyle(fontFamily: 'Kanit')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Split name to first and last name for API
      final nameParts = name.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await _authService.updateProfile({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'address': address,
        // Optional: 'profileImageUrl': _imageUrl if your API supports updating it this way
      });

      setState(() {
        _isSaving = false;
      });

      if (!mounted) return;

      // Success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('แก้ไขข้อมูลโปรไฟล์สำเร็จเรียบร้อยแล้ว', style: TextStyle(fontFamily: 'Kanit')),
            ],
          ),
          backgroundColor: Color(0xFF2ECC71),
          duration: Duration(seconds: 1),
        ),
      );

      // Pop back with success flag
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาดในการอัปเดตโปรไฟล์', style: TextStyle(fontFamily: 'Kanit')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F6DE3); // Matching brand blue
    const textDarkColor = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'แก้ไขโปรไฟล์',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Avatar Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.1),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(_imageUrl),
                              ),
                            ),
                            // Floating edit badge
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // Mock toggle image or change to different profile image
                                  setState(() {
                                    // toggle between two professional avatars
                                    if (_imageUrl.contains('photo-1573496359142-b8d87734a5a2')) {
                                      _imageUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300';
                                    } else {
                                      _imageUrl = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=300';
                                    }
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('เปลี่ยนรูปภาพโปรไฟล์เรียบร้อยแล้ว', style: TextStyle(fontFamily: 'Kanit')),
                                      duration: Duration(seconds: 1),
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
                                        blurRadius: 6,
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
                        const SizedBox(height: 12),
                        const Text(
                          'แตะเพื่อเปลี่ยนรูปโปรไฟล์',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            color: Colors.black38,
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 2. Form Inputs - matching the mockup design boxes
                  // Username Field
                  const Text(
                    'ชื่อผู้ใช้งาน',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(fontFamily: 'Kanit', color: textDarkColor, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person_outline_rounded, color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Phone Number Field
                  const Text(
                    'เบอร์โทรศัพท์',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontFamily: 'Kanit', color: textDarkColor, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone_outlined, color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Address Field
                  const Text(
                    'ที่อยู่ปัจจุบัน',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _addressController,
                      maxLines: 3,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        color: textDarkColor,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      decoration: const InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: 24.0), // Align icon with top of multiline
                          child: Icon(Icons.location_on_outlined, color: Colors.black54),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // 3. Confirm Bottom Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F6DE3), // Elegant blue color as in button mockup
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'ยืนยัน',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
