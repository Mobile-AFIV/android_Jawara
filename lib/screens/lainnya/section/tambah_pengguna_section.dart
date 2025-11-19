import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class TambahPenggunaSection extends StatefulWidget {
  const TambahPenggunaSection({super.key});

  @override
  State<TambahPenggunaSection> createState() => _TambahPenggunaSectionState();
}

class _TambahPenggunaSectionState extends State<TambahPenggunaSection> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noRekController = TextEditingController();
  final TextEditingController tipeController = TextEditingController();
  final TextEditingController pemilikController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Pengguna",
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
            const Text('Nama Pengguna'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: namaController,
              hintText: 'Masukkan nama pengguna',
            ),
            const SizedBox(height: 16),
            const Text('Email Pengguna'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: emailController,
              hintText: 'Masukkanm email',
            ),
            const SizedBox(height: 16),
            const Text('Nomor Rekening / Akun'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: noRekController,
              hintText: 'Masukkan nomor rekening atau akun',
            ),
            const SizedBox(height: 16),
            const Text('Tipe pengguna'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: tipeController,
              hintText: 'Masukkan tipe pengguna (contoh: Admin, User)',
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
                      emailController.text.isEmpty ||
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
                    'email': emailController.text,
                    'tipe': tipeController.text,
                    'pemilik': pemilikController.text, 
                    'no_rek': noRekController.text,
                    'status': 'Aktif', // Default status
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
