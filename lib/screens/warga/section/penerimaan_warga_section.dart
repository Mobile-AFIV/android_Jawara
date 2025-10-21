import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/penerimaan_warga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';

class PenerimaanWargaSection extends StatefulWidget {
  const PenerimaanWargaSection({super.key});

  @override
  State<PenerimaanWargaSection> createState() => _PenerimaanWargaSectionState();
}

class _PenerimaanWargaSectionState extends State<PenerimaanWargaSection>
    with TickerProviderStateMixin {
  late List<bool> _expandedList;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  late AnimationController _scrollButtonController;
  late Animation<double> _scrollButtonAnimation;

  @override
  void initState() {
    super.initState();
    _initExpandedList();
    _initScrollButton();
    _setupScrollListener();
  }

  void _initExpandedList() {
    _expandedList = List.generate(
      PenerimaanWargaDummy.dummyData.length,
      (index) => index == 0,
    );
  }

  void _initScrollButton() {
    _scrollButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scrollButtonAnimation = CurvedAnimation(
      parent: _scrollButtonController,
      curve: Curves.easeInOut,
    );
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
        _scrollButtonController.forward();
      } else if (_scrollController.offset <= 200 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
        _scrollButtonController.reverse();
      }
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollButtonController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Penerimaan Warga"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter functionality
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() => _initExpandedList());
            },
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              itemCount: PenerimaanWargaDummy.dummyData.length,
              itemBuilder: (context, index) {
                return _buildAnimatedCard(index);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          ),
          
          // Scroll to top button
          Positioned(
            right: 16,
            bottom: 16,
            child: ScaleTransition(
              scale: _scrollButtonAnimation,
              child: FloatingActionButton.small(
                heroTag: 'scrollToTop',
                onPressed: _scrollToTop,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showIdentityPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Foto Identitas",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/placeholder.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                padding: const EdgeInsets.all(32.0),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Gambar tidak ditemukan",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          "Foto KTP/Identitas",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToDetail(int index, PenerimaanWargaModel penerimaan) async {
    final result = await context.pushNamed(
      'penerimaan_warga_detail',
      queryParameters: {
        'index': index.toString(),
        'name': penerimaan.name,
      },
    );

    if (result == true) {
      setState(() {});
    }
  }

  Widget _buildAnimatedCard(int index) {
    final penerimaan = PenerimaanWargaDummy.dummyData[index];
    bool isPending = penerimaan.registrationStatus.toLowerCase().contains('pending');

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: ExpandableSectionCard(
        title: penerimaan.name,
        statusChip: StatusChip(
          label: penerimaan.registrationStatus,
          color: penerimaan.statusColor,
          icon: _getStatusIcon(penerimaan.registrationStatus),
        ),
        isExpanded: _expandedList[index],
        onToggleExpand: () {
          setState(() {
            _expandedList[index] = !_expandedList[index];
          });
        },
        expandedContent: [
          _buildInfoRow(
            Icons.credit_card,
            "NIK",
            penerimaan.nik,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.email,
            "Email",
            penerimaan.email,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            penerimaan.gender == "Laki-laki" ? Icons.male : Icons.female,
            "Jenis Kelamin",
            penerimaan.gender,
          ),
          const SizedBox(height: 12),
          
          // Photo preview button
          _buildPhotoButton(),
          
          const SizedBox(height: 16),
          SectionActionButtons(
            showEditButton: false,
            onDetailPressed: () => _navigateToDetail(index, penerimaan),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoButton() {
    return InkWell(
      onTap: () => _showIdentityPhoto(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, size: 24, color: Colors.blue[700]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Foto Identitas",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                  Text(
                    "Tap untuk melihat foto KTP",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.blue[700]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    if (status.toLowerCase().contains('pending')) {
      return Icons.pending;
    } else if (status.toLowerCase().contains('approved') || 
               status.toLowerCase().contains('diterima')) {
      return Icons.check_circle;
    } else if (status.toLowerCase().contains('rejected') || 
               status.toLowerCase().contains('ditolak')) {
      return Icons.cancel;
    }
    return Icons.info;
  }
}