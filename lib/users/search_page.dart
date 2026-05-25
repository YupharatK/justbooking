import 'package:flutter/material.dart';
import '../services/dormitory_service.dart';
import '../models/dormitory.dart';
import 'dorm_detail_page.dart';

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
  void initState() {
    super.initState();
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _dormitoryService.searchDormitories(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        maxDistance: _maxDistance,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      );
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการค้นหา')),
        );
      }
    }
  }

  void _toggleFavorite(String name) {
    setState(() {
      if (_favorites.contains(name)) {
        _favorites.remove(name);
      } else {
        _favorites.add(name);
      }
    });
  }

  void _openFilterSheet() {
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
                  const Text('ตัวกรองการค้นหา', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  // Price Filter
                  Text('ราคา (ไม่เกิน ฿${tempMaxPrice.toInt()}/เดือน)', style: const TextStyle(fontWeight: FontWeight.w600)),
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
                  Text('ระยะห่างจาก ม. (ไม่เกิน ${tempMaxDistance.toStringAsFixed(1)} กม.)', style: const TextStyle(fontWeight: FontWeight.w600)),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4274E6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _maxPrice = tempMaxPrice;
                          _maxDistance = tempMaxDistance;
                        });
                        _performSearch();
                      },
                      child: const Text('ตกลง', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                  const Text(
                    'ค้นหาหอพักที่ใช่',
                    style: TextStyle(
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
                              onSubmitted: (val) {
                                _searchQuery = val;
                                _performSearch();
                              },
                              decoration: const InputDecoration(
                                hintText: 'ค้นหาชื่อหอพัก...',
                                hintStyle: TextStyle(
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
                'ผลการค้นหา (${_searchResults.length})',
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
                  ? const Center(child: Text('ไม่พบหอพักที่ตรงกับเงื่อนไข', style: TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.builder(
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
                        final isAvailable = true; // Mock availability

                        return GestureDetector(
                          onTap: () {
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
                                                '${dorm.address} • ห่าง ม. ${dorm.distanceFromUniversityKm} กม.',
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
                                                  const TextSpan(text: 'ราคา ', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                                  TextSpan(text: priceText, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                                                  const TextSpan(text: ' /เดือน', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
                                                isAvailable ? 'ว่าง' : 'เต็ม',
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
                                    child: GestureDetector(
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
