import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class HeadingSection extends StatelessWidget {
  final String headingText;
  final String? subHeadingText;
  final Function() lainnyaOnPressed;

  const HeadingSection({
    super.key,
    required this.headingText,
    this.subHeadingText,
    required this.lainnyaOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              if (subHeadingText != null)
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: Text(
                    subHeadingText!,
                    style:
                    const TextStyle(color: AppStyles.primaryColor, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 2),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: Text(
                  headingText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(left: 12, right: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
              overlayColor: AppStyles.primaryColor,
            ),
            onPressed: lainnyaOnPressed,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Lihat semua",
                  style: TextStyle(color: AppStyles.primaryColor),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: AppStyles.primaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
