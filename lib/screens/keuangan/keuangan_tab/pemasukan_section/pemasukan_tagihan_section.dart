import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pemasukan_section_data.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/screens/keuangan/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class PemasukanTagihanSection extends StatefulWidget {
  PemasukanTagihanSection({super.key});

  @override
  State<PemasukanTagihanSection> createState() =>
      _PemasukanTagihanSectionState();
}

class _PemasukanTagihanSectionState extends State<PemasukanTagihanSection> {
  final TextEditingController kategoriIuranMenu = TextEditingController();
  final TextEditingController tanggalTagihanController = TextEditingController();

  final List<TagihanKeluarga> tagihanKeluarga = List.generate(
    PemasukanSectionData.tagihanIuranData.length,
    (index) {
      return TagihanKeluarga.fromJson(
        PemasukanSectionData.tagihanIuranData[index],
      );
    },
  );

  Future<void> _showTambahKategori() async {
    kategoriIuranMenu.clear();
    tanggalTagihanController.clear();
    DateTime? selectedDate;

    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (setModalState) => [
        const Text(
          "Tagih iuran \nke semua keluarga aktif",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        const Text(
          "Kategori Iuran",
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
                  WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up_rounded),
            controller: kategoriIuranMenu,
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
              setModalState(() {
                if (value == null) {
                  kategoriIuranMenu.clear();
                  return;
                }
                kategoriIuranMenu.text = value;
              });
            },
            closeBehavior: DropdownMenuCloseBehavior.all,
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          "Tanggal Tagihan",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: kategoriIuranMenu.text.isNotEmpty ? () async {
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
          } : null,
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
                  borderSide: BorderSide(color: AppStyles.primaryColor, width: 1.5),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Tagihan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AppBarActionButton.filter(onTap: () {}),
          const SizedBox(width: 8),
          AppBarActionButton.pdfDownload(onTap: () {}),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 88),
          itemCount: tagihanKeluarga.length,
          itemBuilder: (context, index) {
            return tagihanItemData(tagihanKeluarga[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        backgroundColor: AppStyles.primaryColor,
        onPressed: () {
          _showTambahKategori();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget tagihanItemData(TagihanKeluarga tagihanKeluarga) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusGeometry.circular(8),
        border: Border.all(color: AppStyles.backgroundColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            overflow: TextOverflow.ellipsis,
            tagihanKeluarga.nama,
            style: const TextStyle(
              fontSize: 16,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 1),
              SizedBox(
                height: 14,
                width: 14,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        (tagihanKeluarga.statusKeluarga == StatusKeluarga.aktif)
                            ? AppStyles.successColor
                            : AppStyles.errorColor,
                    borderRadius: BorderRadiusGeometry.circular(50),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tagihanKeluarga.statusKeluarga.label,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      (tagihanKeluarga.statusKeluarga == StatusKeluarga.aktif)
                          ? AppStyles.successColor
                          : AppStyles.errorColor,
                ),
              ),
              // Expanded(child: const SizedBox(width: 32)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(width: 32),
              SizedBox(
                height: 16,
                width: 14,
                child: Icon(
                  Icons.date_range,
                  color: Colors.grey.shade500,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Iuran ${tagihanKeluarga.kategori}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Rp${tagihanKeluarga.nominal},00",
                style: TextStyle(
                  fontSize: 16,
                  color: (tagihanKeluarga.statusTagihan == StatusTagihan.belum)
                      ? Colors.grey.shade700
                      : Colors.grey.shade500,
                  decoration:
                      (tagihanKeluarga.statusTagihan == StatusTagihan.ditolak)
                          ? TextDecoration.lineThrough
                          : null,
                  decorationColor: Colors.grey.shade500,
                ),
              ),
              const Expanded(child: SizedBox(width: 32)),
              // const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(4),
                  border: Border.all(
                    color:
                        (tagihanKeluarga.statusTagihan == StatusTagihan.belum)
                            ? AppStyles.warningSurfaceColor
                            : Colors.grey.shade500,
                  ),
                ),
                child: Text(
                  tagihanKeluarga.statusTagihan.label,
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        (tagihanKeluarga.statusTagihan == StatusTagihan.belum)
                            ? AppStyles.warningOnSurfaceColor
                            : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TagihanKeluarga {
  final String nama;
  final StatusKeluarga statusKeluarga;
  final String kategori;
  final String kodeTagihan;
  final int nominal;
  final String periode;
  final StatusTagihan statusTagihan;

  TagihanKeluarga({
    required this.nama,
    required this.statusKeluarga,
    required this.kategori,
    required this.kodeTagihan,
    required this.nominal,
    required this.periode,
    required this.statusTagihan,
  });

  factory TagihanKeluarga.fromJson(Map<String, dynamic> json) {
    return TagihanKeluarga(
      nama: json["namaKeluarga"],
      statusKeluarga: json["statusKeluarga"] as StatusKeluarga,
      kategori: json["kategori"],
      kodeTagihan: json["kodeTagihan"],
      nominal: json["nominal"],
      periode: json["periode"],
      statusTagihan: json["statusTagihan"] as StatusTagihan,
    );
  }
}
