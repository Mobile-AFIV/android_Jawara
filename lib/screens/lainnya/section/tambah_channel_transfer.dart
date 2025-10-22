import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_dropdown.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class TambahChannelSection extends StatelessWidget {
  const TambahChannelSection({super.key});

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
            child: Text('Nama Channel'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan nama channel',
            ),
          ),  
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Tipe'),
          ),
          Padding(
             padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan Tipe Transfer Cth: Bank, E-Wallet, Qris',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Nomor Rekening / Akun'),
          ),
           Padding(
             padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan nomor rekening',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Nama Pemilik Akun'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CustomTextField(
              hintText: 'Masukkan nama pemilik akun',
            ),
          ),
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
