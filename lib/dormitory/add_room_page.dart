import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import '../core/api_client.dart';
import '../services/owner_service.dart';

/// ----------------------------------------------------------------------
/// [AddRoomPage]
/// ฟีเจอร์: "หน้าลงทะเบียนห้องพัก"
/// หน้านี้สำหรับให้เจ้าของหอพักกรอกรายละเอียดของแต่ละประเภทห้องพัก 
/// เช่น ระบุประเภทห้อง (แอร์/พัดลม), ราคา, จำนวนห้องว่าง, เลือกสิ่งอำนวยความสะดวก และอัปโหลดภาพห้องพักหลายๆ รูป
/// 
/// การเชื่อมต่อ API หลักในหน้านี้:
/// - OwnerService.createRoom(dormitoryId) -> สร้างห้องพักและผูกเข้ากับหอพักที่ระบุ
/// - OwnerService.uploadRoomImages() -> อัปโหลดไฟล์รูปภาพห้องพักทีละหลายรูป (Multi-Multipart)
/// ----------------------------------------------------------------------

class AddRoomPage extends StatefulWidget {
  final int dormitoryId;
  const AddRoomPage({super.key, required this.dormitoryId});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final OwnerService _ownerService = OwnerService();
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _availableCountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<File> _roomImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  String _selectedAirType = 'แอร์'; // แอร์ หรือ พัดลม
  String _selectedBedType = 'เตียงเดี่ยว'; // เตียงเดี่ยว หรือ เตียงคู่
  
  // Amenities
  final Map<String, bool> _amenities = {
    'Wi-Fi': false,
    'เครื่องทำน้ำอุ่น': false,
    'ระเบียง': false,
    'ทีวี': false,
  };

  final Map<String, IconData> _amenityIcons = {
    'Wi-Fi': Icons.wifi_rounded,
    'เครื่องทำน้ำอุ่น': Icons.hot_tub_rounded,
    'ระเบียง': Icons.balcony_rounded,
    'ทีวี': Icons.tv_rounded,
  };

  @override
  void dispose() {
    _roomNumberController.dispose();
    _availableCountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        for (var pickedFile in pickedFiles) {
          if (_roomImages.length < 5) {
            _roomImages.add(File(pickedFile.path));
          }
        }
      });
    }
  }

  Future<void> _saveRoom() async {
    final roomNumber = _roomNumberController.text.trim();
    final priceStr = _priceController.text.trim();
    final countStr = _availableCountController.text.trim();

    if (priceStr.isEmpty || countStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกราคาและจำนวนห้องว่าง')),
      );
      return;
    }

    if (_roomImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกรูปห้องตัวอย่างอย่างน้อย 1 รูป')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedAmenities = _amenities.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      final data = {
        'roomNumber': roomNumber.isNotEmpty ? roomNumber : null,
        'roomType': '$_selectedAirType - $_selectedBedType',
        'price': double.tryParse(priceStr) ?? 0,
        'availableCount': int.tryParse(countStr) ?? 1,
        'facilities': selectedAmenities,
      };

      final roomId = await _ownerService.createRoom(widget.dormitoryId, data);
      await _ownerService.uploadRoomImages(roomId, _roomImages);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เพิ่มข้อมูลห้องพักสำเร็จ', style: TextStyle(fontFamily: 'Kanit')),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง')),
      );
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
    const primaryColor = Color(0xFF3F6DE3);
    const textDarkColor = Color(0xFF1F2937);
    const bgColor = Color(0xFFFAFAFC);
    const inputBgColor = Color(0xFFF3F4F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'เพิ่มห้องพัก',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: textDarkColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Photos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('รูปถ่ายห้องพัก'),
                      Text(
                        '${_roomImages.length} / 5 รูป',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_roomImages.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _roomImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(_roomImages[index], fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _roomImages.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (_roomImages.isNotEmpty) const SizedBox(height: 12),
                  if (_roomImages.length < 5)
                    GestureDetector(
                      onTap: _pickImages,
                      child: CustomPaint(
                        painter: DashedRectPainter(color: Colors.grey.shade400, strokeWidth: 1.5, gap: 5.0),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          color: Colors.grey.shade50.withOpacity(0.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_a_photo_outlined, color: Color(0xFF3F6DE3), size: 28),
                              const SizedBox(height: 8),
                              const Text(
                                'เพิ่มรูปภาพ (สูงสุด 5 รูป)',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // 2. Room Number / Name
                  _buildSectionTitle('หมายเลขห้อง / ชื่อประเภทห้อง'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _roomNumberController,
                    hintText: 'เช่น A101 หรือ ห้องสแตนดาร์ด',
                    bgColor: inputBgColor,
                  ),
                  const SizedBox(height: 24),

                  // NEW: Available Rooms Count
                  _buildSectionTitle('จำนวนห้องที่ว่าง (ห้อง)'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _availableCountController,
                    hintText: 'ระบุจำนวนห้องว่าง เช่น 5',
                    bgColor: inputBgColor,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),

                  // 3. Room Type (Air/Fan)
                  _buildSectionTitle('ประเภทระบบทำความเย็น'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectableCard(
                          title: 'ห้องแอร์',
                          icon: Icons.ac_unit_rounded,
                          isSelected: _selectedAirType == 'แอร์',
                          onTap: () => setState(() => _selectedAirType = 'แอร์'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSelectableCard(
                          title: 'ห้องพัดลม',
                          icon: Icons.wind_power_rounded,
                          isSelected: _selectedAirType == 'พัดลม',
                          onTap: () => setState(() => _selectedAirType = 'พัดลม'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 4. Bed Type (Single/Double)
                  _buildSectionTitle('ประเภทเตียง'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectableCard(
                          title: 'เตียงเดี่ยว',
                          icon: Icons.single_bed_rounded,
                          isSelected: _selectedBedType == 'เตียงเดี่ยว',
                          onTap: () => setState(() => _selectedBedType = 'เตียงเดี่ยว'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSelectableCard(
                          title: 'เตียงคู่',
                          icon: Icons.bed_rounded,
                          isSelected: _selectedBedType == 'เตียงคู่',
                          onTap: () => setState(() => _selectedBedType = 'เตียงคู่'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 5. Price
                  _buildSectionTitle('ราคาเริ่มต้น (บาท/เดือน)'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'เช่น 4500',
                      hintStyle: TextStyle(fontFamily: 'Kanit', fontSize: 16, color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: inputBgColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: const Center(widthFactor: 1, child: Text('฿ ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Kanit'))),
                      suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 6. Amenities
                  _buildSectionTitle('สิ่งอำนวยความสะดวก'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _amenities.keys.map((String key) {
                      return _buildAmenityChip(key);
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: _isLoading ? null : _saveRoom,
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                  'บันทึกข้อมูล',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildTextField({TextEditingController? controller, required String hintText, required Color bgColor, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: 'Kanit', fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'Kanit', fontSize: 14, color: Colors.grey.shade500),
        filled: true,
        fillColor: bgColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSelectableCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF3F6DE3);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey.shade600,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF1F2937) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityChip(String key) {
    bool isSelected = _amenities[key]!;
    const primaryColor = Color(0xFF3F6DE3);

    return GestureDetector(
      onTap: () {
        setState(() {
          _amenities[key] = !isSelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _amenityIcons[key],
              color: isSelected ? primaryColor : Colors.grey.shade700,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              key,
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for dashed border (reused from AddDormInfoPage)
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({required this.color, required this.strokeWidth, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(x, 0)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..close();

    Path dashPath = Path();

    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
      distance = 0.0;
    }

    canvas.drawPath(dashPath, dashedPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
