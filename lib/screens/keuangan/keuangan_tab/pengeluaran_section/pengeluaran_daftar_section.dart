import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/pengeluaran.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/screens/keuangan/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/pengeluaran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PengeluaranDaftarSection extends StatefulWidget {
  const PengeluaranDaftarSection({super.key});

  @override
  State<PengeluaranDaftarSection> createState() =>
      _PengeluaranDaftarSectionState();
}

class _PengeluaranDaftarSectionState extends State<PengeluaranDaftarSection> {
  List<Pengeluaran> pengeluaranList = [];
  List<Pengeluaran> filteredPengeluaranList = [];
  bool isLoading = true;

  // Filter controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _dariTanggalController = TextEditingController();
  final TextEditingController _sampaiTanggalController =
      TextEditingController();

  // Filter data
  DateTime? _dariTanggal;
  DateTime? _sampaiTanggal;

  final List<String> kategoriPengeluaranList = [
    'Operasional RT/RW',
    'Kegiatan Sosial',
    'Pemeliharaan Fasilitas',
    'Pembangunan',
    'Kegiatan Warga',
    'Keamanan dan Kebersihan',
    'Lain-lain',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _kategoriController.dispose();
    _dariTanggalController.dispose();
    _sampaiTanggalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await PengeluaranService.instance.getAllPengeluaran();
      if (!mounted) return;

      setState(() {
        pengeluaranList = data;
        filteredPengeluaranList = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
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

  void _applyFilter() {
    setState(() {
      filteredPengeluaranList = pengeluaranList.where((pengeluaran) {
        // Filter by nama
        if (_namaController.text.isNotEmpty) {
          if (!pengeluaran.nama
              .toLowerCase()
              .contains(_namaController.text.toLowerCase())) {
            return false;
          }
        }

        // Filter by kategori
        if (_kategoriController.text.isNotEmpty) {
          if (pengeluaran.kategori != _kategoriController.text) {
            return false;
          }
        }

        // Filter by dari tanggal
        if (_dariTanggal != null) {
          if (pengeluaran.tanggal.isBefore(_dariTanggal!)) {
            return false;
          }
        }

        // Filter by sampai tanggal
        if (_sampaiTanggal != null) {
          if (pengeluaran.tanggal.isAfter(_sampaiTanggal!)) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _resetFilter() {
    setState(() {
      _namaController.clear();
      _kategoriController.clear();
      _dariTanggalController.clear();
      _sampaiTanggalController.clear();
      _dariTanggal = null;
      _sampaiTanggal = null;
      filteredPengeluaranList = pengeluaranList;
    });
  }

  Future<void> _exportToPdf() async {
    if (filteredPengeluaranList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data untuk diekspor'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final pdf = pw.Document();

    // Hitung total pengeluaran
    final totalPengeluaran = filteredPengeluaranList.fold<int>(
      0,
      (sum, item) => sum + item.nominal,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text(
              'Laporan Pengeluaran',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Dicetak: ${DateFormat('d MMMM yyyy HH:mm', 'id').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            if (_namaController.text.isNotEmpty ||
                _kategoriController.text.isNotEmpty ||
                _dariTanggal != null ||
                _sampaiTanggal != null) ...[
              pw.SizedBox(height: 10),
              pw.Text(
                'Filter Aktif:',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              if (_namaController.text.isNotEmpty)
                pw.Text(
                  '- Nama: ${_namaController.text}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              if (_kategoriController.text.isNotEmpty)
                pw.Text(
                  '- Kategori: ${_kategoriController.text}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              if (_dariTanggal != null)
                pw.Text(
                  '- Dari Tanggal: ${DateFormat('dd/MM/yyyy').format(_dariTanggal!)}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              if (_sampaiTanggal != null)
                pw.Text(
                  '- Sampai Tanggal: ${DateFormat('dd/MM/yyyy').format(_sampaiTanggal!)}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
            ],
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
              ),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.centerLeft,
              headers: ['No', 'Nama', 'Kategori', 'Tanggal', 'Nominal'],
              data: List.generate(
                filteredPengeluaranList.length,
                (index) {
                  final pengeluaran = filteredPengeluaranList[index];
                  return [
                    '${index + 1}',
                    pengeluaran.nama,
                    pengeluaran.kategori,
                    DateFormat('dd/MM/yyyy').format(pengeluaran.tanggal),
                    'Rp${NumberFormat('#,###', 'id_ID').format(pengeluaran.nominal)}',
                  ];
                },
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total Pengeluaran:',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Rp${NumberFormat('#,###', 'id_ID').format(totalPengeluaran)}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Jumlah Data: ${filteredPengeluaranList.length} pengeluaran',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _showFilterModal() async {
    await ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (setModalState) => [
        const Text(
          "Filter Pengeluaran",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "Nama",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        CustomTextField(
          controller: _namaController,
          hintText: "Cari Nama...",
        ),
        const SizedBox(height: 12),
        const Text(
          "Kategori",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        DropdownMenuTheme(
          data: DropdownMenuThemeData(
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: const TextStyle(color: Colors.grey),
              focusColor: AppStyles.primaryColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
          ),
          child: DropdownMenu<String>(
            menuStyle: MenuStyle(
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              maximumSize: WidgetStatePropertyAll(
                Size(MediaQuery.sizeOf(context).width - 24, 200),
              ),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(vertical: 12),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up_rounded),
            controller: _kategoriController,
            hintText: "Pilih kategori",
            width: double.maxFinite,
            requestFocusOnTap: false,
            dropdownMenuEntries: kategoriPengeluaranList.map((kategori) {
              return DropdownMenuEntry(value: kategori, label: kategori);
            }).toList(),
            onSelected: (value) {
              setModalState(() {
                if (value == null) {
                  _kategoriController.clear();
                  return;
                }
                _kategoriController.text = value;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Dari Tanggal",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _dariTanggal ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setModalState(() {
                _dariTanggal = pickedDate;
                _dariTanggalController.text =
                    DateFormat('dd/MM/yyyy').format(pickedDate);
              });
            }
          },
          child: IgnorePointer(
            child: CustomTextField(
              controller: _dariTanggalController,
              enabled: true,
              hintText: "Pilih tanggal",
              suffixIcon: const Icon(Icons.calendar_today, size: 20),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Sampai Tanggal",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _sampaiTanggal ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setModalState(() {
                _sampaiTanggal = pickedDate;
                _sampaiTanggalController.text =
                    DateFormat('dd/MM/yyyy').format(pickedDate);
              });
            }
          },
          child: IgnorePointer(
            child: CustomTextField(
              controller: _sampaiTanggalController,
              enabled: true,
              hintText: "Pilih tanggal",
              suffixIcon: const Icon(Icons.calendar_today, size: 20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                customBackgroundColor: Colors.grey.shade200,
                onPressed: () {
                  _resetFilter();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Reset Filter",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilter();
                },
                child: const Text("Terapkan"),
              ),
            ),
          ],
        ),
      ],
    );
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

  // Data dummy (dicomment)
  // final List<PengeluaranData> pengeluaran = List.generate(
  //   PengeluaranSectionData.pengeluaranData.length,
  //   (index) {
  //     return PengeluaranData.fromJson(
  //       PengeluaranSectionData.pengeluaranData[index],
  //     );
  //   },
  // );

  Future<void> _showDetailPengeluaran(Pengeluaran data) async {
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
          "Verfikator",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.verifikator,
          style: const TextStyle(fontSize: 16),
        ),
        if (data.buktiUrl != null) ...[
          const SizedBox(height: 12),
          const Text(
            "Bukti Pengeluaran",
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
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget pengeluaranItemData(Pengeluaran itemData) {
    return InkWell(
      onTap: () => _showDetailPengeluaran(itemData),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Pengeluaran",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AppBarActionButton.filter(onTap: _showFilterModal),
          const SizedBox(width: 8),
          AppBarActionButton.pdfDownload(onTap: _exportToPdf),
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
          : pengeluaranList.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada data pengeluaran',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : filteredPengeluaranList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak ada data yang sesuai',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Coba ubah filter pencarian',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            onPressed: () {
                              _resetFilter();
                            },
                            child: const Text('Reset Filter'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredPengeluaranList.length,
                        itemBuilder: (context, index) {
                          return pengeluaranItemData(
                              filteredPengeluaranList[index]);
                        },
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 1,
                            width: double.maxFinite,
                            color: Colors.grey.shade300,
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppStyles.primaryColor,
        onPressed: () {
          context.pushNamed('tambah_pengeluaran').then((_) {
            // Reload data setelah kembali dari tambah pengeluaran
            _loadData();
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Data dummy (dicomment)
// class PengeluaranData {
//   final int no;
//   final String nama;
//   final String jenisPengeluaran;
//   final String tanggal;
//   final int nominal;
//   final String verifikator;

//   PengeluaranData({
//     required this.no,
//     required this.nama,
//     required this.jenisPengeluaran,
//     required this.tanggal,
//     required this.nominal,
//     required this.verifikator,
//   });

//   factory PengeluaranData.fromJson(Map<String, dynamic> json) {
//     return PengeluaranData(
//       no: json['no'],
//       nama: json['nama'],
//       jenisPengeluaran: json['jenisPengeluaran'],
//       tanggal: json['tanggal'],
//       nominal: json['nominal'],
//       verifikator: json['verifikator'],
//     );
//   }
// }
