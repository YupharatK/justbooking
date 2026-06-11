import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/map_constants.dart';
import '../models/dormitory.dart';
import '../services/dormitory_service.dart';
import '../services/map_search_service.dart';
import 'widgets/dormitory_marker_builder.dart';
import '../users/dorm_detail_page.dart';

class DormitoryMapPage extends StatefulWidget {
  const DormitoryMapPage({super.key});

  @override
  State<DormitoryMapPage> createState() => _DormitoryMapPageState();
}

class _DormitoryMapPageState extends State<DormitoryMapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final DormitoryService _dormService = DormitoryService();
  
  List<Dormitory> _dorms = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadDorms();
  }

  Future<void> _loadDorms() async {
    try {
      final dorms = await _dormService.searchDormitories();
      setState(() {
        _dorms = dorms.where((d) => d.latitude != 0.0 && d.longitude != 0.0).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() => _isSearching = true);
    
    final LatLng? result = await MapSearchService.searchPlace(query);
    
    setState(() => _isSearching = false);

    if (result != null) {
      _mapController.move(result, 16.0);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่พบสถานที่ที่คุณค้นหา', style: TextStyle())),
        );
      }
    }
  }

  void _showDormitoryDetails(Dormitory dorm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    dorm.coverImageUrl ?? 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dorm.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ห่างจาก ม. ${dorm.distanceFromUniversityKm} กม.',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F6DE3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DormDetailPage(dormId: dorm.id)),
                  );
                },
                child: const Text('ดูรายละเอียดหอพัก', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      DormitoryMarkerBuilder.buildUniversityMarker(MapConstants.msuLocation),
    ];

    if (!_isLoading) {
      markers.addAll(_dorms.map((dorm) => DormitoryMarkerBuilder.buildDormitoryMarker(
        dorm,
        onTap: () => _showDormitoryDetails(dorm),
      )));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('แผนที่หอพัก', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: MapConstants.msuLocation,
              initialZoom: MapConstants.defaultZoom,
              cameraConstraint: CameraConstraint.contain(bounds: MapConstants.mahasarakhamBounds),
            ),
            children: [
              TileLayer(
                urlTemplate: MapConstants.osmTileUrl,
                userAgentPackageName: MapConstants.userAgent,
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          
          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ค้นหาสถานที่...',
                  hintStyle: const TextStyle(color: Colors.black38),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: _isSearching 
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black54),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onSubmitted: _performSearch,
              ),
            ),
          ),
          
          // Current Location Button (Reset to MSU)
          Positioned(
            bottom: 30,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _mapController.move(MapConstants.msuLocation, MapConstants.defaultZoom);
              },
              child: const Icon(Icons.my_location, color: Color(0xFF3F6DE3)),
            ),
          ),
        ],
      ),
    );
  }
}
