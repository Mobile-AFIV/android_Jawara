import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;
  final double borderRadius;
  final EdgeInsets? contentPadding;
  final bool showShadow;

  const SearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.borderRadius = 25.0,
    this.contentPadding,
    this.showShadow = true,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSearchChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onChanged(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = widget.backgroundColor ?? Colors.white;
    final defaultBorderColor = widget.borderColor ?? AppStyles.primaryColor.withValues(alpha: 0.2);
    final defaultTextColor = widget.textColor ?? AppStyles.textPrimaryColor;
    final defaultHintColor = widget.hintColor ?? AppStyles.textSecondaryColor;
    final defaultContentPadding = widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: defaultBackgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: defaultBorderColor,
            width: 1.5,
          ),
          boxShadow: widget.showShadow
              ? [
                  BoxShadow(
                    color: AppStyles.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: TextField(
          controller: widget.controller,
          autofocus: true,
          style: TextStyle(
            color: defaultTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: defaultHintColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            contentPadding: defaultContentPadding,
            prefixIcon: Icon(
              Icons.search,
              color: AppStyles.primaryColor.withValues(alpha: 0.7),
              size: 22,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: AppStyles.primaryColor.withValues(alpha: 0.7),
                size: 20,
              ),
              onPressed: widget.onClear,
              splashRadius: 20,
            ),
          ),
        ),
      ),
    );
  }
}