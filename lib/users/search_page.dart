import 'package:flutter/material.dart';
import '../services/dormitory_service.dart';
import '../models/dormitory.dart';
import 'dorm_detail_page.dart';
import '../core/localization/localization_extension.dart';

class SearchDormPage extends StatefulWidget {
  const SearchDormPage({super.key});

  @override
  State<SearchDormPage> createState() => _SearchDormPageState();
}

class _SearchDormPageState extends State<SearchDormPage> {
  final DormitoryService _dormitoryService = DormitoryService();
  final Set<String> _favorites = {};
  
  List<Dormitory> _searchResults = [];
  bool _isLoading = false;

  // Search and filter parameters
  String _searchQuery = '';
  double? _maxDistance;
  double? _minPrice;
  double? _maxPrice;

  final TextEditingController _searchController = TextEditingController();

  @override
    // ฟังก์ชัน initState จะถูกเรียกใช้งานเป็นสิ่งแรกสุดเมื่อเปิดหน้านี้ขึ้นมา (มักใช้สำหรับดึงข้อมูลเตรียมไว้)
void initState() {
    super.initState();
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

    // ฟังก์ชันแบบ Asynchronous สำหรับติดต่อระบบหลังบ้าน (Backend) หรือประมวลผลข้อมูล: _performSearch
Future<void> _performSearch() async {
        // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
      _isLoading = true;
    });

