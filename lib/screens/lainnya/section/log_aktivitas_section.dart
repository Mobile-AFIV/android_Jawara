import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/models/log_aktivitas.dart';
import 'package:jawara_pintar/services/log_aktivitas_service.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class LogAktivitasSection extends StatefulWidget {
  const LogAktivitasSection({super.key});

  @override
  State<LogAktivitasSection> createState() => _LogAktivitasSectionState();
}

class _LogAktivitasSectionState extends State<LogAktivitasSection> {
  final TextEditingController deskripsiLog = TextEditingController();
  final TextEditingController aktorLog = TextEditingController();

  // ===============================
  // SHOW EDIT DIALOG
  // ===============================
  Future<void> _showEditLog(LogAktivitas log) async {
    // set initial values (in case controller changed earlier)
    deskripsiLog.text = log.deskripsi;
    aktorLog.text = log.aktor;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Log Aktivitas"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: deskripsiLog,
              decoration: const InputDecoration(
                labelText: "Deskripsi Log",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: aktorLog,
              decoration: const InputDecoration(
                labelText: "Aktor Log",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Map<String, dynamic> data = {};

              if (deskripsiLog.text.trim() != log.deskripsi) {
                data['deskripsi'] = deskripsiLog.text.trim();
              }

              if (aktorLog.text.trim() != log.aktor) {
                data['aktor'] = aktorLog.text.trim();
              }

              if (data.isEmpty) {
                // nothing changed -> just close
                Navigator.pop(context);
                return;
              }

              try {
                await LogAktivitasService.instance.updateLogAktivitas(
                  id: log.id,
                  logBaru: data,
                );
                Navigator.pop(context);
                setState(() {});
                // optional: show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log berhasil diperbarui')),
                );
              } catch (e) {
                // handle error: show message but keep dialog open so user can retry/cancel
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal update: $e')),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // ===============================
  // SHOW TAMBAH LOG
  // ===============================
  Future<void> _showTambahLog() async {
    deskripsiLog.clear();
    aktorLog.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Log Aktivitas"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: deskripsiLog,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: aktorLog,
              decoration: const InputDecoration(
                labelText: "Nama Aktor",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final deskripsi = deskripsiLog.text.trim();
              final aktor = aktorLog.text.trim();

              if (deskripsi.isEmpty || aktor.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Harap isi semua field')),
                );
                return;
              }

              try {
                await LogAktivitasService.instance.createLogAktivitas(
                  deskripsi: deskripsi,
                  aktor: aktor,
                );
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log berhasil ditambahkan')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menambah log: $e')),
                );
              }
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    deskripsiLog.dispose();
    aktorLog.dispose();
    super.dispose();
  }

  String _formatWaktu(dynamic waktu) {
    if (waktu == null) return "-";
    try {
      if (waktu is DateTime) {
        final d = waktu;
        return "${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
      }
      if (waktu is Map && waktu['seconds'] != null) {
        
        final seconds = waktu['seconds'] as int;
        final d = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        return "${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
      }
      final maybeToDate = (waktu as dynamic).toDate;
      if (maybeToDate is Function) {
        final d = (waktu as dynamic).toDate() as DateTime;
        return "${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
      }
      
      return waktu.toString();
    } catch (_) {
      return waktu.toString();
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Log Aktivitas"),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<List<LogAktivitas>>(
        future: LogAktivitasService.instance.getAllLogAktivitas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada log aktivitas."));
          }

          final logs = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: logs.length,
            itemBuilder: (context, i) {
              final log = logs[i];
              final waktuText = _formatWaktu(log.waktu);

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),

                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.history, color: Colors.orange),
                    ),

                    // ---------- TITLE ----------
                    title: Text(
                      log.deskripsi,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Text(
                      "Aktor: ${log.aktor}",
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),

                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          waktuText,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey),
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),

                    // ---------- DROPDOWN CONTENT ----------
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Deskripsi: ${log.deskripsi}"),
                          const SizedBox(height: 6),
                          Text("Aktor: ${log.aktor}"),
                          const SizedBox(height: 6),
                          Text("Waktu: $waktuText"),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () => _showEditLog(log),
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text("Edit"),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () async {
                                  final konfirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Konfirmasi"),
                                      content: const Text(
                                          "Hapus log aktivitas ini?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Batal")),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Hapus")),
                                      ],
                                    ),
                                  );

                                  if (konfirm == true) {
                                    await LogAktivitasService.instance
                                        .deleteLogAktivitas(log.id);
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(Icons.delete,
                                    size: 18, color: Colors.red),
                                label: const Text("Hapus",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),

    floatingActionButton: FloatingActionButton.extended(
      onPressed: _showTambahLog,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        "Tambah Log",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppStyles.primaryColor,
    ),
  );
}
}
