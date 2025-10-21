import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_input_decoration.dart';

class FormDropdownField<T> extends StatelessWidget {
  final String label;
  final bool isRequired;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const FormDropdownField({
    Key? key,
    required this.label,
    this.isRequired = false,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: FormInputDecoration.inputDecoration(
        isRequired ? "$label *" : label,
      ),
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator ?? (isRequired
          ? (value) {
        if (value == null) {
          return '$label harus dipilih';
        }
        return null;
      }
          : null),
    );
  }
}