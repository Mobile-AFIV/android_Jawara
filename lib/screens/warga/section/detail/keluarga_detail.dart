import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/keluarga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/family_member_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';

class KeluargaDetail extends StatefulWidget {
  final int keluargaIndex;

  const KeluargaDetail({
    super.key,
    required this.keluargaIndex,
  });

  @override
  State<KeluargaDetail> createState() => _KeluargaDetailState();
}

class _KeluargaDetailState extends State<KeluargaDetail> {
  late KeluargaModel keluarga;

  @override
  void initState() {
    super.initState();
    // Get data based on index, default to the example family if out of range
    keluarga = widget.keluargaIndex >= 0 && widget.keluargaIndex < KeluargaDummy.dummyData.length
        ? KeluargaDummy.dummyData[widget.keluargaIndex]
        : KeluargaDummy.dummyData.last; // Use the example family
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Keluarga"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Keluarga",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Family name
              DetailField(label: "Nama Keluarga:", value: keluarga.familyName),

              // Head of family
              DetailField(label: "Kepala Keluarga:", value: keluarga.headOfFamily),

              // Current house
              DetailField(label: "Rumah Saat Ini:", value: keluarga.address),

              // Ownership status
              DetailField(label: "Status Kepemilikan:", value: keluarga.ownershipStatus),

              // Family status
              StatusField(label: "Status Keluarga:", value: keluarga.status, color: keluarga.statusColor),

              // Family members
              const SizedBox(height: 24),
              const Text(
                "Anggota Keluarga:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // List of family members (matching ResidentHistoryItem style)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: keluarga.members.length,
                  itemBuilder: (context, index) {
                    return FamilyMemberCard(member: keluarga.members[index]);
                  },
                ),
              ),

              const SizedBox(height: 24),
              // Back button
              DetailBackButton(
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}