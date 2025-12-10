import 'package:flutter/material.dart';
import '../../../models/pesanWarga.dart';
import '../../../services/pesanWarga_service.dart';

// ==== Status Chip ====
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ==== Expandable Card ====
class ExpandableKegiatanCard extends StatefulWidget {
  final PesanWargaModel data;
  final Color statusColor;

  const ExpandableKegiatanCard({
    super.key,
    required this.data,
    required this.statusColor,
  });

  @override
  State<ExpandableKegiatanCard> createState() => _ExpandableKegiatanCardState();
}

class _ExpandableKegiatanCardState extends State<ExpandableKegiatanCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _arrowAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: toggleExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // INFO UTAMA
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.namaWarga,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data.isiPesan.length > 50
                              ? widget.data.isiPesan.substring(0, 50) + "..."
                              : widget.data.isiPesan,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  StatusChip(label: "Pesan", color: widget.statusColor),
                  const SizedBox(width: 8),

                  RotationTransition(
                    turns: _arrowAnimation,
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),

          // ==== EXPANDED CONTENT ====
          SizeTransition(
            sizeFactor: _fadeAnimation,
            axisAlignment: 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.namaWarga,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.data.isiPesan,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==== HALAMAN UTAMA ====
class PesanWargaSection extends StatelessWidget {
  const PesanWargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pesanService = PesanWargaService();

    return Scaffold(
      appBar: AppBar(title: const Text("Pesan Warga")),
      body: StreamBuilder<List<PesanWargaModel>>(
        stream: pesanService.getPesanWarga(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada pesan warga"));
          }

          final data = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              return ExpandableKegiatanCard(
                data: data[i],
                statusColor: Colors.green,
              );
            },
          );
        },
      ),
    );
  }
}
