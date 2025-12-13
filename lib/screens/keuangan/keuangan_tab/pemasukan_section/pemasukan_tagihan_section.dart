import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/kategori_iuran.dart';
import 'package:jawara_pintar/models/tagihan_iuran.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/widget/filter_tagihan_modal.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/screens/keuangan/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/kategori_iuran_service.dart';
import 'package:jawara_pintar/services/tagihan_iuran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PemasukanTagihanSection extends StatefulWidget {
  const PemasukanTagihanSection({super.key});

  @override
  State<PemasukanTagihanSection> createState() =>
      _PemasukanTagihanSectionState();
}

class _PemasukanTagihanSectionState extends State<PemasukanTagihanSection> {
  final TextEditingController kategoriIuranMenu = TextEditingController();
  final TextEditingController tanggalTagihanController =
      TextEditingController();

  List<TagihanIuran> tagihanList = [];
  List<TagihanIuran> filteredTagihanList = [];
  bool isLoading = true;
  bool isCreating = false;

  // Filter parameters
  StatusPembayaran? filterStatusPembayaran;
  StatusKeluargaTagihan? filterStatusKeluarga;
  String? filterNamaKeluarga;
  String? filterKategoriIuran;
  DateTime? filterPeriode;

  String? selectedKategoriIuranId;

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
      final data = await TagihanIuranService.instance.getTagihanWithFilter(
        statusPembayaran: filterStatusPembayaran,
        statusKeluarga: filterStatusKeluarga,
        namaKeluarga: filterNamaKeluarga,
        kategoriIuran: filterKategoriIuran,
        periode: filterPeriode,
      );

      if (!mounted) return;

