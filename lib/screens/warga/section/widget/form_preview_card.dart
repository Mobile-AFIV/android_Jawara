import 'package:flutter/material.dart';

class FormPreviewCard extends StatelessWidget {
  final String title;
  final List<Widget> previewItems;

  const FormPreviewCard({
    Key? key,
    this.title = 'Pratinjau',
    required this.previewItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...previewItems,
          ],
        ),
      ),
    );
  }
}