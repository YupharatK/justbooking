import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../models/review.dart';
import '../models/room.dart';
import 'room_types_page.dart';
import '../models/dormitory.dart';
import '../utils/distance_calculator.dart';
import '../services/dormitory_service.dart';
import 'chat_screen.dart';
import '../wellcome/login.dart';
import '../core/localization/localization_extension.dart';
import '../core/localization/mapper.dart';

/// หน้าแสดงรายละเอียดแบบเจาะลึกของหอพัก 1 แห่ง รวมถึงรายการห้องพัก สิ่งอำนวยความสะดวก และรีวิว

class DormDetailPage extends StatefulWidget {
  final int dormId;
  final bool isGuest;

  const DormDetailPage({
    super.key,
    required this.dormId,
    this.isGuest = false,
  });

  @override
  State<DormDetailPage> createState() => _DormDetailPageState();
}

class _DormDetailPageState extends State<DormDetailPage> {
  final DormitoryService _dormitoryService = DormitoryService();
  bool _isFavorite = false;
  int _currentIndex = 0; // Current index for BottomNavigationBar
  
  late Future<Dormitory> _dormFuture;

  void _loadDormDetail() {
        // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
      _dormFuture = _dormitoryService.getDormitoryDetail(widget.dormId);
    });
  }

  @override
    // ฟังก์ชัน initState จะถูกเรียกใช้งานเป็นสิ่งแรกสุดเมื่อเปิดหน้านี้ขึ้นมา (มักใช้สำหรับดึงข้อมูลเตรียมไว้)
void initState() {
    super.initState();
    _loadDormDetail();
  }

    // ฟังก์ชันแบบ Asynchronous สำหรับติดต่อระบบหลังบ้าน (Backend) หรือประมวลผลข้อมูล: _openMap
Future<void> _openMap(double lat, double lng) async {
    if (lat == 0.0 && lng == 0.0) {
      if (mounted) {
                // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.dormDetailMapNotFound, style: TextStyle())),
        );
      }
      return;
    }
    
    // ใช้ API นำทาง (Directions) แทนการค้นหา (Search) เพื่อใช้นำทางไปหอพัก
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw Exception('Could not launch map');
      }
    } catch (e) {
      if (mounted) {
                // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.dormDetailMapLaunchError, style: TextStyle())),
        );
      }
    }
  }

  void _openWriteReviewSheet() {
    double rating = 5.0;
    final TextEditingController commentController = TextEditingController();
    bool isSubmitting = false;

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
                      Text(context.l10n.dormDetailWriteReview, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(context.l10n.dormDetailRateDorm, style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 36,
                        ),
                        onPressed: () {
                          setModalState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Text(context.l10n.dormDetailComment, style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: context.l10n.dormDetailCommentHint,
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF4274E6)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:                     // ปุ่มกดแบบมีพื้นหลัง (ElevatedButton) เมื่อกดแล้วจะเรียกคำสั่งใน onPressed
ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4274E6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              if (commentController.text.trim().isEmpty) {
                                                                // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(context.l10n.dormDetailCommentRequired, style: TextStyle())),
                                );
                                return;
                              }
                              setModalState(() => isSubmitting = true);
                              try {
                                await _dormitoryService.createReview(widget.dormId, rating, commentController.text.trim());
                                if (mounted) {
                                  Navigator.pop(context);
                                                                    // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(context.l10n.dormDetailReviewSuccess, style: TextStyle())),
                                  );
                                  _loadDormDetail(); // Refresh data
                                }
                              } catch (e) {
                                setModalState(() => isSubmitting = false);
                                if (mounted) {
                                                                    // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(context.l10n.dormDetailReviewError, style: TextStyle())),
                                  );
                                }
                              }
                            },
                      child: isSubmitting
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(context.l10n.dormDetailSubmitReview, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
    const textDarkColor = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),

      body:       // FutureBuilder ใช้สำหรับรอให้ข้อมูลแบบ Asynchronous (เช่น การดึง API) ทำงานเสร็จก่อนถึงจะวาดหน้าจอ
