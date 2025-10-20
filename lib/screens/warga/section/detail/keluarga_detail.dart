import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/keluarga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

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
              _buildDetailField("Nama Keluarga:", keluarga.familyName),

              // Head of family
              _buildDetailField("Kepala Keluarga:", keluarga.headOfFamily),

              // Current house
              _buildDetailField("Rumah Saat Ini:", keluarga.address),

              // Ownership status
              _buildDetailField("Status Kepemilikan:", keluarga.ownershipStatus),

              // Family status
              _buildStatusField("Status Keluarga:", keluarga.status, keluarga.statusColor),

              // Family members
              const SizedBox(height: 16),
              const Text(
                "Anggota Keluarga:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),

              // List of family members
              ...keluarga.members.map((member) => _buildFamilyMemberCard(member)).toList(),

              const SizedBox(height: 24),
              // Back button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Kembali'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusField(String label, String value, MaterialColor color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(FamilyMember member) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            member.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "NIK: ${member.nik}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Peran: ${member.role}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Jenis Kelamin: ${member.gender}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tanggal Lahir: ${member.birthDate}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            member.status,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}