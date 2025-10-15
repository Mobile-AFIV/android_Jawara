import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class MutasiKeluargaTambah extends StatelessWidget {
  const MutasiKeluargaTambah({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah mutasi keluarga baru'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: CustomTextField(),
          ),
          CustomButton(
            onPressed: () {
              halo();
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void halo() {
    print("halo");
  }
}