import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class ActiveFilterChip extends StatelessWidget {
  final String activeFilter;
  final IconData? icon;
  final VoidCallback? onClear;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final bool showClearButton;

  const ActiveFilterChip({
    super.key,
    required this.activeFilter,
    this.icon,
    this.onClear,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderRadius = 20.0,
    this.padding,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = backgroundColor ?? AppStyles.primaryColor.withValues(alpha: 0.1);
    final defaultTextColor = textColor ?? AppStyles.primaryColor;
    final defaultIconColor = iconColor ?? AppStyles.primaryColor;
    final defaultPadding = padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    // Don't show if no active filter
    if (activeFilter == 'Semua' || activeFilter.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: showClearButton ? onClear : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: defaultPadding,
            decoration: BoxDecoration(
              color: defaultBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: defaultTextColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: defaultIconColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  'Filter: $activeFilter',
                  style: TextStyle(
                    color: defaultTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showClearButton) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.close,
                    color: defaultIconColor.withValues(alpha: 0.7),
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}