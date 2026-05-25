import 'package:flutter/material.dart';
import 'booking_detail_page.dart';
import '../models/room.dart';

class RoomTypesPage extends StatefulWidget {
  final String dormName;
  final List<Room> rooms;

  const RoomTypesPage({
    super.key,
    required this.dormName,
    required this.rooms,
  });

  @override
  State<RoomTypesPage> createState() => _RoomTypesPageState();
}

class _RoomTypesPageState extends State<RoomTypesPage> {
  int _currentIndex = 0; // Bottom Navigation Bar Index

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6366F1); // Modern violet/purple color as in design screenshot
    const textDarkColor = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Slightly darker background for contrast
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'ประเภทห้องพักที่ว่าง',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.dormName,
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.rooms.isEmpty
                ? Center(
                    child: Text(
                      'ไม่มีข้อมูลห้องพัก',
                      style: TextStyle(fontFamily: 'Kanit', color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: widget.rooms.length,
                    itemBuilder: (context, index) {
                      final room = widget.rooms[index];
                      final isAvailable = room.availableCount > 0;
                      
                      String tagText = isAvailable ? 'ว่าง ${room.availableCount} ห้อง' : 'ไม่ว่าง';
                      Color tagColor = isAvailable ? const Color(0xFF10B981) : Colors.grey.shade600;
                      Color tagBgColor = isAvailable ? const Color(0xFFECFDF5) : Colors.grey.shade200;

                      final imageUrl = room.images?.isNotEmpty == true 
                          ? room.images!.first.url 
                          : 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?q=80&w=600';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: _buildAvailableRoomCard(
                          context: context,
                          imageUrl: imageUrl,
                          title: room.roomType,
                          price: '฿${room.price.toStringAsFixed(0)}',
                          isAvailable: isAvailable,
                          tagText: tagText,
                          tagColor: tagColor,
                          tagBgColor: tagBgColor,
                          floorText: room.roomNumber,
                          amenities: room.facilities.isNotEmpty ? room.facilities : ['ไม่มีข้อมูลสิ่งอำนวยความสะดวก'],
                          amenityIcons: List.generate(room.facilities.isNotEmpty ? room.facilities.length : 1, (index) => Icons.check_circle_outline_rounded),
                          onSelect: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetailPage(
                                  dormName: widget.dormName,
                                  roomType: room.roomType,
                                  price: '฿${room.price.toStringAsFixed(0)}',
                                  imageUrl: imageUrl,
                                  roomId: room.id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),

          // Bottom Navigation Bar (Matches user design bottom navbar)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                // Pop back to Homepage to switch tabs
                Navigator.of(context)
                  ..pop() // Pop RoomTypesPage
                  ..pop(index); // Pop DormDetailPage with index
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
                    child: Icon(Icons.person_rounded, size: 24),
                  ),
                  label: 'โปรไฟล์',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builder for Room Card as in the design
  Widget _buildAvailableRoomCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String price,
    required bool isAvailable,
    required String tagText,
    required Color tagColor,
    required Color tagBgColor,
    required String floorText,
    required List<String> amenities,
    required List<IconData> amenityIcons,
    required VoidCallback onSelect,
  }) {
    const primaryColor = Color(0xFF6366F1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Part: Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Container(
                  height: 240,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image, size: 60, color: Colors.black26),
                    ),
                  ),
                ),
              ),
              
              // Dark Tint Overlay if full
              if (!isAvailable)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                        ),
                        child: const Text(
                          'เต็มแล้ว',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Bottom Part: Detail Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          'ต่อเดือน',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Status Tag & Floor Text
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tagText,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          color: tagColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'เลขห้อง $floorText',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Bullet List of Room details
                Column(
                  children: List.generate(amenities.length, (idx) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          Icon(amenityIcons[idx], size: 18, color: Colors.grey.shade500),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              amenities[idx],
                              style: const TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 13.5,
                                color: Color(0xFF4B5563),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAvailable ? primaryColor : Colors.grey.shade100,
                      foregroundColor: isAvailable ? Colors.white : Colors.grey.shade400,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: isAvailable ? onSelect : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isAvailable ? 'เลือกห้องนี้' : 'ห้องเต็ม',
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isAvailable) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
