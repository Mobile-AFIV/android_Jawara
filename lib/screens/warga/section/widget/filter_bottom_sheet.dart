import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class FilterBottomSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final Function(String) onSelected;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? selectedColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final bool showIcons;
  final Map<String, IconData>? optionIcons;

  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.primaryColor,
    this.backgroundColor,
    this.textColor,
    this.selectedColor,
    this.borderRadius = 20.0,
    this.padding,
    this.showIcons = false,
    this.optionIcons,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
    Color? selectedColor,
    double borderRadius = 20.0,
    EdgeInsets? padding,
    bool showIcons = false,
    Map<String, IconData>? optionIcons,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      builder: (context) => FilterBottomSheet(
        title: title,
        options: options,
        selectedValue: selectedValue,
        onSelected: onSelected,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        textColor: textColor,
        selectedColor: selectedColor,
        borderRadius: borderRadius,
        padding: padding,
        showIcons: showIcons,
        optionIcons: optionIcons,
      ),
    );
  }

  IconData? _getIconForOption(String option) {
    return optionIcons?[option];
  }

  @override
  Widget build(BuildContext context) {
    final defaultPrimaryColor = primaryColor ?? AppStyles.primaryColor;
    final defaultBackgroundColor = backgroundColor ?? Colors.white;
    final defaultTextColor = textColor ?? AppStyles.textPrimaryColor;
    final defaultSelectedColor = selectedColor ?? defaultPrimaryColor;
    final defaultPadding = padding ?? const EdgeInsets.all(20);
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          decoration: BoxDecoration(
            color: defaultBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
          ),
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: defaultPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: defaultTextColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: defaultPrimaryColor.withValues(alpha: 0.7),
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Pilih filter yang diinginkan',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppStyles.textSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Filter options
                  ...options.map((option) {
                    final isSelected = option == selectedValue;
                    final icon = showIcons ? _getIconForOption(option) : null;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? defaultSelectedColor.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? defaultSelectedColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: RadioListTile<String>(
                        title: Row(
                          children: [
                            if (icon != null) ...[
                              Icon(
                                icon,
                                color: isSelected ? defaultSelectedColor : Colors.grey.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              option,
                              style: TextStyle(
                                color: isSelected ? defaultSelectedColor : defaultTextColor,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        value: option,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => onSelected(value));
                            // Add a small delay for visual feedback
                            Future.delayed(const Duration(milliseconds: 150), () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        activeColor: defaultSelectedColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}