FutureBuilder<Dormitory>(
        future: _dormFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.l10n.dormDetailLoadingError),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.dormDetailBack),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text(context.l10n.dormDetailNotFound));
          }

          final dorm = snapshot.data!;
          final isAvailable = dorm.rooms != null && dorm.rooms!.any((r) => r.availableCount > 0);
          final availableRoomsCount = dorm.rooms?.fold<int>(0, (sum, r) => sum + r.availableCount) ?? 0;
          final double distanceKm = DistanceCalculator.calculateDistanceInKm(dorm.latitude, dorm.longitude);
          final lowestPrice = dorm.rooms != null && dorm.rooms!.isNotEmpty 
              ? dorm.rooms!.map((r) => r.price).reduce((a, b) => a < b ? a : b)
              : 0.0;
          final imageUrl = dorm.coverImageUrl ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=600';

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Top Section - Background Image and Overlay Buttons
                        Stack(
                          children: [
                            Container(
                              height: 320,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Dark gradient overlay on image bottom
                            Container(
                              height: 320,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.2),
                                  ],
                                ),
                              ),
                            ),
                            // Back Button
                            Positioned(
                              top: 16,
                              left: 16,
                              child:                               // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.black87,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            // Favorite Button
                            Positioned(
                              top: 16,
                              right: 16,
                              child:                               // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                                onTap: () async {
                                  if (widget.isGuest) {
                                                                        // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                    return;
                                  }
                                  try {
                                    if (_isFavorite) {
                                      await _dormitoryService.removeFavorite(dorm.id);
                                    } else {
                                      await _dormitoryService.addFavorite(dorm.id);
                                    }
                                                                        // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
                                      _isFavorite = !_isFavorite;
                                    });
                                    if (mounted) {
                                                                            // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            _isFavorite
                                                ? context.l10n.dormDetailSaveSuccess
                                                : context.l10n.dormDetailUnsaveSuccess,
                                            style: const TextStyle(),
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                                                            // แสดงข้อความแจ้งเตือนป๊อปอัปเล็กๆ ที่ด้านล่างของจอ (SnackBar)
ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(context.l10n.dormDetailSaveError, style: TextStyle())),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: _isFavorite ? Colors.red : Colors.black45,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // 2. Dormitory Detail Content Card
                        Transform.translate(
                          offset: const Offset(0, -24),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                            ),
                            padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Dorm Name & Status Tag
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dorm.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: textDarkColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isAvailable ? const Color(0xFFE8F1FF) : const Color(0xFFFFEBEE),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        isAvailable ? context.l10n.searchAvailable : context.l10n.searchFull,
                                        style: TextStyle(
                                          color: isAvailable ? primaryColor : Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Rating Stars
                                Row(
                                  children: [
                                    Row(
                                      children: List.generate(5, (index) {
                                        final rating = dorm.rating ?? 0.0;
                                        return Icon(
                                          index < rating.floor()
                                              ? Icons.star_rounded
                                              : (index < rating
                                                  ? Icons.star_half_rounded
                                                  : Icons.star_border_rounded),
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '(${dorm.reviews?.length ?? 0} ${context.l10n.dormManageReviewUnit.trim()})',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Location & Available Rooms Indicators
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, color: primaryColor, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        dorm.address,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.apartment_rounded, color: primaryColor, size: 18),
                                    const SizedBox(width: 8),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(text: context.l10n.dormDetailAvailableRooms),
                                          TextSpan(
                                            text: '$availableRoomsCount ${context.l10n.addDormRoomUnit}',
                                            style: const TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(color: Color(0xFFF3F4F6)),
                                
                                // Description
                                if (dorm.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    dorm.description,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // 3. Room Types Section
                        if (dorm.rooms != null && dorm.rooms!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.dormDetailRoomTypes,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 190,
                                  child:                                   // ใช้ ListView.builder สำหรับสร้างรายการข้อมูลแบบเลื่อนได้ (Scrollable List) ซึ่งจะวาด UI ตามจำนวนข้อมูลที่มี
ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: dorm.rooms!.length,
                                    itemBuilder: (context, index) {
                                      final room = dorm.rooms![index];
                                      return Padding(
                                        padding: EdgeInsets.only(right: index == dorm.rooms!.length - 1 ? 0 : 14.0),
                                        child: _buildRoomTypeCard(
                                          dormName: dorm.name,
                                          ownerId: dorm.ownerId,
                                          rooms: dorm.rooms ?? [],
                                          imageUrl: room.images?.isNotEmpty == true 
                                              ? room.images!.first.url 
                                              : 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?q=80&w=400',
                                          title: room.roomType,
                                          subtitle: room.facilities.isNotEmpty ? room.facilities.map((f) => DataMapper.getFacilityName(context, f)).join(', ') : context.l10n.dormDetailNoData,
                                          price: room.price.toStringAsFixed(0),
                                          available: context.l10n.homeRoomsLeft(room.availableCount),
                                          availableColor: room.availableCount > 0 ? const Color(0xFF34C759) : Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),

                        // 4. Amenities Section
                        if (dorm.facilities.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.dormDetailAmenities,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3.5,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 16,
                                  ),
                                  itemCount: dorm.facilities.length,
                                  itemBuilder: (context, index) {
                                    // Use generic icon for now
                                    return _buildAmenityItem(Icons.check_circle_outline_rounded, DataMapper.getFacilityName(context, dorm.facilities[index]));
                                  },
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Rules Section
                        if (dorm.rules.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.dormDetailRules,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Text(
                                    dorm.rules,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (dorm.rules.isNotEmpty)
                          const SizedBox(height: 24),

                        // 5. Location Section (Map)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.l10n.dormDetailLocation,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textDarkColor,
                                    ),
                                  ),
                                                                    // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                                    onTap: () {
                                      _openMap(dorm.latitude, dorm.longitude);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: primaryColor.withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        context.l10n.dormDetailDirections,
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Map visual button
                                                            // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
                                onTap: () => _openMap(dorm.latitude, dorm.longitude),
                                child: Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: const Color(0xFFE8F1FF),
                                            child: const Center(
                                              child: Icon(Icons.map_rounded, color: primaryColor, size: 50),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: primaryColor.withOpacity(0.05),
                                        ),
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 8,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.location_pin,
                                              color: Colors.red,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                dorm.address,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.route_rounded, color: primaryColor, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    context.l10n.dormDetailDistanceFromUni(distanceKm.toStringAsFixed(1)),
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 6. Reviews Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.l10n.dormDetailTenantReviews,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textDarkColor,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: widget.isGuest
                                        ? () {
                                                                                        // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                          }
                                        : _openWriteReviewSheet,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      context.l10n.dormDetailWriteReview,
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (dorm.reviews == null || dorm.reviews!.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Center(
                                    child: Text(
                                      context.l10n.dormDetailNoReviews,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  ),
                                )
                              else
                                                                // ใช้ ListView.builder สำหรับสร้างรายการข้อมูลแบบเลื่อนได้ (Scrollable List) ซึ่งจะวาด UI ตามจำนวนข้อมูลที่มี
ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: dorm.reviews!.length > 3 ? 3 : dorm.reviews!.length,
                                  itemBuilder: (context, index) {
                                    final review = dorm.reviews![index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.grey.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor: primaryColor.withOpacity(0.1),
                                                    child: Text(
                                                      (review.user?.firstName ?? 'U').substring(0, 1).toUpperCase(),
                                                      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '${review.user?.firstName ?? context.l10n.dormManageUserUnknown} ${review.user?.lastName ?? ''}',
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    review.rating.toStringAsFixed(1),
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            review.comment,
                                            style: const TextStyle(color: Colors.black87),
                                          ),
                                          if (review.ownerReply != null && review.ownerReply!.isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.grey.shade200),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    context.l10n.dormDetailOwnerReply,
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primaryColor),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    review.ownerReply!,
                                                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // 6. Bottom Action Bar (Dorm Booking Action Bar)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.dormDetailStartingPrice,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                lowestPrice > 0 ? lowestPrice.toStringAsFixed(0) : '-',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.dormDetailCurrency,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.chat_bubble_rounded, color: primaryColor, size: 22),
                              tooltip: context.l10n.dormDetailChatTooltip,
                              onPressed: () {
                                if (widget.isGuest) {
                                                                    // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                  return;
                                }
                                                                // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      dormId: widget.dormId,
                                      dormName: dorm.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                                                    // ปุ่มกดแบบมีพื้นหลัง (ElevatedButton) เมื่อกดแล้วจะเรียกคำสั่งใน onPressed
ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            ),
                            onPressed: () {
                                                            // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RoomTypesPage(
                                    dormName: dorm.name,
                                    rooms: dorm.rooms ?? [],
                                    ownerId: dorm.ownerId,
                                    isGuest: widget.isGuest,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              context.l10n.dormDetailViewRooms,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 7. Bottom Navigation Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade100, width: 1),
                    ),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      if (widget.isGuest && index != 0) {
                                                // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                        return;
                      }
                                            // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
                        _currentIndex = index;
                      });
                      Navigator.pop(context, index);
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                    selectedItemColor: primaryColor,
                    unselectedItemColor: Colors.grey.shade400,
                    selectedFontSize: 11,
                    unselectedFontSize: 11,
                    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(),
                    elevation: 0,
                    items: [
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Icon(Icons.home_rounded, size: 24),
                        ),
                        label: context.l10n.homeTab,
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Icon(Icons.assignment_turned_in_rounded, size: 24),
                        ),
                        label: context.l10n.bookingTab,
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Icon(Icons.chat_bubble_outline_rounded, size: 24),
                        ),
                        label: context.l10n.messageTab,
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Icon(Icons.notifications_rounded, size: 24),
                        ),
                        label: context.l10n.notificationTab,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  // Helper builder for Room Type Card
  Widget _buildRoomTypeCard({
    required String dormName,
    int? ownerId,
    required List<Room> rooms,
    required String imageUrl,
    required String title,
    required String subtitle,
    required String price,
    required String available,
    required Color availableColor,
  }) {
    const primaryColor = Color(0xFF4274E6);

    return     // GestureDetector ใช้ครอบ Widget อื่นๆ เพื่อให้สามารถรับการกด (Tap) หรือสัมผัสจากผู้ใช้ได้
GestureDetector(
      onTap: () {
                // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoomTypesPage(
              dormName: dormName,
              rooms: rooms,
              ownerId: ownerId,
              isGuest: widget.isGuest,
            ),
          ),
        );
      },
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                imageUrl,
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 90,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image, color: Colors.black26),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: availableColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          available,
                          style: TextStyle(
                            color: availableColor,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        context.l10n.dormDetailCurrencyPerMonth,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 9,
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

  Widget _buildAmenityItem(IconData icon, String label) {
    const primaryColor = Color(0xFF4274E6);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
