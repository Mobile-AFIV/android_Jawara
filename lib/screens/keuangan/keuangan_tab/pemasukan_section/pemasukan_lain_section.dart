import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/pemasukan.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/screens/keuangan/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/pemasukan_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class PemasukanLainSection extends StatefulWidget {
  const PemasukanLainSection({super.key});

  @override
  State<PemasukanLainSection> createState() => _PemasukanLainSectionState();
}

class _PemasukanLainSectionState extends State<PemasukanLainSection> {
  List<Pemasukan> pemasukanList = [];
  List<Pemasukan> filteredPemasukanList = [];
  bool isLoading = true;

  // Filter parameters
  String? filterNama;
  String? filterKategori;
  DateTime? filterDariTanggal;
  DateTime? filterSampaiTanggal;

  final List<String> kategoriList = [
    "Donasi",
    "Dana Bantuan Pemerintah",
    "Sumbangan Swadaya",
    "Hasil Usaha Kampung",
    "Pendapatan Lainnya",
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      final allData = await PemasukanService.instance.getAllPemasukan();

      // Filter manual (karena Firestore query limited)
      var filtered = allData;

      if (filterNama != null && filterNama!.isNotEmpty) {
        filtered = filtered
            .where(
                (p) => p.nama.toLowerCase().contains(filterNama!.toLowerCase()))
            .toList();
      }

      if (filterKategori != null && filterKategori!.isNotEmpty) {
        filtered = filtered.where((p) => p.kategori == filterKategori).toList();
      }

      if (filterDariTanggal != null) {
        filtered = filtered
            .where((p) =>
                p.tanggal.isAfter(filterDariTanggal!) ||
                p.tanggal.isAtSameMomentAs(filterDariTanggal!))
            .toList();
      }

      if (filterSampaiTanggal != null) {
        filtered = filtered
            .where((p) =>
                p.tanggal.isBefore(filterSampaiTanggal!) ||
                p.tanggal.isAtSameMomentAs(filterSampaiTanggal!))
            .toList();
      }

      setState(() {
        pemasukanList = allData;
        filteredPemasukanList = filtered;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatCurrency(int amount) {
    return 'Rp${NumberFormat('#,###', 'id_ID').format(amount)}';
  }

  String _formatDate(DateTime date, {String monthFormat = 'MMM'}) {
    return DateFormat('EEEE, d $monthFormat yyyy', 'id').format(date);
  }

  Future<void> _showFilterModal() async {
    String? tempFilterNama = filterNama;
    String? tempFilterKategori = filterKategori;
    DateTime? tempDariTanggal = filterDariTanggal;
    DateTime? tempSampaiTanggal = filterSampaiTanggal;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Pemasukan Non Iuran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Filter Nama
                  const Text('Nama',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  TextField(
                    onChanged: (value) => tempFilterNama = value,
                    controller: TextEditingController(text: tempFilterNama),
                    decoration: InputDecoration(
                      hintText: 'Cari nama...',
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Kategori
                  const Text('Kategori',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: tempFilterKategori,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    hint: const Text('Pilih kategori'),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('Semua Kategori')),
                      ...kategoriList.map((k) {
                        return DropdownMenuItem(value: k, child: Text(k));
                      }),
                    ],
                    onChanged: (value) {
                      setModalState(() => tempFilterKategori = value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Filter Dari Tanggal
                  const Text('Dari Tanggal',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempDariTanggal ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        locale: const Locale('id', 'ID'),
                      );
                      if (picked != null) {
                        setModalState(() => tempDariTanggal = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tempDariTanggal != null
                                ? DateFormat('d MMMM yyyy', 'id')
                                    .format(tempDariTanggal!)
                                : 'Pilih tanggal',
                            style: TextStyle(
                              color: tempDariTanggal != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          const Icon(Icons.calendar_today, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Sampai Tanggal
                  const Text('Sampai Tanggal',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempSampaiTanggal ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        locale: const Locale('id', 'ID'),
                      );
                      if (picked != null) {
                        setModalState(() => tempSampaiTanggal = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tempSampaiTanggal != null
                                ? DateFormat('d MMMM yyyy', 'id')
                                    .format(tempSampaiTanggal!)
                                : 'Pilih tanggal',
                            style: TextStyle(
                              color: tempSampaiTanggal != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          const Icon(Icons.calendar_today, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              filterNama = null;
                              filterKategori = null;
                              filterDariTanggal = null;
                              filterSampaiTanggal = null;
                            });
                            _loadData();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: const Text('Reset Filter'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            setState(() {
                              filterNama = tempFilterNama;
                              filterKategori = tempFilterKategori;
                              filterDariTanggal = tempDariTanggal;
                              filterSampaiTanggal = tempSampaiTanggal;
                            });
                            _loadData();
                            Navigator.pop(context);
                          },
                          child: const Text('Terapkan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDetailPemasukanLain(Pemasukan data) async {
    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (_) => [
        const Text(
          "Detail Pemasukan",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "Nama Pemasukan",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.nama,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 12),
        const Text(
          "Kategori",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.kategori,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Tanggal Transaksi",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          _formatDate(data.tanggal, monthFormat: "MMMM"),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Jumlah",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          _formatCurrency(data.nominal),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Verifikator",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.verifikator,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),

        // Bukti Image
        if (data.buktiUrl != null && data.buktiUrl!.isNotEmpty) ...[
          const Text(
            "Bukti Pemasukan",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              data.buktiUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Gagal memuat gambar',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Pemasukan Lain",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AppBarActionButton.filter(onTap: _showFilterModal),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      body: isLoading
          ? ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
              itemBuilder: (context, index) => const ListItemShimmer(),
              separatorBuilder: (context, index) => Container(
                height: 1,
                width: double.maxFinite,
                color: Colors.grey.shade300,
              ),
            )
          : filteredPemasukanList.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada data pemasukan',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPemasukanList.length,
                  itemBuilder: (context, index) {
                    return pemasukanLainItem(
                      filteredPemasukanList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1,
                      width: double.maxFinite,
                      color: Colors.grey.shade300,
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppStyles.primaryColor,
        onPressed: () {
          context.pushNamed('tambah_pemasukan_lain');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget pemasukanLainItem(Pemasukan itemData) {
    return InkWell(
      onTap: () => _showDetailPemasukanLain(itemData),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              overflow: TextOverflow.ellipsis,
              itemData.kategori,
              style: const TextStyle(
                fontSize: 12,
                color: AppStyles.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              overflow: TextOverflow.ellipsis,
              itemData.nama,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatCurrency(itemData.nominal),
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  _formatDate(itemData.tanggal),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
