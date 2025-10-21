import 'package:flutter/material.dart';

class FormRadioGroup<T> extends StatelessWidget {
  final T value;
  final List<T> options;
  final List<String> labels;
  final void Function(T?) onChanged;
  final Color activeColor;
  final Widget Function(String, T)? buildStatusInfo;

  const FormRadioGroup({
    Key? key,
    required this.value,
    required this.options,
    required this.labels,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.buildStatusInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          options.length,
              (index) => Column(
            children: [
              RadioListTile<T>(
                title: Text(labels[index]),
                value: options[index],
                groupValue: value,
                activeColor: activeColor,
                onChanged: onChanged,
                contentPadding: EdgeInsets.zero,
              ),
              if (buildStatusInfo != null && value == options[index])
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: buildStatusInfo!(labels[index], options[index]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}