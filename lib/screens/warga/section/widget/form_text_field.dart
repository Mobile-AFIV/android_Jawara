import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_input_decoration.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  final int? maxLines;

  const FormTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.isRequired = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: FormInputDecoration.inputDecoration(
        isRequired ? "$label *" : label,
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator ?? (isRequired
          ? (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      }
          : null),
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
    );
  }
}