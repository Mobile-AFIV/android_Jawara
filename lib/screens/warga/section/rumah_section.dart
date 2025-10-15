import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RumahSection extends StatelessWidget {
  const RumahSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rumah"),
      ),
      body: const Center(
        child: Text("Ini Section Rumah di Menu Warga"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: () {
          context.pushNamed('rumah_tambah');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
