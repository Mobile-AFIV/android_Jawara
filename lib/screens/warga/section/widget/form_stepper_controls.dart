import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class FormStepperControls extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onCancel;
  final bool isLastStep;
  final bool isFirstStep;

  const FormStepperControls({
    Key? key,
    required this.onContinue,
    required this.onCancel,
    required this.isLastStep,
    required this.isFirstStep,
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isLastStep ? 'Simpan' : 'Lanjut'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppStyles.primaryColor,
                side: BorderSide(color: AppStyles.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isFirstStep ? 'Batal' : 'Kembali'),
            ),
          ),
        ],
      ),
    );
  }
}