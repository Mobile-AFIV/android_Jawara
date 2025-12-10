import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/models/kategori_iuran.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pemasukan_section_data.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/screens/keuangan/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/services/kategori_iuran_service.dart';
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

  Future<void> _showDetailKategori(KategoriIuran kategori) async {
    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (_) => [
        const Text(
          "Kategori Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          kategori.nama,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 12),
        const Text(
          "Jenis Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          kategori.jenis,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Nominal Iuran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          "Rp${kategori.nominal},00",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        CustomButton(
          width: double.maxFinite,
          onPressed: () {
            context.pop();
            namaIuran.text = kategori.nama;
            jenisIuran.text = kategori.jenis;
            nominalIuran.text = kategori.nominal.toString();
            _showEditKategori(kategori);
          },
          child: const Text("Edit kategori"),
        ),
      ],
    );
  }

  Future<void> _showEditKategori(KategoriIuran kategori) async {
    bool kategoriIsError = false,
        jenisIuranIsError = false,
        nominalIsError = false;

    ModalBottomSheet.showCustomModalBottomSheet(
        context: context,
        children: (setModalState) {
          bool formValidateError() {
            setModalState(() {
              kategoriIsError = namaIuran.text.isEmpty;
              jenisIuranIsError = jenisIuran.text.isEmpty;
              nominalIsError = nominalIuran.text.isEmpty;
            });

            return kategoriIsError || jenisIuranIsError || nominalIsError;
          }

          return [
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
                      if (formValidateError()) return;

                      Map<String, dynamic> data = {};

                      if (namaIuran.text != kategori.nama) {
                        data['nama'] = namaIuran.text;
                      }
                      if (double.parse(nominalIuran.text) != kategori.nominal) {
                        data['nominal'] = double.parse(nominalIuran.text);
                      }
                      if (jenisIuran.text != kategori.jenis) {
                        data['jenis_iuran'] = jenisIuran.text;
                      }

                      KategoriIuranService.instance.updateKategori(
                        id: kategori.id,
                        kategoriBaru: data,
                      );

                      setState(() {});

                      context.pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppStyles.successColor,
                          content: Text('Kategori berhasil diperbarui!'),
                        ),
                      );
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
          ];
        });
  }

  Future<void> _showTambahKategori() async {
    bool kategoriIsError = false,
        jenisIuranIsError = false,
        nominalIsError = false;

    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (setModalState) {
        bool formValidateError() {
          setModalState(() {
            kategoriIsError = namaIuran.text.isEmpty;
            jenisIuranIsError = jenisIuranMenu.text.isEmpty;
            nominalIsError = nominalIuran.text.isEmpty;
          });

          return kategoriIsError || jenisIuranIsError || nominalIsError;
        }

        return [
          Visibility(
            visible: kategoriIsError || jenisIuranIsError || nominalIsError,
            child: Container(
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                color: AppStyles.errorColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text("Semua field harus diisi!"),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Kategori Iuran",
            style: TextStyle(
                fontSize: 12,
                color: kategoriIsError ? AppStyles.errorColor : Colors.grey),
          ),
          const SizedBox(height: 4),
          CustomTextField(
            controller: namaIuran,
            hintText: "Contoh: Tahunan",
          ),
          const SizedBox(height: 12),
          Text(
            "Jenis Iuran",
            style: TextStyle(
                fontSize: 12,
                color: jenisIuranIsError ? AppStyles.errorColor : Colors.grey),
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
              controller: jenisIuranMenu,
              hintText: "Contoh: Iuran Khusus",
              width: double.maxFinite,
              requestFocusOnTap: false,
              dropdownMenuEntries: List.generate(
                PemasukanSectionData.jenisIuranList.length,
                (index) {
                  final String valueIndex =
                      PemasukanSectionData.jenisIuranList[index];
                  return DropdownMenuEntry(
                      value: valueIndex, label: valueIndex);
                },
              ),
              onSelected: (value) {
                setModalState(() {
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
          Text(
            "Nominal Iuran",
            style: TextStyle(
                fontSize: 12,
                color: nominalIsError ? AppStyles.errorColor : Colors.grey),
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
                    if (formValidateError()) return;

                    KategoriIuranService.instance.createKategori(
                      nama: namaIuran.text,
                      nominal: int.parse(nominalIuran.text),
                      jenisIuran: jenisIuranMenu.text,
                    );

                    setState(() {});

                    context.pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppStyles.successColor,
                        content: Text('Kategori baru berhasil ditambahkan!'),
                      ),
                    );
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
        ];
      },
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
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      body: SafeArea(
        child: FutureBuilder<List<KategoriIuran>>(
          future: KategoriIuranService.instance.getAllKategori(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return kategoriItemShimmer();
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    width: double.maxFinite,
                    color: Colors.grey.shade300,
                  );
                },
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (!snapshot.hasData && snapshot.data == null) {
              return const Center(child: Text("Tidak ada kategori"));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("Kategori Iuran Kosong"));
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return kategoriItem(snapshot.data![index]);
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 1,
                  width: double.maxFinite,
                  color: Colors.grey.shade300,
                );
              },
            );
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

  Widget kategoriItem(KategoriIuran kategori) {
    return InkWell(
      onTap: () => _showDetailKategori(kategori),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
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
                          fontWeight: FontWeight.bold,
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
                          _showEditKategori(kategori);
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

  Widget kategoriItemShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 80,
      color: Colors.grey.withValues(alpha: 0.2),
    );
  }
}

// class KategoriIuranData {
//   final int no;
//   final String nama;
//   final String jenis;
//   final int nominal;
//
//   KategoriIuranData({
//     required this.no,
//     required this.nama,
//     required this.jenis,
//     required this.nominal,
//   });
//
//   factory KategoriIuranData.fromJson(Map<String, dynamic> json) {
//     return KategoriIuranData(
//       no: json['no'],
//       nama: json['nama'],
//       jenis: json['jenis'],
//       nominal: json['nominal'],
//     );
//   }
// }
