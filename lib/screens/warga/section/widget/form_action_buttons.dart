import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class FormActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String saveLabel;
  final String cancelLabel;
  final IconData? saveIcon;
  final IconData? cancelIcon;

  const FormActionButtons({
    Key? key,
    required this.onSave,
    required this.onCancel,
    this.saveLabel = 'Simpan',
    this.cancelLabel = 'Batal',
    this.saveIcon = Icons.save_outlined,
    this.cancelIcon = Icons.close,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: AppStyles.primaryColor.withValues(alpha: 0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (saveIcon != null) ...[
                    Icon(saveIcon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    saveLabel,
                    style: const TextStyle(
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
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (cancelIcon != null) ...[
                    Icon(cancelIcon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    cancelLabel,
                    style: const TextStyle(
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
      ),
    );
  }
}