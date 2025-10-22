import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class DetailBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const DetailBackButton({
    Key? key,
    required this.onPressed,
    this.label = 'Kembali',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label),
      ),
    );
  }
}