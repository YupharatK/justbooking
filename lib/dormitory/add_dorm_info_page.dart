import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../core/api_client.dart';
import '../services/owner_service.dart';
import 'map_picker_page.dart';

class AddDormInfoPage extends StatefulWidget {
  const AddDormInfoPage({super.key});

  @override
  State<AddDormInfoPage> createState() => _AddDormInfoPageState();
}

class _AddDormInfoPageState extends State<AddDormInfoPage> {
  final OwnerService _ownerService = OwnerService();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();

  String _selectedDormType = 'หอพักรวม';
  int _statusSelection = 0; // 0 = พร้อมเข้าอยู่, 1 = ว่างภายใน 1 เดือน
  int _availableRooms = 1;

  File? _coverImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  double? _latitude;
  double? _longitude;

  final Map<String, bool> _amenities = {
    'Wi-Fi': false,
    'ทีวี': false,
    'บิ้วด์อิน': false,
    'เครื่องทำน้ำอุ่น': false,
    'ระบบคีย์การ์ด': false,
  };

  final Map<String, IconData> _amenityIcons = {
    'Wi-Fi': Icons.wifi_rounded,
    'ทีวี': Icons.tv_rounded,
    'บิ้วด์อิน': Icons.weekend_rounded,
    'เครื่องทำน้ำอุ่น': Icons.hot_tub_rounded,
    'ระบบคีย์การ์ด': Icons.vpn_key_rounded,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickLocation() async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerPage(
          initialLocation: _latitude != null && _longitude != null 
              ? LatLng(_latitude!, _longitude!) 
              : null,
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _latitude = selectedLocation.latitude;
        _longitude = selectedLocation.longitude;
        _isLoading = true; // Show loading while fetching address
      });

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _latitude!,
          _longitude!,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          
          List<String> addressParts = [];
          if (place.name != null && place.name!.isNotEmpty) addressParts.add(place.name!);
          if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) addressParts.add(place.thoroughfare!);
          if (place.subLocality != null && place.subLocality!.isNotEmpty) addressParts.add(place.subLocality!);
          if (place.locality != null && place.locality!.isNotEmpty) addressParts.add(place.locality!);
          if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) addressParts.add(place.administrativeArea!);
          if (place.postalCode != null && place.postalCode!.isNotEmpty) addressParts.add(place.postalCode!);
          
          final addressString = addressParts.join(', ');
          
          setState(() {
            _addressController.text = addressString;
          });
        }
      } catch (e) {
        debugPrint('Geocoding error: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _saveDormitory() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final rules = _rulesController.text.trim();

    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกชื่อและที่อยู่หอพัก')),
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

      final description = 'ประเภท: $_selectedDormType\nสถานะ: ${_statusSelection == 0 ? 'พร้อมเข้าอยู่' : 'ว่างภายใน 1 เดือน'}\nห้องว่าง: $_availableRooms ห้อง';

      final data = {
        'name': name,
        'address': address,
        'latitude': _latitude,
        'longitude': _longitude,
        'description': description,
        'facilities': selectedAmenities,
        'rules': rules.isNotEmpty ? rules : null,
      };

      final dormId = await _ownerService.createDormitory(data);

      if (_coverImage != null) {
        await _ownerService.uploadDormitoryCoverImage(dormId, _coverImage!);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เพิ่มข้อมูลหอพักสำเร็จ', style: TextStyle(fontFamily: 'Kanit')),
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
          'เพิ่มข้อมูลหอพัก',
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Cover Image Upload
                  _buildSectionTitle('รูปหน้าปกหอพัก'),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CustomPaint(
                      painter: DashedRectPainter(color: Colors.grey.shade400, strokeWidth: 1.5, gap: 5.0),
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        color: Colors.grey.shade50.withOpacity(0.5),
                        child: _coverImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(_coverImage!, fit: BoxFit.cover, width: double.infinity),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade500, size: 36),
                                  const SizedBox(height: 8),
                                  Text(
                                    'แตะเพื่อเลือกรูปภาพ',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Dorm Name
                  _buildSectionTitle('ชื่อหอพัก'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'ระบุชื่อหอพักของคุณ',
                    bgColor: inputBgColor,
                  ),
                  const SizedBox(height: 24),

                  // 3. Dorm Type
                  _buildSectionTitle('ประเภทหอพัก'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: inputBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDormType,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
                        style: const TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 15,
                          color: textDarkColor,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDormType = newValue!;
                          });
                        },
                        items: <String>['หอพักรวม', 'หอพักชาย', 'หอพักหญิง']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Address & Map
                  _buildSectionTitle('ที่อยู่และพิกัด'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _addressController,
                    hintText: 'ระบุเลขที่บ้าน ถนน แขวง/ตำบล...',
                    bgColor: inputBgColor,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickLocation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600', 
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            color: Colors.white.withOpacity(0.2),
                            colorBlendMode: BlendMode.lighten,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, color: primaryColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _latitude != null ? 'เปลี่ยนพิกัดบนแผนที่' : 'เลือกพิกัดจากแผนที่',
                                  style: const TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. Status & Readiness
                  _buildSectionTitle('สถานะและความพร้อม'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusToggle(
                          index: 0,
                          title: 'พร้อมเข้าอยู่',
                          icon: Icons.check_circle_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusToggle(
                          index: 1,
                          title: 'ว่างภายใน 1 เดือน',
                          icon: Icons.access_time_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 6. Available Rooms
                  _buildSectionTitle('จำนวนห้องพักที่ว่าง'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_availableRooms > 1) {
                            setState(() {
                              _availableRooms--;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.remove, color: textDarkColor, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 60,
                        height: 45,
                        decoration: BoxDecoration(
                          color: inputBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _availableRooms.toString(),
                            style: const TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _availableRooms++;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: textDarkColor, size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'ห้อง',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: textDarkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 7. Amenities
                  _buildSectionTitle('สิ่งอำนวยความสะดวก'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _amenities.keys.map((String key) {
                      return _buildAmenityItem(key);
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // 8. Rules & Conditions
                  _buildSectionTitle('เงื่อนไขในการเช่าและกฎระเบียบ'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _rulesController,
                    hintText: 'เช่น ค่ามัดจำ 2 เดือน, สัญญา 1 ปี, ห้ามเลี้ยงสัตว์...',
                    bgColor: inputBgColor,
                    maxLines: 4,
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
                onPressed: _isLoading ? null : _saveDormitory,
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

  Widget _buildTextField({TextEditingController? controller, required String hintText, required Color bgColor, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
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

  Widget _buildStatusToggle({required int index, required String title, required IconData icon}) {
    bool isSelected = _statusSelection == index;
    const primaryColor = Color(0xFF3F6DE3);

    return GestureDetector(
      onTap: () {
        setState(() {
          _statusSelection = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey.shade600,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? primaryColor : Colors.grey.shade700,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityItem(String key) {
    bool isSelected = _amenities[key]!;
    return GestureDetector(
      onTap: () {
        setState(() {
          _amenities[key] = !isSelected;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 30, // 2 items per row approx
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF3F6DE3) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? const Color(0xFF3F6DE3) : Colors.grey.shade400,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Icon(_amenityIcons[key], size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                key,
                style: const TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 13,
                  color: Color(0xFF1F2937),
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for dashed border
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
