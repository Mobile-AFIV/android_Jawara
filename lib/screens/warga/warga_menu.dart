import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WargaMenu extends StatelessWidget {
  const WargaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Ini Menu Warga"),
          TextButton(
            onPressed: () => context.pushNamed('keluarga'),
            child: Text("Ke Section Keluarga"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('mutasi_keluarga'),
            child: Text("Ke Section Mutasi Keluarga"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('penerimaan_warga'),
            child: Text("Ke Section Penerimaan Warga"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('rumah'),
            child: Text("Ke Section Rumah"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('warga_section'),
            child: Text("Ke Section Warga"),
          ),
        ],
      ),
    );
  }
}
