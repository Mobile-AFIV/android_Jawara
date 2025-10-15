import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final Color? customBackgroundColor;
  final double? width;
  final Widget? child;

  const CustomButton({super.key, required this.onPressed, this.customBackgroundColor, this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? double.infinity : width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: customBackgroundColor ?? AppStyles.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: child,
      ),
    );
  }
}
