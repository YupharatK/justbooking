import 'package:flutter/material.dart';
import 'dorm_detail_page.dart';
import '../models/dormitory.dart';
import '../services/dormitory_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final DormitoryService _dormitoryService = DormitoryService();
  late Future<List<Dormitory>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoritesFuture = _dormitoryService.getFavorites();
    });
  }

  Future<void> _removeFavorite(int dormId) async {
    try {
      await _dormitoryService.removeFavorite(dormId);
      _loadFavorites();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลบออกจากรายการโปรดแล้ว', style: TextStyle(fontFamily: 'Kanit'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการลบรายการโปรด', style: TextStyle(fontFamily: 'Kanit'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F6DE3);
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
          'รายการโปรด',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: FutureBuilder<List<Dormitory>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล', style: TextStyle(fontFamily: 'Kanit')));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'ยังไม่มีหอพักที่ถูกใจ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          final favorites = snapshot.data!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'หอพักที่คุณบันทึกไว้เพื่อการตัดสินใจที่ง่ายขึ้น',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final dorm = favorites[index];
                    final imageUrl = dorm.coverImageUrl ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=600';
                    final lowestPrice = dorm.rooms != null && dorm.rooms!.isNotEmpty 
                        ? dorm.rooms!.map((r) => r.price).reduce((a, b) => a < b ? a : b)
                        : 3000.0; // Fallback
                    final isAvailable = dorm.rooms != null && dorm.rooms!.any((r) => r.availableCount > 0);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DormDetailPage(
                                dormId: dorm.id,
                              ),
                            ),
                          ).then((_) => _loadFavorites()); // Reload in case they unfavorited in detail page
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Section
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    child: Image.network(
                                      imageUrl,
                                      height: 220,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 220,
                                        color: Colors.grey.shade100,
                                        child: const Icon(Icons.image, color: Colors.black26),
                                      ),
                                    ),
                                  ),
                                  // Favorite Icon (Removable)
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: () => _removeFavorite(dorm.id),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.favorite_rounded, color: Colors.red, size: 24),
                                      ),
                                    ),
                                  ),
                                  // Badge
                                  if (isAvailable)
                                    Positioned(
                                      bottom: 16,
                                      left: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'พร้อมเข้าอยู่',
                                          style: TextStyle(
                                            fontFamily: 'Kanit',
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              // Details Section
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            dorm.name,
                                            style: const TextStyle(
                                              fontFamily: 'Kanit',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: textDarkColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded, color: Colors.orange, size: 18),
                                            const SizedBox(width: 4),
                                            Text(
                                              dorm.rating != null ? dorm.rating!.toStringAsFixed(1) : '-',
                                              style: TextStyle(
                                                fontFamily: 'Kanit',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, color: Colors.grey.shade600, size: 16),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            dorm.address,
                                            style: TextStyle(
                                              fontFamily: 'Kanit',
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Divider(color: Colors.grey.shade200, thickness: 1),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'เริ่มต้น',
                                              style: TextStyle(
                                                fontFamily: 'Kanit',
                                                fontSize: 13,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.baseline,
                                              textBaseline: TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  lowestPrice.toStringAsFixed(0),
                                                  style: const TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'บาท/เดือน',
                                                  style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 13,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            elevation: 0,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => DormDetailPage(
                                                  dormId: dorm.id,
                                                ),
                                              ),
                                            ).then((_) => _loadFavorites());
                                          },
                                          child: const Text(
                                            'ดูรายละเอียด',
                                            style: TextStyle(
                                              fontFamily: 'Kanit',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
