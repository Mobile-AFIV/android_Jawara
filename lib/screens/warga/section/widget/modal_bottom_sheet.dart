import 'package:flutter/material.dart';

class ModalBottomSheet {
  static Future<dynamic> showCustomModalBottomSheet({
    required List<Widget> Function(StateSetter setModalState) children,
    required BuildContext context,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return _AnimatedBottomSheet(
          children: children,
        );
      },
    );
  }
}

class _AnimatedBottomSheet extends StatefulWidget {
  final List<Widget> Function(StateSetter setModalState) children;

  const _AnimatedBottomSheet({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  State<_AnimatedBottomSheet> createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<_AnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return FractionallySizedBox(
                    heightFactor: 0.85,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle with animation
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 200),
                              tween: Tween(begin: 32.0, end: 40.0),
                              builder: (context, value, child) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: value,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        // Content area with fade-in animation
                        Expanded(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 20,
                                  top: 12,
                                ),
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildAnimatedChildren(
                                    widget.children(setModalState),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAnimatedChildren(List<Widget> children) {
    return children.asMap().entries.map((entry) {
      return TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 200 + (entry.key * 50)),
        curve: Curves.easeOut,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: entry.value,
      );
    }).toList();
  }
}