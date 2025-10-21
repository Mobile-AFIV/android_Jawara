import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/warga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';
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
              DetailField(label: "Nama Lengkap:", value: warga.name),

              // Birth place and date
              DetailField(label: "Tempat, Tanggal Lahir:", value: "${warga.birthPlace}, ${warga.birthDate}"),

              // Phone number
              DetailField(label: "Nomor telepon:", value: warga.phoneNumber),

              // Gender
              DetailField(label: "Jenis Kelamin:", value: warga.gender),

              // Religion
              DetailField(label: "Agama:", value: warga.religion),

              // Blood type
              DetailField(label: "Golongan Darah:", value: warga.bloodType),

              // Education
              DetailField(label: "Pendidikan Terakhir:", value: warga.education),

              // Job
              DetailField(label: "Pekerjaan:", value: warga.job),

              // Family role
              DetailField(label: "Peran dalam Keluarga:", value: warga.familyRole),

              // Domicile status
              DetailField(label: "Status Penduduk:", value: warga.domicileStatus),

              // Family name
              DetailField(label: "Keluarga:", value: warga.family),

              const SizedBox(height: 24),
              // Back button
              DetailBackButton(
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}