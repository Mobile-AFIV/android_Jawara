import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class FormStepperControls extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onCancel;
  final bool isLastStep;
  final bool isFirstStep;
  final IconData? continueIcon;
  final IconData? cancelIcon;

  const FormStepperControls({
    Key? key,
    required this.onContinue,
    required this.onCancel,
    required this.isLastStep,
    required this.isFirstStep,
    this.continueIcon,
    this.cancelIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
                shadowColor: AppStyles.primaryColor.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    continueIcon ?? (isLastStep ? Icons.save_outlined : Icons.arrow_forward_rounded),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isLastStep ? 'Simpan' : 'Lanjut',
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
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cancelIcon ?? (isFirstStep ? Icons.close : Icons.arrow_back_rounded),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isFirstStep ? 'Batal' : 'Kembali',
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