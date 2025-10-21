import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String label;
  // Color parameters - either use direct colors or MaterialColor
  final MaterialColor? color;
  final Color? backgroundColor;
  final Color? textColor;
  // Style parameters
  final double fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;

  const StatusChip({
    Key? key,
    required this.label,
    // Two ways to specify colors:
    // Option 1: Using MaterialColor
    this.color,
    // Option 2: Using specific colors
    this.backgroundColor,
    this.textColor,
    // Style options
    this.fontSize = 14.0,
    this.fontWeight,
    this.padding,
  }) : assert(color != null || (backgroundColor != null && textColor != null),
  'Either provide a MaterialColor or both backgroundColor and textColor'),
        super(key: key);

  // Named constructor for MaterialColor-based usage
  const StatusChip.fromMaterialColor({
    Key? key,
    required String label,
    required MaterialColor color,
    double fontSize = 12.0,
    FontWeight? fontWeight,
  }) : this(
    key: key,
    label: label,
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );

  // Named constructor for direct color usage
  const StatusChip.fromColors({
    Key? key,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.bold,
  }) : this(
    key: key,
    label: label,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );

  @override
  Widget build(BuildContext context) {
    // Determine which color mode we're using
    final Color bgColor = color != null ? color![100]! : backgroundColor!;
    final Color txtColor = color != null ? color![800]! : textColor!;
    final EdgeInsets chipPadding = padding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final FontWeight chipFontWeight = fontWeight ?? FontWeight.bold;

    return Container(
      padding: chipPadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: txtColor,
          fontWeight: chipFontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}