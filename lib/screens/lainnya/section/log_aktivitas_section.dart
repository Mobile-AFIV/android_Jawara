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
  // Filter controllers
  final TextEditingController _filterDeskripsiController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  List<LogAktivitas> _logs = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _limit = 5; // jumlah log per "halaman"
  LogAktivitas? _lastLog; // untuk tracking data terakhir

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newLogs = await LogAktivitasService.instance.getLogAktivitasLimit(
        startAfter: _lastLog,
        limit: _limit,
      );

      if (newLogs.length < _limit) {
        _hasMore = false;
      }

      if (newLogs.isNotEmpty) {
        _lastLog = newLogs.last;
        _logs.addAll(newLogs);
      }

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal load log: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    deskripsiLog.dispose();
    aktorLog.dispose();
    _filterDeskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart ? (_startDate ?? now) : (_endDate ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _applyFilter() async {
    setState(() {
      _isLoading = true;
      _logs = [];
      _hasMore = false; // when filtering we show exact results
    });

    try {
      final all = await LogAktivitasService.instance.getAllLogAktivitas();

      final descFilter = _filterDeskripsiController.text.trim().toLowerCase();

      final filtered = all.where((l) {
        final passDesc = descFilter.isEmpty
            ? true
            : l.deskripsi.toLowerCase().contains(descFilter);

        final passStart = _startDate == null ? true : !l.waktu.isBefore(_startDate!);
        final passEnd = _endDate == null ? true : !l.waktu.isAfter(_endDate!.add(const Duration(hours: 23, minutes: 59, seconds: 59)));

        return passDesc && passStart && passEnd;
      }).toList();

      setState(() {
        _logs = filtered;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menerapkan filter: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _resetFilter() {
    setState(() {
      _filterDeskripsiController.clear();
      _startDate = null;
      _endDate = null;
      _hasMore = true;
      _logs = [];
      _lastLog = null;
    });
    _fetchLogs();
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
      appBar: AppBar(title: const Text("Log Aktivitas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filter UI
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          onTap: () => _pickDate(isStart: true),
                          decoration: InputDecoration(
                            labelText: 'Tanggal Mulai',
                            hintText: _startDate == null ? 'Pilih tanggal' : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          onTap: () => _pickDate(isStart: false),
                          decoration: InputDecoration(
                            labelText: 'Tanggal Selesai',
                            hintText: _endDate == null ? 'Pilih tanggal' : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _filterDeskripsiController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      hintText: 'Masukkan kata kunci deskripsi',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _resetFilter,
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          onPressed: _applyFilter,
                          child: const Text('Terapkan'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _logs.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _logs.length + 1, // +1 untuk tombol Load More
                      itemBuilder: (context, i) {
                  if (i == _logs.length) {
                    // tombol Load More
                    if (!_hasMore) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _fetchLogs,
                                child: const Text("Muat Lebih Banyak"),
                              ),
                      ),
                    );
                  }

                  final log = _logs[i];
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
                        title: Text(
                          log.deskripsi,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "Aktor: ${log.aktor}",
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              waktuText,
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.description, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text("Deskripsi: ${log.deskripsi}")),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text("Aktor: ${log.aktor}")),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.access_time, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text("Waktu: $waktuText")),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
          ],),
      ),
    );
  }
}


    // floatingActionButton: FloatingActionButton.extended(
    //   onPressed: _showTambahLog,
    //   icon: const Icon(Icons.add, color: Colors.white),
    //   label: const Text(
    //     "Tambah Log",
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    //   backgroundColor: AppStyles.primaryColor,
    // ),