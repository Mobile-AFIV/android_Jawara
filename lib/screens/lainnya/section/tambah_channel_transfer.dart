import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class TambahChannelSection extends StatefulWidget {
  const TambahChannelSection({super.key});

  @override
  State<TambahChannelSection> createState() => _TambahChannelSectionState();
}

class _TambahChannelSectionState extends State<TambahChannelSection> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tipeController = TextEditingController();
  final TextEditingController noRekController = TextEditingController();
  final TextEditingController pemilikController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Channel Transfer",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nama Channel'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: namaController,
              hintText: 'Masukkan nama channel',
            ),
            const SizedBox(height: 16),
            const Text('Tipe'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: tipeController,
              hintText: 'Masukkan tipe transfer (contoh: Bank, E-Wallet, Qris)',
            ),
            const SizedBox(height: 16),
            const Text('Nomor Rekening / Akun'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: noRekController,
              hintText: 'Masukkan nomor rekening atau akun',
            ),
            const SizedBox(height: 16),
            const Text('Nama Pemilik Akun'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: pemilikController,
              hintText: 'Masukkan nama pemilik akun',
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                onPressed: () {
                  if (namaController.text.isEmpty ||
                      tipeController.text.isEmpty ||
                      noRekController.text.isEmpty ||
                      pemilikController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Harap isi semua field terlebih dahulu')),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    'nama': namaController.text,
                    'tipe': tipeController.text,
                    'A/N': pemilikController.text, 
                    'no_rek': noRekController.text,
                  });
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
