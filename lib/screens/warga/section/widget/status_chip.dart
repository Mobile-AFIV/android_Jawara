import 'package:flutter/material.dart';

class StatusChip extends StatefulWidget {
  final String label;
  final MaterialColor? color;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final bool showPulse;
  final IconData? icon;

  const StatusChip({
    Key? key,
    required this.label,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14.0,
    this.fontWeight,
    this.padding,
    this.showPulse = false,
    this.icon,
  }) : assert(
            color != null || (backgroundColor != null && textColor != null),
            'Either provide a MaterialColor or both backgroundColor and textColor'),
        super(key: key);

  const StatusChip.fromMaterialColor({
    Key? key,
    required String label,
    required MaterialColor color,
    double fontSize = 12.0,
    FontWeight? fontWeight,
    bool showPulse = false,
    IconData? icon,
  }) : this(
          key: key,
          label: label,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          showPulse: showPulse,
          icon: icon,
        );

  const StatusChip.fromColors({
    Key? key,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.bold,
    bool showPulse = false,
    IconData? icon,
  }) : this(
          key: key,
          label: label,
          backgroundColor: backgroundColor,
          textColor: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          showPulse: showPulse,
          icon: icon,
        );

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StatusChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPulse != oldWidget.showPulse) {
      if (widget.showPulse) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        widget.color != null ? widget.color![100]! : widget.backgroundColor!;
    final Color txtColor =
        widget.color != null ? widget.color![800]! : widget.textColor!;
    final EdgeInsets chipPadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final FontWeight chipFontWeight = widget.fontWeight ?? FontWeight.bold;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.showPulse ? _pulseAnimation.value : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: chipPadding,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: txtColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
                border: Border.all(
                  color: _isHovered
                      ? txtColor.withOpacity(0.3)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: widget.fontSize + 2,
                      color: txtColor,
                    ),
                    const SizedBox(width: 4),
                  ],
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: txtColor,
                      fontWeight: chipFontWeight,
                      fontSize: widget.fontSize,
                      letterSpacing: _isHovered ? 0.5 : 0,
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}