import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const FormCard({
    Key? key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.only(bottom: 24.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: padding,
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
            ...children,
          ],
        ),
      ),
    );
  }
}