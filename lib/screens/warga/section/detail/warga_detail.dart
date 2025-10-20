import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/warga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class WargaDetail extends StatefulWidget {
  final int wargaIndex;
  final String? name; // Add name parameter for better lookup
  final Map<String, dynamic>? wargaData; // Support for direct data passing

  const WargaDetail({
    super.key,
    required this.wargaIndex,
    this.name,
    this.wargaData,
  });

  @override
  State<WargaDetail> createState() => _WargaDetailState();
}

class _WargaDetailState extends State<WargaDetail> {
  late WargaModel warga;

  @override
  void initState() {
    super.initState();

    // If direct data is provided, create a WargaModel from it
    if (widget.wargaData != null) {
      warga = _createWargaFromMap(widget.wargaData!);
      return;
    }

    // Try to find by name if provided
    if (widget.name != null && widget.name!.isNotEmpty) {
      final matchByName = WargaDummy.dummyData.where(
              (w) => w.name == widget.name
      ).toList();

      if (matchByName.isNotEmpty) {
        warga = matchByName.first;
        return;
      }
    }

    // Fall back to index-based lookup
    warga = widget.wargaIndex >= 0 && widget.wargaIndex < WargaDummy.dummyData.length
        ? WargaDummy.dummyData[widget.wargaIndex]
        : WargaDummy.dummyData.last; // Use the example data
  }

  // Helper method to create a WargaModel from a Map
  WargaModel _createWargaFromMap(Map<String, dynamic> data) {
    return WargaModel(
      name: data['name'] ?? '',
      nik: data['nik'] ?? '',
      family: data['family'] ?? '',
      gender: data['gender'] ?? '',
      domicileStatus: data['domicileStatus'] ?? 'Aktif',
      lifeStatus: data['lifeStatus'] ?? 'Hidup',
      birthPlace: data['birthPlace'] ?? '',
      birthDate: data['birthDate'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      religion: data['religion'] ?? '',
      bloodType: data['bloodType'] ?? '',
      education: data['education'] ?? '',
      job: data['job'] ?? '',
      familyRole: data['familyRole'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Warga"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Warga",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Full name
              _buildDetailField("Nama Lengkap:", warga.name),

              // Birth place and date
              _buildDetailField("Tempat, Tanggal Lahir:", "${warga.birthPlace}, ${warga.birthDate}"),

              // Phone number
              _buildDetailField("Nomor telepon:", warga.phoneNumber),

              // Gender
              _buildDetailField("Jenis Kelamin:", warga.gender),

              // Religion
              _buildDetailField("Agama:", warga.religion),

              // Blood type
              _buildDetailField("Golongan Darah:", warga.bloodType),

              // Education
              _buildDetailField("Pendidikan Terakhir:", warga.education),

              // Job
              _buildDetailField("Pekerjaan:", warga.job),

              // Family role
              _buildDetailField("Peran dalam Keluarga:", warga.familyRole),

              // Domicile status
              _buildDetailField("Status Penduduk:", warga.domicileStatus),

              // Family name
              _buildDetailField("Keluarga:", warga.family),

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
      padding: const EdgeInsets.only(bottom: 16.0),
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
}