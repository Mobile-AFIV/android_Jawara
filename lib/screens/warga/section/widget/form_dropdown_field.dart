import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_input_decoration.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class FormDropdownField<T> extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isRequired;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;

  const FormDropdownField({
    Key? key,
    required this.label,
    this.hintText,
    this.isRequired = false,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<FormDropdownField<T>> createState() => _FormDropdownFieldState<T>();
}

class _FormDropdownFieldState<T> extends State<FormDropdownField<T>> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: DropdownButtonFormField<T>(
        focusNode: _focusNode,
        decoration: FormInputDecoration.inputDecoration(
          widget.isRequired ? "${widget.label} *" : widget.label,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
        ),
        initialValue: widget.value,
        items: widget.items,
        onChanged: widget.onChanged,
        validator: widget.validator ?? (widget.isRequired
            ? (value) {
          if (value == null) {
            return '${widget.label} harus dipilih';
          }
          return null;
        }
            : null),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppStyles.primaryColor),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 8,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        menuMaxHeight: 300,
      ),
    );
  }
}