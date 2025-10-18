import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class AppBarActionButton {
  static Widget filter({
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: AppStyles.primaryColor,
          borderRadius: BorderRadiusGeometry.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: const Icon(
          Icons.filter_alt_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  static Widget pdfDownload({
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppStyles.primaryColor,
          ),
          borderRadius: BorderRadiusGeometry.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: const Row(
          children: [
            Icon(
              Icons.download_rounded,
              color: AppStyles.primaryColor,
              size: 20,
            ),
            SizedBox(width: 4),
            Text(
              "PDF",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppStyles.primaryColor,
              ),
            ),
            SizedBox(width: 2),
          ],
        ),
      ),
    );
  }
}
