import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/pemasukan.dart';
import 'package:jawara_pintar/models/pengeluaran.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/services/pemasukan_service.dart';
import 'package:jawara_pintar/services/pengeluaran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CetakLaporanSection extends StatefulWidget {
  const CetakLaporanSection({super.key});

  @override
  State<CetakLaporanSection> createState() => _CetakLaporanSectionState();
}

class _CetakLaporanSectionState extends State<CetakLaporanSection> {
  final TextEditingController tanggalMulaiController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController jenisLaporanController = TextEditingController();

  DateTime? tanggalMulai;
  DateTime? tanggalAkhir;
  String? jenisLaporan = 'Semua';

  bool isGenerating = false;

  final List<String> jenisLaporanList = ['Semua', 'Pemasukan', 'Pengeluaran'];

  @override
  void dispose() {
    tanggalMulaiController.dispose();
    tanggalAkhirController.dispose();
    jenisLaporanController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id').format(date);
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _reset() {
    setState(() {
      tanggalMulaiController.clear();
      tanggalAkhirController.clear();
      jenisLaporanController.clear();
      tanggalMulai = null;
      tanggalAkhir = null;
      jenisLaporan = 'Semua';
    });
  }

  Future<void> _generatePDF() async {
    if (tanggalMulai == null || tanggalAkhir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap pilih tanggal mulai dan tanggal akhir'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (tanggalMulai!.isAfter(tanggalAkhir!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Tanggal mulai tidak boleh lebih besar dari tanggal akhir'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isGenerating = true;
    });

    try {
      List<Pemasukan> pemasukanList = [];
      List<Pengeluaran> pengeluaranList = [];

      // Fetch data sesuai jenis laporan
      if (jenisLaporan == 'Semua' || jenisLaporan == 'Pemasukan') {
        pemasukanList = await PemasukanService.instance.getPemasukanWithFilter(
          dariTanggal: tanggalMulai,
          sampaiTanggal: tanggalAkhir,
        );
      }

      if (jenisLaporan == 'Semua' || jenisLaporan == 'Pengeluaran') {
        pengeluaranList =
            await PengeluaranService.instance.getPengeluaranWithFilter(
          dariTanggal: tanggalMulai,
          sampaiTanggal: tanggalAkhir,
        );
      }

      // Generate PDF
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'LAPORAN KEUANGAN',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Jenis Laporan: $jenisLaporan',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Periode: ${DateFormat('dd MMMM yyyy', 'id').format(tanggalMulai!)} - ${DateFormat('dd MMMM yyyy', 'id').format(tanggalAkhir!)}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),

              // Pemasukan Section
              if (jenisLaporan == 'Semua' || jenisLaporan == 'Pemasukan') ...[
                pw.Text(
                  'PEMASUKAN',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                if (pemasukanList.isEmpty)
                  pw.Text('Tidak ada data pemasukan')
                else
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey400),
                    children: [
                      // Header
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey300,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'No',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Tanggal',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Nama',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Kategori',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Nominal',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      // Data rows
                      ...pemasukanList.asMap().entries.map(
                            (entry) => pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('${entry.key + 1}'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(entry.value.tanggal),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(entry.value.nama),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(entry.value.kategori),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                    _formatCurrency(entry.value.nominal),
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      // Total
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey200,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'TOTAL',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              _formatCurrency(
                                pemasukanList.fold<int>(
                                  0,
                                  (sum, item) => sum + item.nominal,
                                ),
                              ),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                pw.SizedBox(height: 24),
              ],

              // Pengeluaran Section
              if (jenisLaporan == 'Semua' || jenisLaporan == 'Pengeluaran') ...[
                pw.Text(
                  'PENGELUARAN',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                if (pengeluaranList.isEmpty)
                  pw.Text('Tidak ada data pengeluaran')
                else
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey400),
                    children: [
                      // Header
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey300,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'No',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Tanggal',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Nama',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Kategori',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Nominal',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      // Data rows
                      ...pengeluaranList.asMap().entries.map(
                            (entry) => pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('${entry.key + 1}'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(entry.value.tanggal),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(entry.value.nama),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(entry.value.kategori),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                    _formatCurrency(entry.value.nominal),
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      // Total
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey200,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'TOTAL',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              _formatCurrency(
                                pengeluaranList.fold<int>(
                                  0,
                                  (sum, item) => sum + item.nominal,
                                ),
                              ),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                pw.SizedBox(height: 24),
              ],

              // Summary jika Semua
              if (jenisLaporan == 'Semua' &&
                  (pemasukanList.isNotEmpty || pengeluaranList.isNotEmpty)) ...[
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 12),
                pw.Text(
                  'RINGKASAN',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Pemasukan:'),
                    pw.Text(
                      _formatCurrency(
                        pemasukanList.fold<int>(
                            0, (sum, item) => sum + item.nominal),
                      ),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Pengeluaran:'),
                    pw.Text(
                      _formatCurrency(
                        pengeluaranList.fold<int>(
                            0, (sum, item) => sum + item.nominal),
                      ),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Saldo:',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      _formatCurrency(
                        pemasukanList.fold<int>(
                                0, (sum, item) => sum + item.nominal) -
                            pengeluaranList.fold<int>(
                                0, (sum, item) => sum + item.nominal),
                      ),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],

              // Footer
              pw.SizedBox(height: 40),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Dicetak pada: ${DateFormat('dd MMMM yyyy HH:mm', 'id').format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      // Show PDF preview
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      setState(() {
        isGenerating = false;
      });
    } catch (e) {
      setState(() {
        isGenerating = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Cetak Laporan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cetak Laporan Keuangan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Tanggal Mulai
              const Text(
                "Tanggal Mulai",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: tanggalMulai ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      tanggalMulai = pickedDate;
                      tanggalMulaiController.text = _formatDate(pickedDate);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: tanggalMulaiController,
                    decoration: InputDecoration(
                      hintText: "Pilih tanggal mulai",
                      suffixIcon: const Icon(Icons.calendar_today),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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

              // Tanggal Akhir
              const Text(
                "Tanggal Akhir",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: tanggalAkhir ?? DateTime.now(),
                    firstDate: tanggalMulai ?? DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      tanggalAkhir = pickedDate;
                      tanggalAkhirController.text = _formatDate(pickedDate);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: tanggalAkhirController,
                    decoration: InputDecoration(
                      hintText: "Pilih tanggal akhir",
                      suffixIcon: const Icon(Icons.calendar_today),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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

              // Jenis Laporan
              const Text(
                "Jenis Laporan",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              DropdownMenuTheme(
                data: DropdownMenuThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                  selectedTrailingIcon:
                      const Icon(Icons.keyboard_arrow_up_rounded),
                  controller: jenisLaporanController,
                  hintText: "Pilih jenis laporan",
                  width: double.maxFinite,
                  requestFocusOnTap: false,
                  initialSelection: jenisLaporan,
                  dropdownMenuEntries: jenisLaporanList.map((jenis) {
                    return DropdownMenuEntry<String>(
                      value: jenis,
                      label: jenis,
                    );
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      jenisLaporan = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _reset,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: AppStyles.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: AppStyles.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      onPressed: isGenerating ? null : _generatePDF,
                      customBackgroundColor: AppStyles.primaryColor,
                      child: isGenerating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Download PDF",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
