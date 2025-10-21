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
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: Colors.green.withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Terima',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: onShowRejectionDialog,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade400, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cancel_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Tolak',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
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
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.green.withValues(alpha: 0.4),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle_rounded, size: 20),
              SizedBox(width: 8),
              Text(
                'Terima Pendaftaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }
    // For accepted applications, show no action buttons
    else {
      return const SizedBox.shrink();
    }
  }
}