      setState(() {
        tagihanList = data;
        filteredTagihanList = data;
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

  Future<void> _showFilterModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterTagihanModal(
        initialStatusPembayaran: filterStatusPembayaran,
        initialStatusKeluarga: filterStatusKeluarga,
        initialNamaKeluarga: filterNamaKeluarga,
        initialKategoriIuran: filterKategoriIuran,
        initialPeriode: filterPeriode,
        onApply: ({
          StatusPembayaran? statusPembayaran,
          StatusKeluargaTagihan? statusKeluarga,
          String? namaKeluarga,
          String? kategoriIuran,
          DateTime? periode,
        }) {
          // Kemudian update state dan reload jika masih mounted
          if (mounted) {
            setState(() {
              filterStatusPembayaran = statusPembayaran;
              filterStatusKeluarga = statusKeluarga;
              filterNamaKeluarga = namaKeluarga;
              filterKategoriIuran = kategoriIuran;
              filterPeriode = periode;
            });
            _loadData();
          }
        },
      ),
    );
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text(
              'Laporan Tagihan Iuran',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Dicetak: ${DateFormat('d MMMM yyyy HH:mm', 'id').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['No', 'Nama KK', 'Kategori', 'Nominal', 'Status'],
              data: List.generate(
                filteredTagihanList.length,
                (index) {
                  final tagihan = filteredTagihanList[index];
                  return [
                    '${index + 1}',
                    tagihan.namaKeluarga,
                    tagihan.kategoriIuran,
                    'Rp${NumberFormat('#,###', 'id_ID').format(tagihan.nominal)}',
                    tagihan.statusPembayaran.label,
                  ];
                },
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _showTambahTagihan() async {
    kategoriIuranMenu.clear();
    tanggalTagihanController.clear();
    DateTime? selectedDate;

    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (setModalState) => [
        const Text(
          "Tagih iuran \nke semua keluarga aktif",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "Kategori Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        FutureBuilder<List<KategoriIuran>>(
          future: KategoriIuranService.instance.getAllKategori(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final kategoriList = snapshot.data!;

            return DropdownMenuTheme(
              data: DropdownMenuThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: const TextStyle(color: Colors.grey),
                  focusColor: AppStyles.primaryColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
              ),
              child: DropdownMenu<KategoriIuran>(
                menuStyle: MenuStyle(
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                  maximumSize: WidgetStatePropertyAll(
                    Size(MediaQuery.sizeOf(context).width - 24, 200),
                  ),
                  padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 12)),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                selectedTrailingIcon:
                    const Icon(Icons.keyboard_arrow_up_rounded),
                controller: kategoriIuranMenu,
                hintText: "Pilih kategori iuran",
                width: double.maxFinite,
                requestFocusOnTap: false,
                dropdownMenuEntries: kategoriList.map((kategori) {
                  return DropdownMenuEntry<KategoriIuran>(
                    value: kategori,
                    label: kategori.nama,
                  );
                }).toList(),
                onSelected: (value) {
                  setModalState(() {
                    if (value == null) {
                      kategoriIuranMenu.clear();
                      selectedKategoriIuranId = null;
                      return;
                    }
                    kategoriIuranMenu.text = value.nama;
                    selectedKategoriIuranId = value.id;
                  });
                },
                closeBehavior: DropdownMenuCloseBehavior.all,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        const Text(
          "Tanggal Tagihan",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: kategoriIuranMenu.text.isNotEmpty
              ? () async {
                  FocusScope.of(context).unfocus();
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    locale: const Locale('id', 'ID'),
                  );

                  if (pickedDate != null) {
                    setModalState(() {
                      selectedDate = pickedDate;
                      tanggalTagihanController.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    });
                  }
                }
              : null,
          child: AbsorbPointer(
            child: TextField(
              controller: tanggalTagihanController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Pilih tanggal",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixIcon: const Icon(Icons.calendar_today_rounded,
                    color: Colors.grey, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: AppStyles.primaryColor, width: 1.5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: isCreating
                    ? null
                    : () async {
                        if (kategoriIuranMenu.text.isEmpty ||
                            selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua field harus diisi'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isCreating = true;
                        });

                        try {
                          // Ambil data kategori untuk mendapatkan nominal
                          final kategoriList = await KategoriIuranService
                              .instance
                              .getAllKategori();
                          final selectedKategori = kategoriList.firstWhere(
                            (k) => k.id == selectedKategoriIuranId,
                          );

                          print('DEBUG: Creating tagihan with:');
                          print('- Kategori: ${selectedKategori.nama}');
                          print('- ID Kategori: ${selectedKategori.id}');
                          print('- Nominal: ${selectedKategori.nominal}');
                          print('- Periode: $selectedDate');

                          final createdIds = await TagihanIuranService.instance
                              .createTagihanBulkKeluargaAktif(
                            kategoriIuran: selectedKategori.nama,
                            idKategoriIuran: selectedKategori.id,
                            nominal: selectedKategori.nominal,
                            periode: selectedDate!,
                          );

                          print('DEBUG: Created ${createdIds.length} tagihan');

                          if (!mounted) return;

                          setState(() {
                            isCreating = false;
                          });

                          if (mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Berhasil membuat ${createdIds.length} tagihan'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            await _loadData();
                          }
                        } catch (e, stackTrace) {
                          print('DEBUG ERROR: $e');
                          print('DEBUG STACK: $stackTrace');

                          if (!mounted) return;

                          setState(() {
                            isCreating = false;
                          });

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                      },
                child: isCreating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text("Simpan"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                customBackgroundColor: AppStyles.errorColor,
                onPressed: () {
                  context.pop();
                },
                child: const Text("Batal"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCurrency(int amount) {
    return 'Rp${NumberFormat('#,###', 'id_ID').format(amount)}';
  }

  Color _getStatusColor(StatusPembayaran status) {
    switch (status) {
      case StatusPembayaran.belum:
        return Colors.grey;
      case StatusPembayaran.menunggu:
        return AppStyles.warningOnSurfaceColor;
      case StatusPembayaran.diterima:
        return AppStyles.successColor;
      case StatusPembayaran.ditolak:
        return AppStyles.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Tagihan Iuran",
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
      body: SafeArea(
        child: isLoading
            ? ListView.separated(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 88),
                itemCount: 6,
                itemBuilder: (context, index) => const TagihanItemShimmer(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              )
            : filteredTagihanList.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Belum ada tagihan.\nBuat tagihan baru dengan menekan tombol +',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 88),
                    itemCount: filteredTagihanList.length,
                    itemBuilder: (context, index) {
                      return tagihanItemData(filteredTagihanList[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 12);
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppStyles.primaryColor,
        onPressed: _showTambahTagihan,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget tagihanItemData(TagihanIuran tagihan) {
    final statusColor = _getStatusColor(tagihan.statusPembayaran);
    final statusKeluargaColor =
        tagihan.statusKeluarga == StatusKeluargaTagihan.aktif
            ? AppStyles.successColor
            : AppStyles.errorColor;

    return InkWell(
      onTap: () {
        context.pushNamed(
          'detail_tagihan',
          pathParameters: {'tagihanId': tagihan.id},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Keluarga
            Text(
              tagihan.namaKeluarga,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Status Keluarga
            Row(
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: statusKeluargaColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  tagihan.statusKeluarga.label,
                  style: TextStyle(fontSize: 12, color: statusKeluargaColor),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Kategori Iuran
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.grey, size: 14),
                const SizedBox(width: 8),
                Text(
                  "Iuran ${tagihan.kategoriIuran}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Nominal & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatCurrency(tagihan.nominal),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tagihan.statusPembayaran == StatusPembayaran.ditolak
                        ? Colors.grey
                        : Colors.black,
                    decoration:
                        tagihan.statusPembayaran == StatusPembayaran.ditolak
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    tagihan.statusPembayaran.label,
                    style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.bold),
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
