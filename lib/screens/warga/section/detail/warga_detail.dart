import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';

class WargaDetail extends StatefulWidget {
  final String? wargaId;
  final Map<String, dynamic>? wargaData;

  const WargaDetail({
    super.key,
    this.wargaId,
    this.wargaData,
  });

  @override
  State<WargaDetail> createState() => _WargaDetailState();
}

class _WargaDetailState extends State<WargaDetail> {
  Map<String, dynamic> warga = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Load data from Firebase using wargaId
    if (widget.wargaData != null) {
      setState(() {
        warga = widget.wargaData!;
        _isLoading = false;
      });
    } else {
      // TODO: Fetch from Firebase using widget.wargaId
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Warga"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    DetailField(
                        label: "Nama Lengkap:", value: warga['name'] ?? ''),

                    // Birth place and date
                    DetailField(
                        label: "Tempat, Tanggal Lahir:",
                        value:
                            "${warga['birthPlace'] ?? ''}, ${warga['birthDate'] ?? ''}"),

                    // Phone number
                    DetailField(
                        label: "Nomor telepon:",
                        value: warga['phoneNumber'] ?? ''),

                    // Gender
                    DetailField(
                        label: "Jenis Kelamin:", value: warga['gender'] ?? ''),

                    // Religion
                    DetailField(
                        label: "Agama:", value: warga['religion'] ?? ''),

                    // Blood type
                    DetailField(
                        label: "Golongan Darah:",
                        value: warga['bloodType'] ?? ''),

                    // Education
                    DetailField(
                        label: "Pendidikan Terakhir:",
                        value: warga['education'] ?? ''),

                    // Job
                    DetailField(label: "Pekerjaan:", value: warga['job'] ?? ''),

                    // Family role
                    DetailField(
                        label: "Peran dalam Keluarga:",
                        value: warga['familyRole'] ?? ''),

                    // Domicile status
                    DetailField(
                        label: "Status Penduduk:",
                        value: warga['domicileStatus'] ?? ''),

                    // Family name
                    DetailField(
                        label: "Keluarga:", value: warga['family'] ?? ''),

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
