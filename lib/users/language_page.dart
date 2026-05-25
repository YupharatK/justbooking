import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  // Assuming 'th' for Thai, 'en' for English, 'zh' for Chinese
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F6DE3); // Matching brand blue
    const textDarkColor = Color(0xFF1F2937);
    const bgColor = Color(0xFFFAFAFC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'เปลี่ยนภาษา',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เลือกภาษาที่คุณสะดวก',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLanguageOption(
                    title: 'ภาษาไทย',
                    subtitle: 'Thai',
                    value: 'th',
                    isSelected: _selectedLanguage == 'th',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'th';
                      });
                    },
                  ),
                  _buildLanguageOption(
                    title: 'English',
                    subtitle: 'International',
                    value: 'en',
                    isSelected: _selectedLanguage == 'en',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'en';
                      });
                    },
                  ),
                  _buildLanguageOption(
                    title: '中文',
                    subtitle: 'Chinese',
                    value: 'zh',
                    isSelected: _selectedLanguage == 'zh',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'zh';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white),
                          SizedBox(width: 10),
                          Text('เปลี่ยนภาษาสำเร็จเรียบร้อยแล้ว', style: TextStyle(fontFamily: 'Kanit')),
                        ],
                      ),
                      backgroundColor: Color(0xFF2ECC71),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  Navigator.pop(context, _selectedLanguage);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'บันทึก',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String subtitle,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF3F6DE3);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor.withOpacity(0.5) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // White circle icon placeholder
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade400,
                  width: isSelected ? 6 : 2,
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
