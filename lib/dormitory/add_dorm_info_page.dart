import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../core/api_client.dart';
import 'package:http/http.dart' as http;
import '../services/owner_service.dart';
import 'map_picker_page.dart';
import '../models/dormitory.dart';
import '../core/localization/localization_extension.dart';

/// ----------------------------------------------------------------------
/// [AddDormInfoPage]
/// ฟีเจอร์: "หน้าลงทะเบียนหอพักใหม่"
/// หน้านี้ให้เจ้าของหอพักกรอกข้อมูลพื้นฐานของหอพัก เช่น ชื่อ, ที่อยู่, อัปโหลดรูปภาพปก (Cover Image)
/// รวมถึงสามารถกด "ปักหมุดแผนที่" เพื่อให้ได้ละติจูด/ลองจิจูด มาเก็บลงในฐานข้อมูล
/// 
/// การเชื่อมต่อ API หลักในหน้านี้:
/// - OwnerService.createDormitory() -> ใช้สร้างข้อมูลหอพักใหม่ลงฐานข้อมูล
/// - OwnerService.uploadDormitoryCoverImage() -> อัปโหลดไฟล์รูปภาพปกแบบ Multipart
/// ----------------------------------------------------------------------

/// หน้าฟอร์มสำหรับลงทะเบียนเพิ่มหอพักใหม่เข้าสู่ระบบ

class AddDormInfoPage extends StatefulWidget {
  final Dormitory? dormitoryToEdit;

  const AddDormInfoPage({super.key, this.dormitoryToEdit});

  @override
  State<AddDormInfoPage> createState() => _AddDormInfoPageState();
}

class _AddDormInfoPageState extends State<AddDormInfoPage> {
  final OwnerService _ownerService = OwnerService();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _promptPayNumberController = TextEditingController();

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
  void initState() {
    super.initState();
    if (widget.dormitoryToEdit != null) {
      final dorm = widget.dormitoryToEdit!;
      _nameController.text = dorm.name;
      _addressController.text = dorm.address;
      _rulesController.text = dorm.rules;
      
      if (dorm.bankName != null) _bankNameController.text = dorm.bankName!;
      if (dorm.accountName != null) _accountNameController.text = dorm.accountName!;
      if (dorm.accountNumber != null) _accountNumberController.text = dorm.accountNumber!;
      if (dorm.promptPayNumber != null) _promptPayNumberController.text = dorm.promptPayNumber!;
      
      if (dorm.latitude != 0.0 && dorm.longitude != 0.0) {
        _latitude = dorm.latitude;
        _longitude = dorm.longitude;
      }
      
      for (var facility in dorm.facilities) {
        if (_amenities.containsKey(facility)) {
          _amenities[facility] = true;
        }
      }

      // Parse description for dormType, status, available rooms if available in mock data
      if (dorm.description.contains('ว่างภายใน 1 เดือน')) {
        _statusSelection = 1;
      }
      if (dorm.description.contains('หอพักชาย')) {
        _selectedDormType = 'หอพักชาย';
      } else if (dorm.description.contains('หอพักหญิง')) {
        _selectedDormType = 'หอพักหญิง';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _rulesController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _promptPayNumberController.dispose();
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

  // ฟังก์ชันสำหรับบันทึกข้อมูลหอพักใหม่ส่งไปยัง Backend

  Future<void> _saveDormitory() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final rules = _rulesController.text.trim();

    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.addDormValidationError)),
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
        'bank_name': _bankNameController.text.trim().isNotEmpty ? _bankNameController.text.trim() : null,
        'account_name': _accountNameController.text.trim().isNotEmpty ? _accountNameController.text.trim() : null,
        'account_number': _accountNumberController.text.trim().isNotEmpty ? _accountNumberController.text.trim() : null,
        'promptpay_number': _promptPayNumberController.text.trim().isNotEmpty ? _promptPayNumberController.text.trim() : null,
      };

      if (widget.dormitoryToEdit == null) {
        final dormId = await _ownerService.createDormitory(data);

        if (_coverImage != null) {
          await _ownerService.uploadDormitoryCoverImage(dormId, _coverImage!);
        }
      } else {
        await _ownerService.updateDormitory(widget.dormitoryToEdit!.id, data);
        if (_coverImage != null) {
          await _ownerService.uploadDormitoryCoverImage(widget.dormitoryToEdit!.id, _coverImage!);
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.dormitoryToEdit == null ? context.l10n.addDormAddSuccess : context.l10n.addDormEditSuccess, style: const TextStyle()),
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
        SnackBar(content: Text(context.l10n.addDormError)),
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
        title: Text(
          widget.dormitoryToEdit == null ? context.l10n.addDormTitleAdd : context.l10n.addDormTitleEdit,
          style: const TextStyle(
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
                  _buildSectionTitle(context.l10n.addDormCoverImage),
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
                            : widget.dormitoryToEdit?.coverImageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(widget.dormitoryToEdit!.coverImageUrl!, fit: BoxFit.cover, width: double.infinity),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade500, size: 36),
                                  const SizedBox(height: 8),
                                  Text(
                                    context.l10n.addDormImageHint,
                                    style: TextStyle(
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
                  _buildSectionTitle(context.l10n.addDormNameTitle),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _nameController,
                    hintText: context.l10n.addDormNameHint,
                    bgColor: inputBgColor,
                  ),
                  const SizedBox(height: 24),

                  // 3. Dorm Type
                  _buildSectionTitle(context.l10n.addDormTypeTitle),
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
                            child: Text(value == 'หอพักชาย' ? context.l10n.addDormTypeMale : value == 'หอพักหญิง' ? context.l10n.addDormTypeFemale : context.l10n.addDormTypeMixed),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Address & Map
                  _buildSectionTitle(context.l10n.addDormAddressTitle),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _addressController,
                    hintText: context.l10n.addDormAddressHint,
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
                                  _latitude != null ? context.l10n.addDormMapChange : context.l10n.addDormMapSelect,
                                  style: const TextStyle(
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
                  _buildSectionTitle(context.l10n.addDormStatusTitle),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusToggle(
                          index: 0,
                          title: context.l10n.addDormStatusReady,
                          icon: Icons.check_circle_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusToggle(
                          index: 1,
                          title: context.l10n.addDormStatusOneMonth,
                          icon: Icons.access_time_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 6. Available Rooms
                  _buildSectionTitle(context.l10n.addDormAvailableCountTitle),
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
                      Text(
                        context.l10n.addDormRoomUnit,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: textDarkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 7. Amenities
                  _buildSectionTitle(context.l10n.addRoomFacilitiesTitle),
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
                  _buildSectionTitle(context.l10n.addDormRulesTitle),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _rulesController,
                    hintText: context.l10n.addDormRulesHint,
                    bgColor: inputBgColor,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),

                  // 9. Payment Info
                  _buildSectionTitle(context.l10n.addDormPaymentTitle),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _bankNameController,
                    hintText: context.l10n.addDormBankHint,
                    bgColor: inputBgColor,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _accountNameController,
                    hintText: context.l10n.addDormAccountNameHint,
                    bgColor: inputBgColor,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _accountNumberController,
                    hintText: context.l10n.addDormAccountNumberHint,
                    bgColor: inputBgColor,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _promptPayNumberController,
                    hintText: context.l10n.addDormPromptPayHint,
                    bgColor: inputBgColor,
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
                    : Text(
                  context.l10n.addDormSaveBtn,
                  style: TextStyle(
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
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
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
