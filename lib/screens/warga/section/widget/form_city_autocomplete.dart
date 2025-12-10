import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_input_decoration.dart';

class FormCityAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;

  // Indonesian cities list
  static const List<String> cityOptions = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Semarang',
    'Makassar',
    'Palembang',
    'Tangerang',
    'Depok',
    'Bekasi',
    'Bogor',
    'Yogyakarta',
    'Malang',
    'Solo',
    'Denpasar',
  ];

  const FormCityAutocomplete({
    Key? key,
    required this.controller,
    required this.label,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return cityOptions.where((String city) {
          return city
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      initialValue: TextEditingValue(text: controller.text),
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        // Sync with main controller on init
        if (fieldController.text.isEmpty && controller.text.isNotEmpty) {
          fieldController.text = controller.text;
        }

        // Listen to changes and sync to main controller
        fieldController.addListener(() {
          if (fieldController.text != controller.text) {
            controller.text = fieldController.text;
          }
        });

        return TextFormField(
          controller: fieldController,
          focusNode: fieldFocusNode,
          decoration: FormInputDecoration.inputDecoration(
            isRequired ? "$label *" : label,
          ),
          onChanged: (value) {
            // Sync to main controller on every change
            controller.text = value;
          },
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
            controller.text = fieldController.text;
          },
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label tidak boleh kosong';
                  }
                  return null;
                }
              : null,
        );
      },
    );
  }
}
