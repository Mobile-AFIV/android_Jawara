import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/keluarga_dummy.dart';

class FamilyMemberCard extends StatelessWidget {
  final FamilyMember member;

  const FamilyMemberCard({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            member.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "NIK: ${member.nik}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Peran: ${member.role}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Jenis Kelamin: ${member.gender}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tanggal Lahir: ${member.birthDate}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            member.status,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}