import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pemasukan_section_data.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class TambahPemasukanLainSection extends StatefulWidget {
  const TambahPemasukanLainSection({super.key});

  @override
  State<TambahPemasukanLainSection> createState() => _TambahPemasukanLainSectionState();
}

class _TambahPemasukanLainSectionState extends State<TambahPemasukanLainSection> {
  final TextEditingController kategoriPemasukanLainMenu = TextEditingController();
  final TextEditingController tanggalPemasukanController = TextEditingController();
  final TextEditingController nominalIuran = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Tambah Pemasukan Lain",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 1/2,
                  child: const Text(
                    "Buat Pemasukan Non Iuran Baru",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
            
                const Text(
                  "Nama Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const CustomTextField(
                  hintText: "Masukkan nama pemasukan",
                ),
                const SizedBox(height: 16),
            
                const Text(
                  "Tanggal Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: const Locale('id', 'ID'),
                    );
            
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        tanggalPemasukanController.text =
                        "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: tanggalPemasukanController,
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
                          borderSide: const BorderSide(color: AppStyles.primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
            
                const Text(
                  "Kategori Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                DropdownMenuTheme(
                  data: DropdownMenuThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
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
                      padding:
                      const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                    selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up_rounded),
                    controller: kategoriPemasukanLainMenu,
                    hintText: "Contoh: Bersih Desa",
                    width: double.maxFinite,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: List.generate(
                      PemasukanSectionData.kategoriIuranData.length,
                          (index) {
                        final String valueIndex =
                        PemasukanSectionData.kategoriIuranData[index]["nama"];
                        return DropdownMenuEntry(value: valueIndex, label: valueIndex);
                      },
                    ),
                    onSelected: (value) {
                      setState(() {
                        if (value == null) {
                          kategoriPemasukanLainMenu.clear();
                          return;
                        }
                        kategoriPemasukanLainMenu.text = value;
                      });
                    },
                    closeBehavior: DropdownMenuCloseBehavior.all,
                  ),
                ),
                const SizedBox(height: 16),
            
                const Text(
                  "Nominal Iuran",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                CustomTextField(
                  controller: nominalIuran,
                  hintText: "Contoh: 150000",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 16),
            
                const Text(
                  "Bukti Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 100,
                  width: double.maxFinite,
                  child: const Text(
                    "Upload bukti pemasukan (.png/.jpg)",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
            
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text("Simpan"),
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
            ),
          ),
        ),
      ),
    );
  }
}
