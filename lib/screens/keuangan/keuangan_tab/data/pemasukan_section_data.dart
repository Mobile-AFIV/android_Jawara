class PemasukanSectionData {
  static final List<Map<String, dynamic>> kategoriIuranData = [
    {
      'no': 1,
      'nama': 'Bersih Desa',
      'jenis': jenisIuranList[0],
      'nominal': 200000,
    },
    {
      'no': 2,
      'nama': 'Mingguan',
      'jenis': jenisIuranList[1],
      'nominal': 12000,
    },
    {
      'no': 3,
      'nama': 'Agustusan',
      'jenis': jenisIuranList[1],
      'nominal': 15000,
    },
  ];

  static final List<Map<String, dynamic>> pemasukanLainData = [
    {
      'no': 1,
      'nama': 'aaaaa',
      'jenisPemasukan': 'Dana Bantuan Pemerintah',
      'tanggal': '15 Oktober 2025',
      'nominal': 11000, // Rp 11.000,00
      'verifikator': 'Admin Jawara',
    },
    {
      'no': 2,
      'nama': 'Joki by firman',
      'jenisPemasukan': 'Pendapatan Lainnya',
      'tanggal': '13 Oktober 2025',
      'nominal': 49999997, // Rp 49.999.997,00
      'verifikator': 'Admin Jawara',
    },
    {
      'no': 3,
      'nama': 'tes',
      'jenisPemasukan': 'Pendapatan Lainnya',
      'tanggal': '12 Agustus 2025',
      'nominal': 10000, // Rp 10.000,00
      'verifikator': 'Admin Jawara',
    },
  ];

  static final List<String> jenisPemasukanList = [
    'Donasi',
    'Dana Bantuan Pemerintah',
    'Sumbangan Swadaya',
    'Hasil Usaha Kampung',
    'Pendapatan Lainnya',
  ];

  static final List<String> jenisIuranList = ['Iuran Bulanan', 'Iuran Khusus'];

  static final List<Map<String, dynamic>> tagihanIuranData = [
    {
      'namaKeluarga': 'Keluarga Habibie',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR175458A501',
      'nominal': 10000, // Rp 10.000
      'periode': '8 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Ijat',
      'statusKeluarga': StatusKeluarga.keluar,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR125953VQ04',
      'nominal': 10000,
      'periode': '12 Oktober 2025',
      'statusTagihan': StatusTagihan.ditolak,
    },
    {
      'namaKeluarga': 'Keluarga Habibie',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR185702KX01',
      'nominal': 10000,
      'periode': '15 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Habibie',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR223936NM01',
      'nominal': 10000,
      'periode': '30 September 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Munandar',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR223936ZJ02',
      'nominal': 10000,
      'periode': '30 September 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Suryani',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Agustusan',
      'kodeTagihan': 'IR2244069O01',
      'nominal': 15000, // Rp 15.000
      'periode': '10 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Munandar',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Agustusan',
      'kodeTagihan': 'IR224406BC02',
      'nominal': 15000,
      'periode': '10 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Suryani',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Agustusan',
      'kodeTagihan': 'IR224432PP01',
      'nominal': 15000,
      'periode': '30 September 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Munandar',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Agustusan',
      'kodeTagihan': 'IR224432KE02',
      'nominal': 15000,
      'periode': '30 September 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Rachman',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR121530BS01',
      'nominal': 10000,
      'periode': '9 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Nuraini',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR121530WV02',
      'nominal': 10000,
      'periode': '9 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Dimas Haryanto',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR125953BO01',
      'nominal': 10000,
      'periode': '12 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Nuraini',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR125953D102',
      'nominal': 10000,
      'periode': '12 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Raudhil',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR125953SA03',
      'nominal': 10000,
      'periode': '12 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Habibie',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Agustusan',
      'kodeTagihan': 'IR1350440W01',
      'nominal': 15000,
      'periode': '2 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Munandar',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Agustusan',
      'kodeTagihan': 'IR135044BA02',
      'nominal': 15000,
      'periode': '2 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Raudhil',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Agustusan',
      'kodeTagihan': 'IR135044JH03',
      'nominal': 15000,
      'periode': '2 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Ijat',
      'statusKeluarga': StatusKeluarga.keluar,
      'kategori': 'Agustusan',
      'kodeTagihan': 'IR135044FV04',
      'nominal': 15000,
      'periode': '2 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Habibie',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR123252D101',
      'nominal': 12000, // Rp 12.000
      'periode': '8 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
    {
      'namaKeluarga': 'Keluarga Munandar',
      'statusKeluarga': StatusKeluarga.aktif,
      'kategori': 'Mingguan',
      'kodeTagihan': 'IR123252KI02',
      'nominal': 12000,
      'periode': '8 Oktober 2025',
      'statusTagihan': StatusTagihan.belum,
    },
  ];
}

enum StatusKeluarga {
  aktif('Aktif'),
  keluar('Sudah Keluar');

  final String label;

  const StatusKeluarga(this.label);

  // static StatusKeluarga fromString(String value) {
  //   return StatusKeluarga.values.firstWhere(
  //         (e) => e.label == value,
  //     orElse: () => StatusKeluarga.aktif,
  //   );
  // }
}

enum StatusTagihan {
  belum('Belum Dibayar'),
  ditolak('Ditolak');

  final String label;

  const StatusTagihan(this.label);

  // static StatusTagihan fromString(String value) {
  //   return StatusTagihan.values.firstWhere(
  //         (e) => e.label == value,
  //     orElse: () => StatusTagihan.belum,
  //   );
  // }
}
