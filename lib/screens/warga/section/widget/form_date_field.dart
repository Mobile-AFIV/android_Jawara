import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class FormDateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool isRequired;
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const FormDateField({
    Key? key,
    required this.controller,
    required this.label,
    this.hintText,
    this.isRequired = false,
    this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<FormDateField> createState() => _FormDateFieldState();
}

class _FormDateFieldState extends State<FormDateField> {

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)), // Allow future dates up to 10 years
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppStyles.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppStyles.primaryColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ), dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.controller.text = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hintText ?? 'Pilih tanggal',
      isRequired: widget.isRequired,
      readOnly: true,
      onTap: () => _selectDate(context),
      suffixIcon: Icons.calendar_today_rounded,
      prefixIcon: Icons.event_outlined,
    );
  }
}