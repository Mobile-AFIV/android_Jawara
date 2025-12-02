import 'package:flutter/material.dart';

class BodySectionInfo extends StatelessWidget {
  final double? height;
  final Color backgroundColor;
  final String textInfo;

  const BodySectionInfo({
    super.key,
    this.height,
    required this.backgroundColor,
    required this.textInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: MediaQuery.sizeOf(context).width / 7,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        textInfo,
        textAlign: TextAlign.center,
      ),
    );
  }
}
