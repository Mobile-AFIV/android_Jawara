import 'package:flutter/material.dart';

class ExpandableSectionCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget statusChip;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final List<Widget> expandedContent;

  const ExpandableSectionCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.statusChip,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.expandedContent,
  }) : super(key: key);

  @override
  State<ExpandableSectionCard> createState() => _ExpandableSectionCardState();
}

class _ExpandableSectionCardState extends State<ExpandableSectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    ));

    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ExpandableSectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
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
        return Card(
          elevation: widget.isExpanded ? 4 : 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header section with hover effect
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onToggleExpand,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        // Animated indicator line
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 4,
                          height: widget.isExpanded ? 40 : 24,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: widget.isExpanded
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Title and subtitle with animated opacity
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: widget.isExpanded
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87,
                                ),
                              ),
                              if (widget.subtitle != null)
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: widget.isExpanded ? 0.8 : 0.6,
                                  child: Text(
                                    widget.subtitle!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Status chip with scale animation
                        AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: widget.isExpanded ? 1.05 : 1.0,
                          child: widget.statusChip,
                        ),
                        const SizedBox(width: 8),

                        // Animated expand icon
                        RotationTransition(
                          turns: _iconRotation,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: widget.isExpanded
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Animated expanded content
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.expandedContent
                              .asMap()
                              .entries
                              .map((entry) {
                            return AnimatedSlide(
                              duration: Duration(
                                milliseconds: 200 + (entry.key * 50),
                              ),
                              offset: widget.isExpanded
                                  ? Offset.zero
                                  : const Offset(0, -0.2),
                              child: AnimatedOpacity(
                                duration: Duration(
                                  milliseconds: 200 + (entry.key * 50),
                                ),
                                opacity: widget.isExpanded ? 1.0 : 0.0,
                                child: entry.value,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}