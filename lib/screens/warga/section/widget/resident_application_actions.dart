import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/penerimaan_warga_dummy.dart';

class ResidentApplicationActions extends StatelessWidget {
  final PenerimaanWargaModel penerimaan;
  final VoidCallback onAccept;
  final Function() onShowRejectionDialog;

  const ResidentApplicationActions({
    Key? key,
    required this.penerimaan,
    required this.onAccept,
    required this.onShowRejectionDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For applications with "Menunggu" status, show both accept and reject buttons
    if (penerimaan.registrationStatus == 'Menunggu') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.green[800],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Terima'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onShowRejectionDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.red[800],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Tolak'),
            ),
          ),
        ],
      );
    }
    // For rejected applications, show only the accept button
    else if (penerimaan.registrationStatus == 'Ditolak') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onAccept,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[100],
            foregroundColor: Colors.green[800],
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Terima Pendaftaran'),
        ),
      );
    }
    // For accepted applications, show no action buttons
    else {
      return const SizedBox.shrink();
    }
  }
}