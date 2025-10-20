import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/mutasi_keluarga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class MutasiKeluargaDetail extends StatefulWidget {
  final int mutasiIndex;

  const MutasiKeluargaDetail({
    super.key,
    required this.mutasiIndex,
  });

  @override
  State<MutasiKeluargaDetail> createState() => _MutasiKeluargaDetailState();
}

class _MutasiKeluargaDetailState extends State<MutasiKeluargaDetail> {
  late MutasiKeluargaModel mutasi;

  @override
  void initState() {
    super.initState();
    // Get data based on index, default to the example data if out of range
    mutasi = widget.mutasiIndex >= 0 && widget.mutasiIndex < MutasiKeluargaDummy.dummyData.length
        ? MutasiKeluargaDummy.dummyData[widget.mutasiIndex]
        : MutasiKeluargaDummy.dummyData.last; // Use the example data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Mutasi"),
      ),
      body: SingleChildScrollView(
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
              _buildDetailField("Keluarga:", mutasi.familyName),

              // Old address
              _buildDetailField("Alamat Lama:", mutasi.oldAddress),

              // New address
              _buildDetailField("Alamat Baru:", mutasi.newAddress.isEmpty ? "-" : mutasi.newAddress),

              // Mutation date
              _buildDetailField("Tanggal Mutasi:", mutasi.date),

              // Mutation type
              _buildDetailField("Jenis Mutasi:", mutasi.mutationType, textColor: mutasi.statusColor),

              // Reason
              _buildDetailField("Alasan:", mutasi.reason),

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

  Widget _buildDetailField(String label, String value, {Color? textColor}) {
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
            style: TextStyle(
              fontSize: 16,
              color: textColor ?? Colors.black,
              fontWeight: textColor != null ? FontWeight.w500 : null,
            ),
          ),
        ],
      ),
    );
  }
}