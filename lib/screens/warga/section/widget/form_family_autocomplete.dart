import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_input_decoration.dart';

class FormFamilyAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;

  const FormFamilyAutocomplete({
    Key? key,
    required this.controller,
    required this.label,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<FormFamilyAutocomplete> createState() => _FormFamilyAutocompleteState();
}

class _FormFamilyAutocompleteState extends State<FormFamilyAutocomplete> {
  List<String> familyOptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFamilyOptions();
  }

  Future<void> _loadFamilyOptions() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('warga').get();
      final Set<String> uniqueFamilies = {};

      for (var doc in querySnapshot.docs) {
        final family = doc.data()['family'] as String?;
        if (family != null && family.isNotEmpty) {
          uniqueFamilies.add(family);
        }
      }

      setState(() {
        familyOptions = uniqueFamilies.toList()..sort();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error if needed
      debugPrint('Error loading family options: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return TextFormField(
        controller: widget.controller,
        decoration: FormInputDecoration.inputDecoration(
          widget.isRequired ? "${widget.label} *" : widget.label,
        ).copyWith(
          suffixIcon: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        enabled: false,
      );
    }

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return familyOptions.where((String family) {
          return family
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      initialValue: TextEditingValue(text: widget.controller.text),
      onSelected: (String selection) {
        widget.controller.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        // Sync with main controller on init
        if (fieldController.text.isEmpty && widget.controller.text.isNotEmpty) {
          fieldController.text = widget.controller.text;
        }

        // Listen to changes and sync to main controller
        fieldController.addListener(() {
          if (fieldController.text != widget.controller.text) {
            widget.controller.text = fieldController.text;
          }
        });

        return TextFormField(
          controller: fieldController,
          focusNode: fieldFocusNode,
          decoration: FormInputDecoration.inputDecoration(
            widget.isRequired ? "${widget.label} *" : widget.label,
          ),
          onChanged: (value) {
            // Sync to main controller on every change
            widget.controller.text = value;
          },
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
            widget.controller.text = fieldController.text;
          },
          validator: widget.isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '${widget.label} tidak boleh kosong';
                  }
                  return null;
                }
              : null,
        );
      },
    );
  }
}
