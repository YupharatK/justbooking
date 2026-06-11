import 'package:flutter/material.dart';
import 'package:just_booking/main.dart'; // To access localeController
import 'package:just_booking/core/localization/localization_extension.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

    // ฟังก์ชัน build ทำหน้าที่วาดหน้าจอ (UI) และจัดวาง Widget ต่างๆ ภายในหน้านี้
@override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4274E6);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.l10n.languageTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: localeController,
        builder: (context, _) {
          final currentLocale = localeController.locale.languageCode;
          
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildLanguageOption(
                context,
                title: context.l10n.languageThai,
                localeCode: 'th',
                isSelected: currentLocale == 'th',
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context,
                title: context.l10n.languageEnglish,
                localeCode: 'en',
                isSelected: currentLocale == 'en',
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context,
                title: context.l10n.languageChinese,
                localeCode: 'zh',
                isSelected: currentLocale == 'zh',
                primaryColor: primaryColor,
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String localeCode,
    required bool isSelected,
    required Color primaryColor,
  }) {
    return     // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
      onTap: () {
        if (isSelected) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('เปลี่ยนภาษา', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text('คุณต้องการเปลี่ยนภาษาเป็น "$title" ใช่หรือไม่?\nDo you want to change language to "$title"?'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก (Cancel)', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  localeController.setLocale(Locale(localeCode));
                },
                child: const Text('ยืนยัน (Confirm)', style: TextStyle(color: Color(0xFF4274E6), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : const Color(0xFF1F2937),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: primaryColor, size: 24),
          ],
        ),
      ),
    );
  }
}
