import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pemasukan_section_data.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/screens/keuangan/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class KategoriIuranSection extends StatefulWidget {
  const KategoriIuranSection({super.key});

  @override
  State<KategoriIuranSection> createState() => _KategoriIuranSectionState();
}

class _KategoriIuranSectionState extends State<KategoriIuranSection> {
  final TextEditingController namaIuran = TextEditingController();
  final TextEditingController jenisIuran = TextEditingController();
  final TextEditingController jenisIuranMenu = TextEditingController();
  final TextEditingController nominalIuran = TextEditingController();

  Future<void> _showDetailKategori(KategoriIuranData data) async {
    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (_) => [
        const Text(
          "Kategori Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.nama,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 12),
        const Text(
          "Jenis Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.jenis,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Nominal Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          "Rp${data.nominal},00",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        CustomButton(
          width: double.maxFinite,
          onPressed: () {
            context.pop();
            namaIuran.text = data.nama;
            jenisIuran.text = data.jenis;
            nominalIuran.text = data.nominal.toString();
            _showEditKategori();
          },
          child: const Text("Edit kategori"),
        ),
      ],
    );
  }

  Future<void> _showEditKategori() async {
    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (_) => [
        const Text(
          "Kategori Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        CustomTextField(
          controller: namaIuran,
          hintText: "Contoh: Tahunan",
        ),
        const SizedBox(height: 12),
        const Text(
          "Jenis Iuran (*tidak dapat diubah)",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        CustomTextField(
          enabled: false,
          controller: jenisIuran,
          hintText: "Contoh: Iuran Makan",
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        const SizedBox(height: 12),
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
    );
  }

  Future<void> _showTambahKategori() async {
    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (_) => [
        const Text(
          "Kategori Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        CustomTextField(
          controller: namaIuran,
          hintText: "Contoh: Tahunan",
        ),
        const SizedBox(height: 12),
        const Text(
          "Jenis Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        DropdownMenuTheme(
          data: DropdownMenuThemeData(
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              focusColor: AppStyles.primaryColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
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
                  WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up_rounded),
            controller: jenisIuranMenu,
            hintText: "Contoh: Iuran Khusus",
            width: double.maxFinite,
            requestFocusOnTap: false,
            dropdownMenuEntries: List.generate(
              PemasukanSectionData.jenisIuranList.length,
              (index) {
                final String valueIndex =
                    PemasukanSectionData.jenisIuranList[index];
                return DropdownMenuEntry(value: valueIndex, label: valueIndex);
              },
            ),
            onSelected: (value) {
              setState(() {
                if (value == null) {
                  jenisIuranMenu.clear();
                  return;
                }
                jenisIuranMenu.text = value;
              });
            },
            closeBehavior: DropdownMenuCloseBehavior.all,
          ),
        ),
        const SizedBox(height: 12),
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
        Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  "Tambah kategori",
                  textAlign: TextAlign.center,
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Kategori Iuran",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AppBarActionButton.filter(onTap: () {}),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: PemasukanSectionData.kategoriIuranData.length,
          itemBuilder: (context, index) {
            return kategoriItem(PemasukanSectionData.kategoriIuranData[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        backgroundColor: AppStyles.primaryColor,
        onPressed: () {
          namaIuran.clear();
          jenisIuran.clear();
          nominalIuran.clear();
          jenisIuranMenu.clear();
          _showTambahKategori();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget kategoriItem(Map<String, dynamic> json) {
    final KategoriIuranData kategori = KategoriIuranData.fromJson(json);

    return InkWell(
      onTap: () => _showDetailKategori(kategori),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width - 180),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        kategori.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      kategori.jenis,
                      style: const TextStyle(
                        color: AppStyles.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.white,
                  child: const Icon(Icons.more_vert_rounded, size: 20),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey),
                            SizedBox(width: 12),
                            Text("Detail kategori"),
                          ],
                        ),
                        onTap: () => _showDetailKategori(kategori),
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.edit_outlined, color: Colors.grey),
                            SizedBox(width: 12),
                            Text("Edit kategori"),
                          ],
                        ),
                        onTap: () {
                          namaIuran.text = kategori.nama;
                          jenisIuran.text = kategori.jenis;
                          nominalIuran.text = kategori.nominal.toString();
                          _showEditKategori();
                        },
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Rp${kategori.nominal},00",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class KategoriIuranData {
  final int no;
  final String nama;
  final String jenis;
  final int nominal;

  KategoriIuranData({
    required this.no,
    required this.nama,
    required this.jenis,
    required this.nominal,
  });

  factory KategoriIuranData.fromJson(Map<String, dynamic> json) {
    return KategoriIuranData(
      no: json['no'],
      nama: json['nama'],
      jenis: json['jenis'],
      nominal: json['nominal'],
    );
  }
}
