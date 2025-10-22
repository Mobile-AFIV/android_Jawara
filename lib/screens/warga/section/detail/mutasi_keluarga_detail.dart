import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/mutasi_keluarga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';
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
              DetailField(label: "Keluarga:", value: mutasi.familyName),

              // Old address
              DetailField(label: "Alamat Lama:", value: mutasi.oldAddress),

              // New address
              DetailField(label: "Alamat Baru:", value: mutasi.newAddress.isEmpty ? "-" : mutasi.newAddress),

              // Mutation date
              DetailField(label: "Tanggal Mutasi:", value: mutasi.date),

              // Mutation type
              DetailField(
                  label: "Jenis Mutasi:",
                  value: mutasi.mutationType,
                  textColor: mutasi.statusColor
              ),

              // Reason
              DetailField(label: "Alasan:", value: mutasi.reason),

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