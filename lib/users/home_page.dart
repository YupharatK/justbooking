import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'search_page.dart';
import 'dorm_detail_page.dart';
import 'profile_page.dart';
import 'edit_profile_page.dart';
import 'favorites_page.dart';
import 'message_page.dart';
import '../services/dormitory_service.dart';
import '../models/dormitory.dart';
import 'booking_history_tab.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;

  // Stateful profile details (defaults to Nopparat Wongthewa matching the mockup design)
  String _profileName = 'นพรัตน์ วงศ์เทวา';
  final String _profileEmail = 'nopparat.w@gmail.com';
  String _profilePhone = '081-234-5678';
  String _profileAddress = '123/45 ซอยสุขุมวิท 23 แขวงคลองเตยเหนือ เขตวัฒนา กรุงเทพมหานคร 10110';
  String _profileImageUrl = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=300';

  // Simulate favorite state for specific dorms
  final Set<String> _favorites = {'หอพักใจ', 'เดอะ การ์เดน โฮม'};

  final DormitoryService _dormitoryService = DormitoryService();
  bool _isLoadingDorms = true;
  List<Dormitory> _dorms = [];

  @override
  void initState() {
    super.initState();
    _fetchDorms();
  }

  Future<void> _fetchDorms() async {
    try {
      final dorms = await _dormitoryService.searchDormitories();
      if (mounted) {
        setState(() {
          _dorms = dorms;
          _isLoadingDorms = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDorms = false;
        });
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      _buildHomeTab(),
      const BookingHistoryTab(),
      const MessagePage(),
      _buildNotificationTab(),
    ];

    const primaryColor = Color(0xFF4274E6);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: tabs,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kanit'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Kanit'),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home_rounded, size: 24),
              ),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.assignment_turned_in_rounded, size: 24),
              ),
              label: 'การจอง',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.chat_bubble_outline_rounded, size: 24),
              ),
              label: 'ข้อความ',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.notifications_rounded, size: 24),
              ),
              label: 'แจ้งเตือน',
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: HOME ---
  Widget _buildHomeTab() {
    const primaryColor = Color(0xFF4274E6);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (DormFinder Logo & Profile Avatar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: primaryColor,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'DormFinder',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserProfilePage(),
                      ),
                    ).then((value) {
                      if (value is Map<String, dynamic>) {
                        setState(() {
                          _profileName = value['name'] ?? _profileName;
                          _profilePhone = value['phone'] ?? _profilePhone;
                          _profileAddress = value['address'] ?? _profileAddress;
                          _profileImageUrl = value['imageUrl'] ?? _profileImageUrl;
                          if (value['index'] is int) {
                            _currentIndex = value['index'];
                          }
                        });
                      } else if (value is int) {
                        setState(() {
                          _currentIndex = value;
                        });
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        backgroundImage: NetworkImage(_profileImageUrl),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF34C759), // Online green
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Search & Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchDormPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3FA),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Colors.black38, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'ค้นหาหอพัก, ทำเล, หรือราคา..',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.black12,
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchDormPage()),
                        );
                      },
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.black45,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 3. ค้นหาล่าสุด (Recent Searches) Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ค้นหาล่าสุด',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: _isLoadingDorms 
              ? const Center(child: CircularProgressIndicator())
              : _dorms.isEmpty 
                  ? const Center(child: Text('ไม่พบข้อมูลหอพัก'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _dorms.length > 5 ? 5 : _dorms.length,
                      itemBuilder: (context, index) {
                        final dorm = _dorms[index];
                        return _buildRecentSearchCard(
                          dorm: dorm,
                          imageUrl: dorm.coverImageUrl ?? 'https://images.unsplash.com/photo-1554995207-c18c203602cb?q=80&w=400',
                          name: dorm.name,
                          isAvailable: true, // Mock availability for now
                          location: dorm.address,
                          price: dorm.rooms != null && dorm.rooms!.isNotEmpty 
                              ? '฿${dorm.rooms!.first.price.toStringAsFixed(0)}' 
                              : '฿3,000',
                        );
                      },
                    ),
          ),

          const SizedBox(height: 28),

          // 4. หอพักที่เป็นที่นิยม (Popular Dorms) Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'หอพักที่เป็นที่นิยม',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 360,
            child: _isLoadingDorms 
              ? const Center(child: CircularProgressIndicator())
              : _dorms.isEmpty 
                  ? const Center(child: Text('ไม่พบข้อมูลหอพัก'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _dorms.length > 3 ? 3 : _dorms.length, // Show up to 3 popular dorms
                      itemBuilder: (context, index) {
                        // For variety, let's reverse the list or use an offset
                        final dormIndex = (_dorms.length - 1) - index;
                        final dorm = _dorms[dormIndex >= 0 ? dormIndex : index];
                        return _buildPopularDormCard(
                          dorm: dorm,
                          imageUrl: dorm.coverImageUrl ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=400',
                          name: dorm.name,
                          location: dorm.address,
                          price: dorm.rooms != null && dorm.rooms!.isNotEmpty 
                              ? '฿${dorm.rooms!.first.price.toStringAsFixed(0)}/เดือน' 
                              : '฿3,500/เดือน',
                          roomsLeft: 3, // Mock rooms left
                        );
                      },
                    ),
          ),

          const SizedBox(height: 28),

          // 5. แนะนำเพิ่มเติม (Recommended) Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'แนะนำเพิ่มเติม',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _isLoadingDorms
            ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: _dorms.length,
                itemBuilder: (context, index) {
                  final dorm = _dorms[index];
                  return _buildRecommendedItem(
                    dorm: dorm,
                    imageUrl: dorm.coverImageUrl ?? 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=400',
                    name: dorm.name,
                    location: '${dorm.address} • ${dorm.distanceFromUniversityKm} กม. จาก ม.',
                    price: dorm.rooms != null && dorm.rooms!.isNotEmpty 
                              ? '฿${dorm.rooms!.first.price.toStringAsFixed(0)}' 
                              : '฿3,200',
                    tag: dorm.facilities.isNotEmpty ? dorm.facilities.first : 'แอร์/พัดลม',
                    isFull: false, // Mock
                  );
                },
              ),
        ],
      ),
    );
  }

  // --- RECENT SEARCH CARD WIDGET ---
  Widget _buildRecentSearchCard({
    required Dormitory dorm,
    required String imageUrl,
    required String name,
    required bool isAvailable,
    required String location,
    required String price,
  }) {
    final isFav = _favorites.contains(name);
    const primaryColor = Color(0xFF4274E6);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DormDetailPage(
              dormId: dorm.id,
            ),
          ),
        ).then((value) {
          if (value is int) {
            setState(() {
              _currentIndex = value;
            });
          }
        });
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image, color: Colors.black26, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(name),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                        color: isFav ? Colors.red : Colors.black45,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F1FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'ว่าง',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const Text(
                        '/เดือน',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- POPULAR DORM CARD WIDGET ---
  Widget _buildPopularDormCard({
    required Dormitory dorm,
    required String imageUrl,
    required String name,
    required String location,
    required String price,
    required int roomsLeft,
  }) {
    final isFav = _favorites.contains(name);
    const primaryColor = Color(0xFF4274E6);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DormDetailPage(
              dormId: dorm.id,
            ),
          ),
        ).then((value) {
          if (value is int) {
            setState(() {
              _currentIndex = value;
            });
          }
        });
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade100,
                  child: const Center(child: Icon(Icons.image, color: Colors.black26, size: 50)),
                ),
              ),
              // Black gradient cover
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            price,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            roomsLeft > 0 ? 'ว่าง $roomsLeft ห้อง' : 'เต็มแล้ว',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(name),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                      color: isFav ? Colors.red : Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- RECOMMENDED ITEM WIDGET ---
  Widget _buildRecommendedItem({
    required Dormitory dorm,
    required String imageUrl,
    required String name,
    required String location,
    required String price,
    required String tag,
    required bool isFull,
  }) {
    final isFav = _favorites.contains(name);
    const primaryColor = Color(0xFF4274E6);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DormDetailPage(
              dormId: dorm.id,
            ),
          ),
        ).then((value) {
          if (value is int) {
            setState(() {
              _currentIndex = value;
            });
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 90,
                      width: 90,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image, color: Colors.black26, size: 30),
                    ),
                  ),
                ),
                if (isFull)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'เต็มแล้ว',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _toggleFavorite(name),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          color: isFav ? Colors.red : Colors.black38,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            '/เดือน',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black.withOpacity(0.04)),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
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
    );
  }

  // --- TAB 3: NOTIFICATIONS ---
  Widget _buildNotificationTab() {
    const primaryColor = Color(0xFF4274E6);

    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'การจองหอพักสำเร็จ',
        'desc': 'ยินดีด้วย! คำขอจอง หอพักใจ ของคุณได้รับการตอบรับจากเจ้าของหอพักเรียบร้อยแล้ว กรุณาเข้าตรวจสอบเพื่อทำสัญญาถัดไป',
        'time': '2 ชั่วโมงที่แล้ว',
        'icon': Icons.check_circle_rounded,
        'iconColor': const Color(0xFF34C759),
        'isRead': false,
      },
      {
        'title': 'แจ้งยอดค้างชำระเงินมัดจำ',
        'desc': 'กรุณาชำระเงินค่ามัดจำห้องพัก 302 เดอะ การ์เดน โฮม จำนวน ฿3,500 ภายในวันที่ 24 พฤษภาคม 2026 เพื่อสิทธิในการเข้าพัก',
        'time': '1 วันที่แล้ว',
        'icon': Icons.warning_rounded,
        'iconColor': const Color(0xFFFF9500),
        'isRead': false,
      },
      {
        'title': 'ยินดีต้อนรับสู่ DormFinder',
        'desc': 'ยินดีต้อนรับเข้าใช้งาน Just Booking! ค้นหาและจองห้องพักในฝันของคุณได้ง่ายๆ ในสัมผัสเดียว',
        'time': '3 วันที่แล้ว',
        'icon': Icons.celebration_rounded,
        'iconColor': primaryColor,
        'isRead': true,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'การแจ้งเตือน',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('อ่านทั้งหมด', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: notif['isRead'] ? Colors.transparent : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: notif['isRead']
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                    border: Border.all(
                      color: notif['isRead'] ? Colors.grey.shade200 : primaryColor.withOpacity(0.06),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (notif['iconColor'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          notif['icon'] as IconData,
                          color: notif['iconColor'] as Color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notif['title'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: notif['isRead'] ? FontWeight.bold : FontWeight.w800,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ),
                                Text(
                                  notif['time'] as String,
                                  style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notif['desc'] as String,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: ACCOUNT ---
  Widget _buildAccountTab() {
    const primaryColor = Color(0xFF4274E6);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'โปรไฟล์ของฉัน',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 24),
          // User Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserProfilePage(),
                ),
              ).then((value) {
                if (value is Map<String, dynamic>) {
                  setState(() {
                    _profileName = value['name'] ?? _profileName;
                    _profilePhone = value['phone'] ?? _profilePhone;
                    _profileAddress = value['address'] ?? _profileAddress;
                    _profileImageUrl = value['imageUrl'] ?? _profileImageUrl;
                    if (value['index'] is int) {
                      _currentIndex = value['index'];
                    }
                  });
                } else if (value is int) {
                  setState(() {
                    _currentIndex = value;
                  });
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, Color(0xFF5A84ED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(_profileImageUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _profileName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _profileEmail,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'ผู้ใช้งานทั่วไป',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'การตั้งค่าทั่วไป',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          _buildAccountMenuOption(
            icon: Icons.person_outline_rounded,
            title: 'แก้ไขข้อมูลโปรไฟล์',
            subtitle: 'เปลี่ยนรูปภาพ, ชื่อ, และข้อมูลโทรศัพท์',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    currentName: _profileName,
                    currentPhone: _profilePhone,
                    currentAddress: _profileAddress,
                    imageUrl: _profileImageUrl,
                  ),
                ),
              ).then((value) {
                if (value is Map<String, String>) {
                  setState(() {
                    _profileName = value['name']!;
                    _profilePhone = value['phone']!;
                    _profileAddress = value['address']!;
                    _profileImageUrl = value['imageUrl']!;
                  });
                }
              });
            },
          ),
          _buildAccountMenuOption(
            icon: Icons.favorite_border_rounded,
            title: 'หอพักที่บันทึกไว้',
            subtitle: 'รายการหอพักที่คุณชอบและกดไลก์ไว้',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
          _buildAccountMenuOption(
            icon: Icons.vpn_key_outlined,
            title: 'เปลี่ยนรหัสผ่าน',
            subtitle: 'จัดการความปลอดภัยและการยืนยันตัวตน',
            onTap: () {},
          ),
          _buildAccountMenuOption(
            icon: Icons.help_outline_rounded,
            title: 'ศูนย์ช่วยเหลือและติดต่อเรา',
            subtitle: 'แจ้งเรื่องพบปัญหาหรือขอรับคำแนะนำ',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          // Logout Option
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.red.shade100),
            ),
            child: ListTile(
              onTap: () async {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                navigator.popUntil((route) => route.isFirst);
              },
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, color: Colors.red.shade600, size: 20),
              ),
              title: Text(
                'ออกจากระบบ',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.02)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFF2F5FD),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_outline_rounded, color: Color(0xFF4274E6), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 11,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
      ),
    );
  }
}
