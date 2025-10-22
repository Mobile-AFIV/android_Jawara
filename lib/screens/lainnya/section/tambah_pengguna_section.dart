import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_dropdown.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class TambahPenggunaSection extends StatelessWidget {
  const TambahPenggunaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengguna"),
      ),
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Nama Lengkap'),
          ),  
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan nama lengkap',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Email'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan email aktif',
              keyboardType: TextInputType.emailAddress
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Nomor HP'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan nomor HP (cth: 08xxxxxxxxxx)',
              keyboardType: TextInputType.phone
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Password'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan password',
              obscureText: true,
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Konfirmasi Password'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan ulang password',
              obscureText: true,
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Role Pengguna'),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: const CustomDropdown(
          //     // hintText: '-- Pilih Role--',
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                onPressed: () {
                  // aksi simpan nanti di sini
                },
                child: const Text('Simpan'),
              )
            ),
          ),
        ],
      ),
      ),
    );
  }
}
