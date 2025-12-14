import 'package:flutter/material.dart';

class SectionActionButton extends StatefulWidget {
  final VoidCallback? onEditPressed;
  final Function? onDetailPressed;
  final bool showEditButton;
  final VoidCallback? onDeletePressed;
  final bool showDeleteButton;
  const SectionActionButton({
    Key? key,
    this.onEditPressed,
    this.onDetailPressed,
    this.showEditButton = true,
    this.showDeleteButton = false,
    this.onDeletePressed,
  }) : super(key: key);

  @override
  State<SectionActionButton> createState() => _SectionActionButtonsState();
}

class _SectionActionButtonsState extends State<SectionActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _editSlideAnimation;
  late Animation<Offset> _detailSlideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _deleteSlideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _deleteSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _editSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _detailSlideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showEditButton) ...[
          SlideTransition(
            position: _editSlideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _AnimatedButton(
                onPressed: widget.onEditPressed,
                label: 'Edit',
                icon: Icons.edit_outlined,
                backgroundColor: Colors.amber[100]!,
                foregroundColor: Colors.amber[800]!,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (widget.showDeleteButton) ...[
          SlideTransition(
            position: _deleteSlideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _AnimatedButton(
                onPressed: widget.onDeletePressed,
                label: 'Hapus',
                icon: Icons.delete_outline,
                backgroundColor: Colors.red[100]!,
                foregroundColor: Colors.red[800]!,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        widget.onDetailPressed == null
            ? SizedBox()
            : SlideTransition(
                position: _detailSlideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _AnimatedButton(
                    onPressed: () => widget.onDetailPressed!(),
                    label: 'Detail',
                    icon: Icons.info_outline,
                    backgroundColor: Colors.blue[100]!,
                    foregroundColor: Colors.blue[800]!,
                  ),
                ),
              ),
      ],
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const _AnimatedButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  }) : super(key: key);

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.98 : _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onPressed,
                  icon: Icon(widget.icon, size: 18),
                  label: Text(
                    widget.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.backgroundColor,
                    foregroundColor: widget.foregroundColor,
                    elevation: _isPressed ? 1 : 0,
                    shadowColor: widget.foregroundColor.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
