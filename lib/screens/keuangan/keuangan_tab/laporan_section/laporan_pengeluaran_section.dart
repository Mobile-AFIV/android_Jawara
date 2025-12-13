import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/pengeluaran.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/screens/keuangan/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/pengeluaran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class LaporanPengeluaranSection extends StatefulWidget {
  const LaporanPengeluaranSection({super.key});

  @override
  State<LaporanPengeluaranSection> createState() =>
      _LaporanPengeluaranSectionState();
}

class _LaporanPengeluaranSectionState extends State<LaporanPengeluaranSection> {
  List<Pengeluaran> pengeluaranList = [];
  List<Pengeluaran> filteredPengeluaranList = [];
  bool isLoading = true;

  // Filter controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController dariTanggalController = TextEditingController();
  final TextEditingController sampaiTanggalController = TextEditingController();

  DateTime? dariTanggal;
  DateTime? sampaiTanggal;
  String? selectedKategori;
  List<String> kategoriList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    namaController.dispose();
    kategoriController.dispose();
    dariTanggalController.dispose();
    sampaiTanggalController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final pengeluaran = await PengeluaranService.instance.getAllPengeluaran();
      final kategori = PengeluaranService.instance.getAllKategoriPengeluaran();

      setState(() {
        pengeluaranList = pengeluaran;
        filteredPengeluaranList = pengeluaran;
        kategoriList = kategori;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _applyFilter() async {
    setState(() {
      isLoading = true;
    });

    try {
      final filtered =
          await PengeluaranService.instance.getPengeluaranWithFilter(
        nama: namaController.text.isEmpty ? null : namaController.text,
        kategori: selectedKategori,
        dariTanggal: dariTanggal,
        sampaiTanggal: sampaiTanggal,
      );

      setState(() {
        filteredPengeluaranList = filtered;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _resetFilter() {
    namaController.clear();
    kategoriController.clear();
    dariTanggalController.clear();
    sampaiTanggalController.clear();
    dariTanggal = null;
    sampaiTanggal = null;
    selectedKategori = null;

    setState(() {
      filteredPengeluaranList = pengeluaranList;
    });
  }

  String _formatDate(DateTime date, {String monthFormat = 'MMM'}) {
    return DateFormat('EEEE, d $monthFormat yyyy', 'id').format(date);
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Future<void> _showDetailPengeluaran(Pengeluaran pengeluaran) async {
    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (_) => [
        const Text(
          "Detail Pengeluaran",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "Nama Pengeluaran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          pengeluaran.nama,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 12),
        const Text(
          "Kategori",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          pengeluaran.kategori,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Tanggal Transaksi",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          _formatDate(pengeluaran.tanggal, monthFormat: "MMMM"),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Jumlah",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          _formatCurrency(pengeluaran.nominal),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Verifikator",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          pengeluaran.verifikator,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _showFilterModal() async {
    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (setModalState) => [
        const Text(
          "Filter Laporan Pengeluaran",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Filter by Nama
        const Text(
          "Nama",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        CustomTextField(
          controller: namaController,
          hintText: "Cari berdasarkan nama",
        ),
        const SizedBox(height: 16),

        // Filter by Kategori
        const Text(
          "Kategori",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        DropdownMenuTheme(
          data: DropdownMenuThemeData(
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          child: DropdownMenu<String>(
            menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
            ),
            trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up_rounded),
            controller: kategoriController,
            hintText: "Pilih kategori",
            width: MediaQuery.of(context).size.width - 64,
            requestFocusOnTap: false,
            dropdownMenuEntries: [
              const DropdownMenuEntry<String>(
                value: '',
                label: 'Semua Kategori',
              ),
              ...kategoriList.map((kategori) {
                return DropdownMenuEntry<String>(
                  value: kategori,
                  label: kategori,
                );
              }).toList(),
            ],
            onSelected: (value) {
              setModalState(() {
                selectedKategori = value?.isEmpty == true ? null : value;
              });
            },
          ),
        ),
        const SizedBox(height: 16),

        // Filter by Dari Tanggal
        const Text(
          "Dari Tanggal",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: dariTanggal ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              setModalState(() {
                dariTanggal = pickedDate;
                dariTanggalController.text = _formatDate(pickedDate);
              });
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: dariTanggalController,
              decoration: InputDecoration(
                hintText: "Pilih tanggal mulai",
                suffixIcon: const Icon(Icons.calendar_today),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Filter by Sampai Tanggal
        const Text(
          "Sampai Tanggal",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: sampaiTanggal ?? DateTime.now(),
              firstDate: dariTanggal ?? DateTime(2000),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              setModalState(() {
                sampaiTanggal = pickedDate;
                sampaiTanggalController.text = _formatDate(pickedDate);
              });
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: sampaiTanggalController,
              decoration: InputDecoration(
                hintText: "Pilih tanggal akhir",
                suffixIcon: const Icon(Icons.calendar_today),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _resetFilter();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: AppStyles.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Reset"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _applyFilter();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppStyles.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Terapkan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
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
          "Laporan Pengeluaran",
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: 6,
              itemBuilder: (context, index) => const ListItemShimmer(),
              separatorBuilder: (context, index) => Container(
                height: 1,
                width: double.maxFinite,
                color: Colors.grey.shade300,
              ),
            )
          : filteredPengeluaranList.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada data pengeluaran",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: filteredPengeluaranList.length,
                  itemBuilder: (context, index) {
                    return _pengeluaranItem(filteredPengeluaranList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1,
                      width: double.maxFinite,
                      color: Colors.grey.shade300,
                    );
                  },
                ),
    );
  }

  Widget _pengeluaranItem(Pengeluaran pengeluaran) {
    return InkWell(
      onTap: () => _showDetailPengeluaran(pengeluaran),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pengeluaran.kategori,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppStyles.primaryColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              pengeluaran.nama,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(pengeluaran.tanggal),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatCurrency(pengeluaran.nominal),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
