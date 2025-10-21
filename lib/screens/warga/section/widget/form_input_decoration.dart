import 'package:flutter/material.dart';

class FormInputDecoration {
  static InputDecoration inputDecoration(String label, {IconData? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }
}