import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RumahTambah extends StatelessWidget {
  const RumahTambah({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Rumah Baru"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Alamat Rumah",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            CustomTextField(),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    onPressed: () {
                      halo();
                    },
                    child: const Text("Simpan"),
                  ),
                  SizedBox(width: 20),
                  CustomButton(
                    onPressed: () {
                      halo();
                    },
                    child: const Text("Simpan"),
                  ),
                  // SizedBox(width: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void halo() {
    print("halo");
  }
}
