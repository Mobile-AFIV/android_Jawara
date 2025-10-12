import 'package:flutter/material.dart';

class ChannelTransferSection extends StatelessWidget {
  const ChannelTransferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Channel Transfer"),
      ),
      body: const Center(
        child: Text("Ini Section Channel Transfer di Menu Lainnya"),
      ),
    );
  }
}
