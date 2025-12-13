import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/kategori_iuran.dart';
import 'package:jawara_pintar/models/tagihan_iuran.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/services/kategori_iuran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterTagihanModal extends StatefulWidget {
  final StatusPembayaran? initialStatusPembayaran;
  final StatusKeluargaTagihan? initialStatusKeluarga;
  final String? initialNamaKeluarga;
  final String? initialKategoriIuran;
  final DateTime? initialPeriode;
  final Function({
    StatusPembayaran? statusPembayaran,
    StatusKeluargaTagihan? statusKeluarga,
    String? namaKeluarga,
    String? kategoriIuran,
    DateTime? periode,
  }) onApply;

  const FilterTagihanModal({
    super.key,
    this.initialStatusPembayaran,
    this.initialStatusKeluarga,
    this.initialNamaKeluarga,
    this.initialKategoriIuran,
    this.initialPeriode,
    required this.onApply,
  });

  @override
  State<FilterTagihanModal> createState() => _FilterTagihanModalState();
}

class _FilterTagihanModalState extends State<FilterTagihanModal> {
  StatusPembayaran? selectedStatusPembayaran;
  StatusKeluargaTagihan? selectedStatusKeluarga;
  String? selectedNamaKeluarga;
  String? selectedKategoriIuran;
  DateTime? selectedPeriode;

  final TextEditingController statusPembayaranController =
      TextEditingController();
  final TextEditingController statusKeluargaController =
      TextEditingController();
  final TextEditingController namaKeluargaController = TextEditingController();
  final TextEditingController kategoriIuranController = TextEditingController();
  final TextEditingController periodeController = TextEditingController();

  List<String> namaKeluargaList = [];
  List<KategoriIuran> kategoriIuranList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedStatusPembayaran = widget.initialStatusPembayaran;
    selectedStatusKeluarga = widget.initialStatusKeluarga;
    selectedNamaKeluarga = widget.initialNamaKeluarga;
    selectedKategoriIuran = widget.initialKategoriIuran;
    selectedPeriode = widget.initialPeriode;

    if (selectedStatusPembayaran != null) {
      statusPembayaranController.text = selectedStatusPembayaran!.label;
    }
    if (selectedStatusKeluarga != null) {
      statusKeluargaController.text = selectedStatusKeluarga!.label;
    }
    if (selectedNamaKeluarga != null) {
      namaKeluargaController.text = selectedNamaKeluarga!;
    }
    if (selectedKategoriIuran != null) {
      kategoriIuranController.text = selectedKategoriIuran!;
    }
    if (selectedPeriode != null) {
      periodeController.text =
          DateFormat('MMMM yyyy', 'id').format(selectedPeriode!);
    }

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load keluarga
      final keluargaSnapshot = await FirebaseFirestore.instance
          .collection('warga')
          .orderBy('name')
          .get();

      namaKeluargaList = keluargaSnapshot.docs
          .map((doc) => doc.data()['name'] as String)
          .toList();

      // Load kategori iuran
      kategoriIuranList = await KategoriIuranService.instance.getAllKategori();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _reset() {
    setState(() {
      selectedStatusPembayaran = null;
      selectedStatusKeluarga = null;
      selectedNamaKeluarga = null;
      selectedKategoriIuran = null;
      selectedPeriode = null;

      statusPembayaranController.clear();
      statusKeluargaController.clear();
      namaKeluargaController.clear();
      kategoriIuranController.clear();
      periodeController.clear();
    });
  }

  void _apply() {
    widget.onApply(
      statusPembayaran: selectedStatusPembayaran,
      statusKeluarga: selectedStatusKeluarga,
      namaKeluarga: selectedNamaKeluarga,
      kategoriIuran: selectedKategoriIuran,
      periode: selectedPeriode,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Tagihan Warga",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Status Pembayaran
                  const Text(
                    "Status Pembayaran",
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
                    child: DropdownMenu<StatusPembayaran>(
                      menuStyle: MenuStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      trailingIcon:
                          const Icon(Icons.keyboard_arrow_down_rounded),
                      selectedTrailingIcon:
                          const Icon(Icons.keyboard_arrow_up_rounded),
                      controller: statusPembayaranController,
                      hintText: "Pilih status pembayaran",
                      width: double.maxFinite,
                      requestFocusOnTap: false,
                      initialSelection: selectedStatusPembayaran,
                      dropdownMenuEntries:
                          StatusPembayaran.values.map((status) {
                        return DropdownMenuEntry<StatusPembayaran>(
                          value: status,
                          label: status.label,
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedStatusPembayaran = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status Keluarga
                  const Text(
                    "Status Keluarga",
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
                    child: DropdownMenu<StatusKeluargaTagihan>(
                      menuStyle: MenuStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      trailingIcon:
                          const Icon(Icons.keyboard_arrow_down_rounded),
                      selectedTrailingIcon:
                          const Icon(Icons.keyboard_arrow_up_rounded),
                      controller: statusKeluargaController,
                      hintText: "Pilih status keluarga",
                      width: double.maxFinite,
                      requestFocusOnTap: false,
                      initialSelection: selectedStatusKeluarga,
                      dropdownMenuEntries:
                          StatusKeluargaTagihan.values.map((status) {
                        return DropdownMenuEntry<StatusKeluargaTagihan>(
                          value: status,
                          label: status.label,
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedStatusKeluarga = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Keluarga
                  const Text(
                    "Keluarga",
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
                      trailingIcon:
                          const Icon(Icons.keyboard_arrow_down_rounded),
                      selectedTrailingIcon:
                          const Icon(Icons.keyboard_arrow_up_rounded),
                      controller: namaKeluargaController,
                      hintText: "Pilih keluarga",
                      width: double.maxFinite,
                      requestFocusOnTap: false,
                      dropdownMenuEntries: namaKeluargaList.map((nama) {
                        return DropdownMenuEntry<String>(
                          value: nama,
                          label: nama,
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedNamaKeluarga = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Iuran
                  const Text(
                    "Iuran",
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
                      trailingIcon:
                          const Icon(Icons.keyboard_arrow_down_rounded),
                      selectedTrailingIcon:
                          const Icon(Icons.keyboard_arrow_up_rounded),
                      controller: kategoriIuranController,
                      hintText: "Pilih iuran",
                      width: double.maxFinite,
                      requestFocusOnTap: false,
                      dropdownMenuEntries: kategoriIuranList.map((kategori) {
                        return DropdownMenuEntry<String>(
                          value: kategori.nama,
                          label: kategori.nama,
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedKategoriIuran = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Periode
                  const Text(
                    "Periode (Bulan & Tahun)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedPeriode ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedPeriode = pickedDate;
                          periodeController.text =
                              DateFormat('MMMM yyyy', 'id').format(pickedDate);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: periodeController,
                        decoration: InputDecoration(
                          hintText: "Pilih bulan & tahun",
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
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _reset,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side:
                                const BorderSide(color: AppStyles.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Reset Filter",
                            style: TextStyle(color: AppStyles.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
                          onPressed: _apply,
                          customBackgroundColor: AppStyles.primaryColor,
                          child: const Text(
                            "Terapkan",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    statusPembayaranController.dispose();
    statusKeluargaController.dispose();
    namaKeluargaController.dispose();
    kategoriIuranController.dispose();
    periodeController.dispose();
    super.dispose();
  }
}
