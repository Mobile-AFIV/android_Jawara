import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SectionActionButtons extends StatelessWidget {
  final VoidCallback? onEditPressed;
  final Function onDetailPressed;
  final bool showEditButton;

  const SectionActionButtons({
    Key? key,
    this.onEditPressed,
    required this.onDetailPressed,
    this.showEditButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showEditButton) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onEditPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[100],
                foregroundColor: Colors.amber[800],
                elevation: 0,
              ),
              child: const Text('edit'),
            ),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onDetailPressed(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              foregroundColor: Colors.blue[800],
              elevation: 0,
            ),
            child: const Text('detail'),
          ),
        ),
      ],
    );
  }
}