import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class FormDateField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const FormDateField({
    Key? key,
    required this.controller,
    required this.label,
    this.isRequired = false,
    this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyles.primaryColor,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      controller: controller,
      label: label,
      isRequired: isRequired,
      readOnly: true,
      onTap: () => _selectDate(context),
      suffixIcon: Icons.calendar_today,
    );
  }
}