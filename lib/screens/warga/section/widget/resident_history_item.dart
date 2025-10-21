import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/rumah_dummy.dart';

class ResidentHistoryItem extends StatelessWidget {
  final ResidentHistory resident;

  const ResidentHistoryItem({
    Key? key,
    required this.resident,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column - Family name and move-in date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Keluarga",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resident.familyName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Tanggal Masuk",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resident.moveInDate,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Right column - Head of family and move-out date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Kepala Keluarga",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resident.headOfFamily,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Tanggal Keluar",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resident.moveOutDate ?? "Masih Tinggal",
                  style: TextStyle(
                    fontSize: 14,
                    color: resident.moveOutDate == null ? Colors.green : null,
                    fontWeight: resident.moveOutDate == null ? FontWeight.w500 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}