    try {
      final baseResults = await _dormitoryService.searchDormitories(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      
      // Fetch details for all dorms to get room availability data
      var results = await Future.wait(
        baseResults.map((d) => _dormitoryService.getDormitoryDetail(d.id))
      );

      // Local filtering for distance and price
      results = results.where((dorm) {
        // Distance Filter
        if (_maxDistance != null) {
          if (dorm.distanceFromUniversityKm > _maxDistance!) {
            return false;
          }
        }
        
        // Price Filter
        if (_maxPrice != null || _minPrice != null) {
          if (dorm.rooms == null || dorm.rooms!.isEmpty) {
            return false;
          }
          
          bool hasRoomInPriceRange = false;
          for (var room in dorm.rooms!) {
            bool matches = true;
            if (_minPrice != null && room.price < _minPrice!) matches = false;
            if (_maxPrice != null && room.price > _maxPrice!) matches = false;
            if (matches) {
              hasRoomInPriceRange = true;
              break;
            }
          }
          if (!hasRoomInPriceRange) {
            return false;
          }
        }
        
        return true;
      }).toList();

      if (mounted) {
                // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
                // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
          _isLoading = false;
        });
                // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.searchError)),
        );
      }
    }
  }

  void _toggleFavorite(String name) {
        // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
      if (_favorites.contains(name)) {
        _favorites.remove(name);
      } else {
        _favorites.add(name);
      }
    });
  }

  void _openFilterSheet() {
    bool enableDistance = _maxDistance != null;
    bool enablePrice = _maxPrice != null;
    double tempMaxDistance = _maxDistance ?? 5.0; // Default 5km
    double tempMaxPrice = _maxPrice ?? 10000.0;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.l10n.searchFilterTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if (enableDistance || enablePrice)
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              enableDistance = false;
                              enablePrice = false;
                            });
                          },
                          child: Text(context.l10n.searchFilterClear),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Price Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${context.l10n.searchFilterPrice}${tempMaxPrice.toInt()}${context.l10n.searchFilterPricePerMonth}', style: TextStyle(fontWeight: FontWeight.w600, color: enablePrice ? Colors.black87 : Colors.black38)),
                      Switch(
                        value: enablePrice,
                        activeColor: const Color(0xFF4274E6),
                        onChanged: (val) => setModalState(() => enablePrice = val),
                      ),
                    ],
                  ),
                  if (enablePrice)
                    Slider(
                      value: tempMaxPrice,
                      min: 1000,
                      max: 20000,
                      divisions: 19,
                      label: '฿${tempMaxPrice.toInt()}',
                      activeColor: const Color(0xFF4274E6),
                      onChanged: (val) {
                        setModalState(() => tempMaxPrice = val);
                      },
                    ),
                  const SizedBox(height: 16),
                  
                  // Distance Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${context.l10n.searchFilterDistance}${tempMaxDistance.toStringAsFixed(1)}${context.l10n.searchFilterDistanceKm}', style: TextStyle(fontWeight: FontWeight.w600, color: enableDistance ? Colors.black87 : Colors.black38)),
                      Switch(
                        value: enableDistance,
                        activeColor: const Color(0xFF4274E6),
                        onChanged: (val) => setModalState(() => enableDistance = val),
                      ),
                    ],
                  ),
                  if (enableDistance)
                    Slider(
                      value: tempMaxDistance,
                      min: 0.5,
                      max: 15.0,
                      divisions: 29,
                      label: '${tempMaxDistance.toStringAsFixed(1)} กม.',
                      activeColor: const Color(0xFF4274E6),
                      onChanged: (val) {
                        setModalState(() => tempMaxDistance = val);
                      },
                    ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:                     // ปุ่มกดแบบมีพื้นหลัง (ElevatedButton) เมื่อกดแล้วจะเรียกคำสั่งใน onPressed
ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4274E6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                                                // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
                          _maxPrice = enablePrice ? tempMaxPrice : null;
                          _maxDistance = enableDistance ? tempMaxDistance : null;
                        });
                        _performSearch();
                      },
                      child: Text(context.l10n.searchFilterApply, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

    // ฟังก์ชัน build ทำหน้าที่วาดหน้าจอ (UI) และจัดวาง Widget ต่างๆ ภายในหน้านี้
@override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4274E6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Back button & Title Section
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 24.0, top: 16.0, bottom: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor, size: 22),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    context.l10n.searchPageTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Custom Search Input & Filter Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                children: [
                  // Search Input Container
                  Expanded(
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.only(left: 20.0, right: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFF0F0F2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) {
                                _searchQuery = val;
                                _performSearch();
                              },
                              onSubmitted: (val) {
                                _searchQuery = val;
                                _performSearch();
                              },
                              decoration: InputDecoration(
                                hintText: context.l10n.searchHint,
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          // Blue circular search button inside input
                                                    // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                            onTap: () {
                              _searchQuery = _searchController.text;
                              _performSearch();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Outer Filter Button
                                    // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                    onTap: _openFilterSheet,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: (_maxDistance != null || _maxPrice != null) ? primaryColor.withOpacity(0.1) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: (_maxDistance != null || _maxPrice != null) ? primaryColor : const Color(0xFFF0F0F2)),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: (_maxDistance != null || _maxPrice != null) ? primaryColor : Colors.black45,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                '${context.l10n.searchResultCountTitle}${_searchResults.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 4. Large Cards Vertical List
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                  ? Center(child: Text(context.l10n.searchNoResults, style: const TextStyle(fontSize: 16, color: Colors.grey)))
                  :                   // ใช้ ListView.builder สำหรับสร้างรายการข้อมูลแบบเลื่อนได้ (Scrollable List) ซึ่งจะวาด UI ตามจำนวนข้อมูลที่มี
ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final dorm = _searchResults[index];
                        final isFav = _favorites.contains(dorm.name);
                        final imageUrl = dorm.coverImageUrl ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=600';
                        final priceText = dorm.rooms != null && dorm.rooms!.isNotEmpty 
                                ? dorm.rooms!.first.price.toStringAsFixed(0)
                                : '3,000';
                        final isAvailable = dorm.rooms != null && dorm.rooms!.any((r) => r.availableCount > 0);

                        return                         // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                          onTap: () {
                                                        // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DormDetailPage(
                                  dormId: dorm.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 320,
                            margin: const EdgeInsets.only(bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Stack(
                                children: [
                                  // Background Image
                                  Image.network(
                                    imageUrl,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade100,
                                      child: const Center(
                                        child: Icon(Icons.image, color: Colors.black26, size: 50),
                                      ),
                                    ),
                                  ),
                                  // Bottom Black Gradient Overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.0),
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Text Content & Details
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Title & Status Indicator Dot Row
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                dorm.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 4),
                                                  ],
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Status Dot Indicator
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: isAvailable
                                                    ? const Color(0xFF00C7FF) 
                                                    : const Color(0xFFFF3B30),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: (isAvailable ? const Color(0xFF00C7FF) : const Color(0xFFFF3B30)).withOpacity(0.5),
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        // Location Row
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                '${dorm.address} • ${context.l10n.searchDistanceLabel}${dorm.distanceFromUniversityKm} กม.',
                                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        // Thin White Divider
                                        Container(
                                          height: 1,
                                          color: Colors.white.withOpacity(0.15),
                                        ),
                                        const SizedBox(height: 12),
                                        // Price & Status Badge Row
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(text: context.l10n.searchPriceLabel, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                                  TextSpan(text: priceText, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                                                  TextSpan(text: context.l10n.dormManagePerMonth, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                            // Status Pill Badge
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: isAvailable
                                                    ? Colors.black.withOpacity(0.35)
                                                    : const Color(0xFFFF3B30).withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: isAvailable
                                                      ? Colors.white.withOpacity(0.1)
                                                      : const Color(0xFFFF3B30).withOpacity(0.4),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                isAvailable ? context.l10n.searchAvailable : context.l10n.searchFull,
                                                style: TextStyle(
                                                  color: isAvailable ? Colors.white : const Color(0xFFFF453A),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Heart Button
                                  Positioned(
                                    bottom: 84,
                                    right: 20,
                                    child:                                     // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                                      onTap: () => _toggleFavorite(dorm.name),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                          color: isFav ? Colors.red : Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
