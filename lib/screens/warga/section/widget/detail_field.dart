import 'package:flutter/material.dart';

class DetailField extends StatelessWidget {
  final String label;
  final String value;
  final Color? textColor;

  const DetailField({
    Key? key,
    required this.label,
    required this.value,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: textColor ?? Colors.black,
              fontWeight: textColor != null ? FontWeight.w500 : null,
            ),
          ),
        ],
      ),
    );
  }
}