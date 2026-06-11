import 'package:flutter/material.dart';
import '../services/owner_service.dart';

class OwnerTenantsPage extends StatefulWidget {
  const OwnerTenantsPage({super.key});

  @override
  State<OwnerTenantsPage> createState() => _OwnerTenantsPageState();
}

class _OwnerTenantsPageState extends State<OwnerTenantsPage> {
  final OwnerService _ownerService = OwnerService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _tenants = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTenants();
  }

  Future<void> _fetchTenants() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final tenants = await _ownerService.getOwnerTenants();
      if (mounted) {
        setState(() {
          _tenants = tenants;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'เกิดข้อผิดพลาดในการโหลดข้อมูล: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showReviewTenantDialog(int tenantId, int dormitoryId, String tenantName) {
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
                      Text('รีวิว $tenantName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('ให้คะแนนผู้เช่า', style: TextStyle(fontWeight: FontWeight.w600)),
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
                  const Text('ความคิดเห็น (ไม่บังคับ)', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'อธิบายประสบการณ์การให้เช่าของคุณ...',
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4274E6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              setModalState(() => isSubmitting = true);
                              try {
                                await _ownerService.reviewTenant(tenantId, dormitoryId, rating, commentController.text.trim());
                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('ส่งรีวิวผู้เช่าสำเร็จ')),
                                  );
                                  _fetchTenants(); // Refresh the list
                                }
                              } catch (e) {
                                setModalState(() => isSubmitting = false);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                                  );
                                }
                              }
                            },
                      child: isSubmitting
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('ส่งรีวิว', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTenantHistoryDialog(int tenantId, String tenantName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('ประวัติการเช่าของ $tenantName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _ownerService.getTenantReviews(tenantId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                }
                final reviews = snapshot.data ?? [];
                if (reviews.isEmpty) {
                  return const Center(child: Text('ผู้เช่ารายนี้ยังไม่เคยได้รับรีวิว', style: TextStyle(color: Colors.black54)));
                }

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review['dormitory_name'] ?? 'ไม่ทราบหอพัก',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    review['rating']?.toString() ?? '0',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (review['comment'] != null && review['comment'].toString().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              review['comment'],
                              style: const TextStyle(color: Colors.black87, fontSize: 13),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            'โดย ${review['owner_first_name']} ${review['owner_last_name']} - ${review['created_at'].toString().split('T')[0]}',
                            style: const TextStyle(color: Colors.black45, fontSize: 11),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ปิด', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติผู้เช่า', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(_errorMessage!, style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchTenants,
                        child: const Text('ลองใหม่'),
                      ),
                    ],
                  ),
                )
              : _tenants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text('ยังไม่มีข้อมูลผู้เช่า', style: TextStyle(fontSize: 16, color: Colors.black54)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchTenants,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _tenants.length,
                        itemBuilder: (context, index) {
                          final tenant = _tenants[index];
                          final bool hasReviewed = (tenant['has_reviewed'] ?? 0) > 0;
                          final double avgRating = double.tryParse(tenant['average_rating']?.toString() ?? '0') ?? 0.0;
                          final int reviewCount = int.tryParse(tenant['review_count']?.toString() ?? '0') ?? 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (tenant['profile_image_url'] != null && tenant['profile_image_url'].toString().isNotEmpty)
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(tenant['profile_image_url']),
                                      )
                                    else
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.grey.shade200,
                                        child: const Icon(Icons.person, color: Colors.grey),
                                      ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${tenant['first_name']} ${tenant['last_name']}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          if (tenant['nickname'] != null && tenant['nickname'].toString().isNotEmpty)
                                            Text('ชื่อเล่น: ${tenant['nickname']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                          const SizedBox(height: 4),
                                          Text(
                                            tenant['phone'] ?? '-',
                                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (reviewCount > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              avgRating.toStringAsFixed(1),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber.shade900),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(),
                                const SizedBox(height: 8),
                                Text(
                                  'หอพัก: ${tenant['dormitory_name']}',
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'เข้าระบบล่าสุด: ${tenant['latest_booking_date']?.toString().split('T')[0] ?? '-'}',
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF4274E6),
                                          side: const BorderSide(color: Color(0xFF4274E6)),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () => _showTenantHistoryDialog(tenant['tenant_id'], tenant['first_name']),
                                        child: const Text('ดูประวัติ'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: hasReviewed ? Colors.grey.shade200 : const Color(0xFF4274E6),
                                          foregroundColor: hasReviewed ? Colors.grey.shade600 : Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: hasReviewed 
                                          ? null 
                                          : () => _showReviewTenantDialog(tenant['tenant_id'], tenant['dormitory_id'], tenant['first_name']),
                                        child: Text(hasReviewed ? 'รีวิวแล้ว' : 'ให้คะแนน'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
