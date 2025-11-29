import 'package:flutter/material.dart';

// ==== Status Chip mirip kode sebelumnya ====
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

// ==== Expandable Card mirip kode sebelumnya ====
class ExpandableKegiatanCard extends StatefulWidget {
  final String namaKegiatan;
  final String isiBroadcast;
  final Color statusColor;

  const ExpandableKegiatanCard({
    super.key,
    required this.namaKegiatan,
    required this.isiBroadcast,
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
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.namaKegiatan,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isiBroadcast.length > 50
                              ? widget.isiBroadcast.substring(0, 50) + "..."
                              : widget.isiBroadcast,
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
          SizeTransition(
            sizeFactor: _fadeAnimation,
            axisAlignment: 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(widget.isiBroadcast),
            ),
          ),
        ],
      ),
    );
  }
}

// ==== Halaman utama PesanWargaSection ====
class PesanWargaSection extends StatelessWidget {
  const PesanWargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesan Warga")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpandableKegiatanCard(
            namaKegiatan: 'Ibu Atiqa',
            isiBroadcast:
                'Halo warga, kegiatan gotong royong akan dilaksanakan pada Minggu pukul 07:00 WIB...',
            statusColor: Colors.green,
          ),
          SizedBox(height: 12),
          ExpandableKegiatanCard(
            namaKegiatan: 'Pak JOKO',
            isiBroadcast:
                'Rapat warga wajib dihadiri seluruh kepala keluarga pada hari Sabtu...',
            statusColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
