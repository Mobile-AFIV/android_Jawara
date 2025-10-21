import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class FormRadioGroup<T> extends StatefulWidget {
  final T value;
  final List<T> options;
  final List<String> labels;
  final List<IconData>? icons;
  final void Function(T?) onChanged;
  final Color? activeColor;
  final Widget Function(String, T)? buildStatusInfo;

  const FormRadioGroup({
    Key? key,
    required this.value,
    required this.options,
    required this.labels,
    this.icons,
    required this.onChanged,
    this.activeColor,
    this.buildStatusInfo,
  }) : super(key: key);

  @override
  State<FormRadioGroup<T>> createState() => _FormRadioGroupState<T>();
}

class _FormRadioGroupState<T> extends State<FormRadioGroup<T>> {
  @override
  Widget build(BuildContext context) {
    final color = widget.activeColor ?? AppStyles.primaryColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          widget.options.length,
          (index) {
            final isSelected = widget.value == widget.options[index];
            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
              builder: (context, value, child) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? color.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? color.withValues(alpha: 0.5)
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<T>(
                        title: Row(
                          children: [
                            if (widget.icons != null && widget.icons!.length > index) ...[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? color.withValues(alpha: 0.15)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  widget.icons![index],
                                  size: 20,
                                  color: isSelected ? color : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Text(
                                widget.labels[index],
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  fontSize: 15,
                                  color: isSelected ? color : Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        value: widget.options[index],
                        groupValue: widget.value,
                        activeColor: color,
                        onChanged: widget.onChanged,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                      if (widget.buildStatusInfo != null && isSelected)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                          child: widget.buildStatusInfo!(widget.labels[index], widget.options[index]),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}