import 'package:flutter/material.dart';

class CustomFilterSheet extends StatefulWidget {
  final List<String> availableFilters;
  final List<String> selectedFilters;

  const CustomFilterSheet({
    super.key,
    required this.availableFilters,
    required this.selectedFilters,
  });

  @override
  State<CustomFilterSheet> createState() => _CustomFilterSheetState();
}

class _CustomFilterSheetState extends State<CustomFilterSheet> {
  late List<String> tempSelected;

  @override
  void initState() {
    super.initState();
    tempSelected = List.from(widget.selectedFilters);
  }

  void toggleFilter(String filter) {
    setState(() {
      if (tempSelected.contains(filter)) {
        tempSelected.remove(filter);
      } else {
        tempSelected.add(filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filter Broadcast",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          Wrap(
            spacing: 10,
            children: widget.availableFilters.map((filter) {
              bool active = tempSelected.contains(filter);
              return FilterChip(
                label: Text(filter),
                selected: active,
                onSelected: (_) => toggleFilter(filter),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, <String>[]),
                  child: const Text("Reset"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, tempSelected),
                  child: const Text("Terapkan"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
