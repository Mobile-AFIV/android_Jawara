import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/family_member_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';

class KeluargaDetail extends StatefulWidget {
  final String? keluargaId;
  final Map<String, dynamic>? keluargaData;

  const KeluargaDetail({
    super.key,
    this.keluargaId,
    this.keluargaData,
  });

  @override
  State<KeluargaDetail> createState() => _KeluargaDetailState();
}

class _KeluargaDetailState extends State<KeluargaDetail> {
  Map<String, dynamic> keluarga = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Load data from Firebase using keluargaId
    if (widget.keluargaData != null) {
      setState(() {
        keluarga = widget.keluargaData!;
        _isLoading = false;
      });
    } else {
      // TODO: Fetch from Firebase using widget.keluargaId
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Keluarga"),
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
                      "Detail Keluarga",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Family name
                    DetailField(
                        label: "Nama Keluarga:",
                        value: keluarga['familyName'] ?? ''),

                    // Head of family
                    DetailField(
                        label: "Kepala Keluarga:",
                        value: keluarga['headOfFamily'] ?? ''),

                    // Current house
                    DetailField(
                        label: "Rumah Saat Ini:",
                        value: keluarga['address'] ?? ''),

                    // Ownership status
                    DetailField(
                        label: "Status Kepemilikan:",
                        value: keluarga['ownershipStatus'] ?? ''),

                    // Family status
                    StatusField(
                      label: "Status Keluarga:",
                      value: keluarga['status'] ?? 'Aktif',
                      color: (keluarga['status'] ?? 'Aktif') == 'Aktif'
                          ? Colors.green
                          : Colors.red,
                    ),

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

                    // List of family members
                    if (keluarga['members'] != null &&
                        (keluarga['members'] as List).isNotEmpty)
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
                          itemCount: (keluarga['members'] as List).length,
                          itemBuilder: (context, index) {
                            final member = (keluarga['members'] as List)[index];
                            return FamilyMemberCard(member: member);
                          },
                        ),
                      )
                    else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Belum ada data anggota keluarga'),
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
