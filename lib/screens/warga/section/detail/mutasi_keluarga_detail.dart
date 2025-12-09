import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';

class MutasiKeluargaDetail extends StatefulWidget {
  final String? mutasiId;
  final Map<String, dynamic>? mutasiData;

  const MutasiKeluargaDetail({
    super.key,
    this.mutasiId,
    this.mutasiData,
  });

  @override
  State<MutasiKeluargaDetail> createState() => _MutasiKeluargaDetailState();
}

class _MutasiKeluargaDetailState extends State<MutasiKeluargaDetail> {
  Map<String, dynamic> mutasi = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Load data from Firebase using mutasiId
    if (widget.mutasiData != null) {
      setState(() {
        mutasi = widget.mutasiData!;
        _isLoading = false;
      });
    } else {
      // TODO: Fetch from Firebase using widget.mutasiId
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Mutasi"),
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
                      "Detail Mutasi Warga",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Family name
                    DetailField(
                        label: "Keluarga:", value: mutasi['familyName'] ?? ''),

                    // Old address
                    DetailField(
                        label: "Alamat Lama:",
                        value: mutasi['oldAddress'] ?? ''),

                    // New address
                    DetailField(
                        label: "Alamat Baru:",
                        value: (mutasi['newAddress'] ?? '').isEmpty
                            ? "-"
                            : mutasi['newAddress']),

                    // Mutation date
                    DetailField(
                        label: "Tanggal Mutasi:", value: mutasi['date'] ?? ''),

                    // Mutation type
                    DetailField(
                      label: "Jenis Mutasi:",
                      value: mutasi['mutationType'] ?? '',
                      textColor: (mutasi['mutationType'] ?? '')
                              .toLowerCase()
                              .contains('masuk')
                          ? Colors.green
                          : Colors.orange,
                    ),

                    // Reason
                    DetailField(
                        label: "Alasan:", value: mutasi['reason'] ?? ''),

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
