import 'package:flutter/material.dart';
import 'package:jawara_pintar/models/channel_transfer.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:flutter/services.dart';
import 'package:jawara_pintar/services/channel_transfer_service.dart';

class ChannelTransferSection extends StatefulWidget {
  const ChannelTransferSection({super.key});

  @override
  State<ChannelTransferSection> createState() => _ChannelTransferSectionState();
}

class _ChannelTransferSectionState extends State<ChannelTransferSection> {
  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController tipeCtrl = TextEditingController();
  final TextEditingController pemilikCtrl = TextEditingController();
  final TextEditingController norekCtrl = TextEditingController();

  final List<String> tipeOptions = ['Bank', 'E-Wallet', 'Mobile Banking', 'Transfer Manual'];
  String selectedTipe = "Rekening";

  String selectedFilter = "Semua";
  List<String> filterOptions = ["Semua", "Bank", "E-Wallet", "Mobile Banking", "Transfer Manual"];

  Future<void> _showEditChannel(ChannelTransfer channel) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Channel Transfer"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Channel"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tipeCtrl.text.isNotEmpty ? tipeCtrl.text : null,
                decoration: const InputDecoration(labelText: "Tipe"),
                items: tipeOptions.map((tipe) {
                  return DropdownMenuItem(value: tipe, child: Text(tipe));
                }).toList(),
                onChanged: (value) {
                  tipeCtrl.text = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pemilikCtrl,
                decoration: const InputDecoration(labelText: "Pemilik"),
              ),
              TextField(
                controller: norekCtrl,
                decoration: const InputDecoration(labelText: "Nomor Rekening"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedChannel = {
                "nama": namaCtrl.text,
                "tipe": tipeCtrl.text,
                "pemilik": pemilikCtrl.text,
                "no_rek": norekCtrl.text,
              };

              await ChannelTransferService.instance.updateChannelTransfer(
                id: channel.id,
                channelBaru: updatedChannel,
              );

              Navigator.pop(context); 
              setState(() {});
            },
            child: const Text("Simpan"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ],
      ),
    );
  }

  Future<void> _showTambahChannel() async {
    namaCtrl.clear();
    tipeCtrl.clear();
    pemilikCtrl.clear();
    norekCtrl.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Channel Transfer"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Channel"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Tipe"),
                items: tipeOptions.map((tipe) {
                  return DropdownMenuItem(value: tipe, child: Text(tipe));
                }).toList(),
                onChanged: (value) {
                  tipeCtrl.text = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pemilikCtrl,
                decoration: const InputDecoration(labelText: "Pemilik"),
              ),
              TextField(
                controller: norekCtrl,
                decoration: const InputDecoration(labelText: "Nomor Rekening"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newChannel = {
                "nama": namaCtrl.text,
                "tipe": tipeCtrl.text,
                "pemilik": pemilikCtrl.text,
                "no_rek": norekCtrl.text,
              };

              await ChannelTransferService.instance.createChannelTransfer(
                nama: newChannel["nama"]!,
                tipe: newChannel["tipe"]!,
                pemilik: newChannel["pemilik"]!,
                nomorRekening: newChannel["no_rek"]!,
              );

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Simpan"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Channel Transfer"),
        actions: [
          PopupMenuButton<String>(
            borderRadius: BorderRadius.circular(8),
            icon: const Icon(Icons.filter_alt, color: AppStyles.primaryColor),
            tooltip: 'Filter',
            onSelected: (value) {
              setState(() {
                selectedFilter = value ?? "Semua";
              });
            },
            itemBuilder: (context) {
              return filterOptions.map((filter) {
                return PopupMenuItem(
                  value: filter,
                  child: Text(filter),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<ChannelTransfer>>(
          future: ChannelTransferService.instance.getAllChannelTransfers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Tidak ada channel transfer."));
            }

            var channels = snapshot.data!;

            // Apply filter
            if (selectedFilter != "Semua") {
              channels = channels
                  .where((channel) => channel.tipe == selectedFilter)
                  .toList();
            }

            if (channels.isEmpty) {
              return Center(
                child: Text("Tidak ada channel transfer dengan tipe '$selectedFilter'."),
              );
            }

            return ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, i) {
                final channel = channels[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(38, 10, 150, 150),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.account_balance_wallet,
                            color: Colors.blue),
                      ),
                      title: Text(
                        channel.nama,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "${channel.tipe} • ${channel.pemilik}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nama: ${channel.nama}"),
                            Text("Tipe: ${channel.tipe}"),
                            Text("Pemilik: ${channel.pemilik}"),
                            Text("Nomor Rekening: ${channel.nomorRekening}"),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    namaCtrl.text = channel.nama;
                                    tipeCtrl.text = channel.tipe;
                                    pemilikCtrl.text = channel.pemilik;
                                    norekCtrl.text = channel.nomorRekening;
                                    _showEditChannel(channel);
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text("Edit"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final konfirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Konfirmasi Hapus"),
                                        content: const Text(
                                            "Apakah Anda yakin ingin menghapus channel transfer ini?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Hapus"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (konfirm == true) {
                                      await ChannelTransferService.instance
                                          .deleteChannelTransfer(channel.id);
                                      setState(() {});
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Hapus"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTambahChannel,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah Channel",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: AppStyles.primaryColor,
      ),
    );
  }
}
